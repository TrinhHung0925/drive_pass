import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../model/chat_message.dart';
import '../../resource/app_colors.dart';
import 'ai_chat_controller.dart';

class AiChatView extends StatefulWidget {
  AiChatView({super.key}) {
    if (!Get.isRegistered<AiChatController>()) {
      Get.put(AiChatController(), permanent: true);
    }
  }

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  var controller = Get.find<AiChatController>();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () {
      controller.focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(child: _buildChatList()),
            _buildSuggestionChips(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ─────────────────── APP BAR ────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: () => Get.back(),
        child: Icon(Icons.arrow_back_ios_new_rounded, size: 20.w, color: AppColors.textPrimary),
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20.w),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trợ lý AI',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  Obx(
                    () => Text(
                      controller.isTyping.value ? 'Đang trả lời...' : 'Llama 4 Scout • Miễn phí',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: controller.isTyping.value ? AppColors.success : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: _showClearDialog,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8.r)),
                child: Icon(Icons.refresh_rounded, size: 18.w, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  // ─────────────────── CHAT LIST (reverse like Zalo) ─────────────────────
  Widget _buildChatList() {
    return Obx(() {
      // Build items: typing indicator (index 0 in reverse) + messages reversed
      final hasTyping = controller.isTyping.value;
      final msgCount = controller.messages.length;
      final totalCount = msgCount + (hasTyping ? 1 : 0);

      return ListView.builder(
        controller: controller.scrollController,
        reverse: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (hasTyping && index == 0) {
            return _buildTypingIndicator();
          }

          final msgIndex = msgCount - 1 - (hasTyping ? index - 1 : index);
          if (msgIndex < 0 || msgIndex >= msgCount) {
            return const SizedBox.shrink();
          }
          return _buildMessageBubble(controller.messages[msgIndex]);
        },
      );
    });
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16.w),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: isUser ? Radius.circular(16.r) : Radius.circular(4.r),
                  bottomRight: isUser ? Radius.circular(4.r) : Radius.circular(16.r),
                ),
                border: isUser ? null : Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị ảnh nếu có
                  if (message.hasImage) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: File(message.imagePath!).existsSync()
                          ? Image.file(
                              File(message.imagePath!),
                              width: 200.w,
                              height: 200.w,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 200.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported_rounded, color: Colors.white70, size: 28.w),
                                  SizedBox(height: 4.h),
                                  Text('Ảnh không còn', style: TextStyle(fontSize: 11.sp, color: Colors.white70)),
                                ],
                              ),
                            ),
                    ),
                    if (message.content.isNotEmpty && message.content != '📷 Hình ảnh')
                      SizedBox(height: 8.h),
                  ],
                  // Text content
                  if (!message.hasImage || (message.content.isNotEmpty && message.content != '📷 Hình ảnh'))
                    SelectableText(
                      message.content,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: isUser ? Colors.white : AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.person_rounded, color: AppColors.primary, size: 18.w),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16.w),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(4.r),
                bottomRight: Radius.circular(16.r),
              ),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ─────────────────── SUGGESTION CHIPS ───────────────────────────────────
  Widget _buildSuggestionChips() {
    return Obx(() {
      if (controller.messages.length > 3) return const SizedBox.shrink();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: controller.suggestions.map((s) {
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () => controller.sendSuggestion(s),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lightbulb_outline_rounded, size: 14.w, color: AppColors.primary),
                        SizedBox(width: 6.w),
                        Text(
                          s,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  // ─────────────────── INPUT BAR ──────────────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(
        left: 12.w,
        right: 8.w,
        top: 8.h,
        bottom: MediaQuery.of(context).padding.bottom + 10.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview ảnh đã chọn
          Obx(() {
            final img = controller.selectedImage.value;
            if (img == null) return const SizedBox.shrink();
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.file(img, width: 70.w, height: 70.w, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: controller.removeSelectedImage,
                          child: Container(
                            width: 22.w,
                            height: 22.w,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close_rounded, size: 14.w, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

               
                ],
              ),
            );
          }),
          // Input row
          Row(
            children: [
              // Nút chọn ảnh
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: _showImagePicker,
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(19.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(Icons.camera_alt_rounded, size: 20.w, color: AppColors.primary),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: controller.textController,
                    focusNode: controller.focusNode,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.sendMessage(),
                    style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Hỏi về luật giao thông...',
                      hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textLight),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: controller.isTyping.value ? null : controller.sendMessage,
                  child: Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      gradient: controller.isTyping.value
                          ? null
                          : const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                      color: controller.isTyping.value ? AppColors.border : null,
                      borderRadius: BorderRadius.circular(21.r),
                    ),
                    child: Icon(Icons.send_rounded, size: 20.w, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bottom sheet chọn ảnh: Thư viện hoặc Camera
  void _showImagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Gửi hình ảnh'),
        message: const Text('Chụp hoặc chọn ảnh biển báo, câu hỏi để AI nhận diện'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              controller.takePhoto();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 20.w),
                SizedBox(width: 8.w),
                const Text('Chụp ảnh'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              controller.pickImage();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library_rounded, color: AppColors.primary, size: 20.w),
                SizedBox(width: 8.w),
                const Text('Chọn từ thư viện'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
      ),
    );
  }

  // ─────────────────── CLEAR DIALOG ───────────────────────────────────────
  void _showClearDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Xóa cuộc trò chuyện'),
        content: const Text('Bạn có muốn xóa toàn bộ lịch sử chat và bắt đầu cuộc trò chuyện mới?'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Xóa'),
            onPressed: () {
              Navigator.pop(context);
              controller.clearChat();
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────── TYPING DOTS ANIMATION ────────────────────────────────
class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final y = -4.0 * (t < 0.5 ? t : 1.0 - t);
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              child: Transform.translate(
                offset: Offset(0, y),
                child: Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: BoxDecoration(
                    color: AppColors.textLight.withValues(alpha: 0.6 + 0.4 * (1 - t)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
