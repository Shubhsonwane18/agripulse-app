import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/chat_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/chat_viewmodel.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final chatVm = context.watch<ChatViewModel>();
    final loc = authVm.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get('chatTitle', locale: loc),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Text(
              AppStrings.get('chatSubtitle', locale: loc),
              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 10),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Messages Stream
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatVm.messages.length,
              itemBuilder: (context, idx) {
                final msg = chatVm.messages[idx];
                return _buildMessageBubble(context, msg, chatVm);
              },
            ),
          ),

          // 2. Quick Prompts Chips
          if (chatVm.messages.isNotEmpty && chatVm.messages.last.quickReplies != null)
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: chatVm.messages.last.quickReplies!.map((reply) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(reply, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.accentLight),
                      onPressed: () {
                        chatVm.sendMessage(reply, loc);
                        _scrollToBottom();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 6),

          // 3. Bottom Chat & Voice Controls
          _buildInputBar(context, chatVm, loc),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage msg, ChatViewModel chatVm) {
    final isUser = msg.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: AppColors.cardBorder),
          boxShadow: const [
            BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: TextStyle(
                fontSize: 13,
                color: isUser ? Colors.white : AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            if (msg.audioUrl != null) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () => chatVm.playAudio(msg.audioUrl!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(chatVm.isPlaying ? Icons.pause : Icons.volume_up, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'व्हॉईस नोट ऐका (Audio)',
                        style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, ChatViewModel chatVm, String loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Voice Mic Button
            GestureDetector(
              onLongPressStart: (_) => chatVm.startRecording(),
              onLongPressEnd: (_) => chatVm.stopRecordingAndSend(loc),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: chatVm.isRecording ? Colors.red : AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  color: chatVm.isRecording ? Colors.white : AppColors.primary,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Text Field
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: AppStrings.get('chatPlaceholder', locale: loc),
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: AppColors.surfaceVariant,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onSubmitted: (text) {
                  chatVm.sendMessage(text, loc);
                  _controller.clear();
                  _scrollToBottom();
                },
              ),
            ),
            const SizedBox(width: 8),

            // Send Button
            IconButton(
              icon: const Icon(Icons.send_rounded, color: AppColors.primary),
              onPressed: () {
                final txt = _controller.text;
                if (txt.trim().isNotEmpty) {
                  chatVm.sendMessage(txt, loc);
                  _controller.clear();
                  _scrollToBottom();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
