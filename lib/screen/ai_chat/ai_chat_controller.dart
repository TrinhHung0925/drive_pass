import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/chat_message.dart';
import '../../service/gemini_service.dart';
import '../../service/local_service.dart';

class AiChatController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  final selectedImage = Rxn<File>();

  late final GeminiService _geminiService;
  late final LocalService _localService;
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _geminiService = Get.find<GeminiService>();
    _localService = Get.find<LocalService>();
    _loadHistory();
  }

  void _loadHistory() {
    final history = _localService.getChatHistory();
    if (history.isNotEmpty) {
      messages.addAll(history);
    } else {
      messages.add(ChatMessage.ai(
        'Xin chào! 👋 Tôi là trợ lý AI chuyên về thi bằng lái xe B2.\n\n'
        'Bạn có thể hỏi tôi về:\n'
        '• Luật giao thông đường bộ\n'
        '• Ý nghĩa biển báo\n'
        '• Kỹ thuật lái xe\n'
        '• Giải đáp câu hỏi thi\n'
        '• Mức phạt vi phạm\n\n'
        'Hãy đặt câu hỏi nhé! 🚗📷 Bạn cũng có thể gửi ảnh biển báo để tôi nhận diện.',
      ));
    }
  }

  /// Chọn ảnh từ thư viện
  Future<void> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  /// Chụp ảnh từ camera
  Future<void> takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  /// Hủy ảnh đã chọn
  void removeSelectedImage() {
    selectedImage.value = null;
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    final imageFile = selectedImage.value;
    if (text.isEmpty && imageFile == null || isTyping.value) return;

    final userMsg = ChatMessage.user(
      text.isNotEmpty ? text : '📷 Hình ảnh',
      imagePath: imageFile?.path,
    );
    messages.add(userMsg);
    textController.clear();
    selectedImage.value = null;

    isTyping.value = true;

    final response = await _geminiService.sendMessage(text, imageFile: imageFile);

    final aiMsg = ChatMessage.ai(response);
    messages.add(aiMsg);
    isTyping.value = false;

    _localService.saveChatHistory(messages.toList());
  }

  void clearChat() {
    _geminiService.clearChat();
    _localService.clearChatHistory();
    messages.clear();
    messages.add(ChatMessage.ai(
      'Cuộc trò chuyện đã được xóa.\nHãy đặt câu hỏi mới nhé! 🚗',
    ));
  }

  /// Quick suggestion chips
  List<String> get suggestions => [
    'Biển báo cấm là gì?',
    'Câu hỏi điểm liệt là gì?',
    'Tốc độ trong khu dân cư?',
    'Khoảng cách an toàn?',
    'Quy tắc nhường đường?',
  ];

  void sendSuggestion(String text) {
    textController.text = text;
    sendMessage();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
