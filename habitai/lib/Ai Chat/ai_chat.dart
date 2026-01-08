import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'simple_chat_controller.dart';
import '../theme/app_theme.dart';


class AICoachChatScreen extends GetView<SimpleChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildHeader(context),
          _buildChatMessages(context),
          _buildChatInput(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: controller.onBackPressed,
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Coach',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Obx(() => Text(
                    controller.isTyping.value ? 'Typing...' : 'Online',
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '✨',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(width: 6),
                Text(
                  'Beta',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() => ListView.builder(
          controller: controller.chatScrollController,
          itemCount: controller.chatMessages.length + (controller.isTyping.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (controller.isTyping.value && index == controller.chatMessages.length) {
              return _buildTypingIndicator(context);
            }

            final message = controller.chatMessages[index];
            return _buildChatMessage(context, message);
          },
        )),
      ),
    );
  }

  Widget _buildChatInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.chatController,
              decoration: InputDecoration(
                hintText: 'Ask your AI coach...',
                hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [AppColors.darkPrimary, AppColors.darkSecondary]
                      : [AppColors.lightPrimary, AppColors.lightSecondary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(BuildContext context, SimpleChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: Theme.of(context).brightness == Brightness.dark
                          ? [AppColors.darkPrimary, AppColors.darkSecondary]
                          : [AppColors.lightPrimary, AppColors.lightSecondary],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Center(
                    child: Text('🤖', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Theme.of(context).colorScheme.onBackground,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Show next questions if available
          if (!message.isUser && message.nextQuestions != null && message.nextQuestions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: message.nextQuestions!.map((question) =>
                  GestureDetector(
                    onTap: () => controller.onQuestionTap(question),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        question,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: context.primaryGradient,
            ),
            child: const Center(
              child: Text('🤖', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(context, 0),
                const SizedBox(width: 4),
                _buildTypingDot(context, 1),
                const SizedBox(width: 4),
                _buildTypingDot(context, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: controller.floatingController,
      builder: (context, child) {
        final value = controller.floatingController.value;
        final animatedValue = (value + (index * 0.3)) % 1.0;
        final opacity = (animatedValue < 0.5) ? animatedValue * 2 : (1 - animatedValue) * 2;

        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: context.textColor.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}