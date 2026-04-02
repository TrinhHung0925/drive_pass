import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class GeminiService extends GetxService {
  /// Chạy: flutter run --dart-define=GROQ_API_KEY=gsk_xxx
  static const String _dartDefineKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );

  late String _apiKey;

  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'meta-llama/llama-4-scout-17b-16e-instruct';

  static const String _systemPrompt = '''
Bạn là trợ lý AI chuyên về thi bằng lái xe tại Việt Nam, hạng B2.
Nhiệm vụ của bạn:
- Giải đáp thắc mắc về luật giao thông đường bộ Việt Nam
- Giải thích ý nghĩa biển báo giao thông
- Hướng dẫn kỹ thuật lái xe an toàn
- Giúp ôn thi lý thuyết bằng lái B2 (600 câu hỏi)
- Giải thích các câu hỏi điểm liệt
- Tư vấn về mức phạt vi phạm giao thông

Hãy trả lời bằng tiếng Việt, ngắn gọn, chính xác và dễ hiểu.
Bạn ưu tiên chuyên môn về giao thông và lái xe, nhưng vẫn sẵn sàng trả lời các câu hỏi khác ngoài lĩnh vực này một cách thân thiện và hữu ích.
''';

  /// Lưu lịch sử hội thoại để AI nhớ ngữ cảnh
  final List<Map<String, String>> _chatHistory = [];

  Future<GeminiService> init() async {
    // 1. Ưu tiên dart-define
    _apiKey = _dartDefineKey;

    // 2. Fallback: đọc từ file config local
    if (_apiKey.isEmpty) {
      try {
        final configStr = await rootBundle.loadString('assets/env/config.json');
        final config = jsonDecode(configStr);
        _apiKey = config['GROQ_API_KEY'] ?? '';
      } catch (_) {}
    }

    if (_apiKey.isEmpty) {
      print('⚠️ GROQ_API_KEY chưa được cấu hình.');
      print('👉 Tạo file assets/env/config.json với nội dung:');
      print('   {"GROQ_API_KEY": "gsk_xxx"}');
      print('👉 Hoặc chạy: flutter run --dart-define=GROQ_API_KEY=gsk_xxx');
    }
    return this;
  }

  bool get isConfigured => _apiKey.isNotEmpty;

  void startNewChat() {
    _chatHistory.clear();
  }

  /// Gửi tin nhắn và nhận phản hồi
  Future<String> sendMessage(String message, {File? imageFile}) async {
    if (!isConfigured) {
      return 'Tính năng chat AI chưa được cấu hình.\n\n'
          '👉 Lấy API key miễn phí (không cần thẻ) tại:\nhttps://console.groq.com\n\n'
          'Sau đó paste vào file gemini_service.dart';
    }

    try {
      // Build user content
      dynamic userContent;
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        final base64Image = base64Encode(bytes);
        final mimeType = imageFile.path.toLowerCase().endsWith('.png')
            ? 'image/png'
            : 'image/jpeg';
        userContent = [
          {
            'type': 'text',
            'text': message.isNotEmpty ? message : 'Mô tả hình ảnh này (biển báo, tình huống giao thông,...)',
          },
          {
            'type': 'image_url',
            'image_url': {
              'url': 'data:$mimeType;base64,$base64Image',
            },
          },
        ];
      } else {
        userContent = message;
      }

      // Thêm tin nhắn user vào history (chỉ lưu text)
      _chatHistory.add({'role': 'user', 'content': message.isNotEmpty ? message : '[Hình ảnh]'});

      // Build messages array
      final messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': _systemPrompt},
        // Lịch sử cũ (text only)
        ..._chatHistory.sublist(0, _chatHistory.length - 1),
        // Tin nhắn hiện tại (có thể kèm ảnh)
        {'role': 'user', 'content': userContent},
      ];

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices']?[0]?['message']?['content'] ?? '';

        // Lưu response vào history
        _chatHistory.add({'role': 'assistant', 'content': content});

        // Giữ tối đa 20 cặp hội thoại để không quá dài
        if (_chatHistory.length > 40) {
          _chatHistory.removeRange(0, 2);
        }

        return content;
      } else if (response.statusCode == 429) {
        return 'Đã vượt giới hạn yêu cầu. Vui lòng thử lại sau ít phút.';
      } else if (response.statusCode == 401) {
        return 'API Key không hợp lệ. Vui lòng kiểm tra lại.';
      } else {
        final body = jsonDecode(response.body);
        final errMsg = body['error']?['message'] ?? 'Unknown error';
        return 'Lỗi: $errMsg';
      }
    } catch (e) {
      print('Groq error: $e');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return 'Không có kết nối mạng. Vui lòng kiểm tra internet.';
      }
      return 'Có lỗi xảy ra. Vui lòng thử lại.\n(${e.toString().split('\n').first})';
    }
  }

  void clearChat() {
    _chatHistory.clear();
  }
}
