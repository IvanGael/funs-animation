// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class ChatWithBubbleAnimation extends StatelessWidget {
  const ChatWithBubbleAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Bubbles'),
        ),
        body: const ChatScreen(),
      );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ChatBubble(
          message: 'Hello!',
          isMe: false,
        ),
        SizedBox(height: 20),
        ChatBubble(
          message: 'Hi there!',
          isMe: true,
        ),
        SizedBox(height: 20),
        ChatBubble(
          message: 'How are you?',
          isMe: false,
        ),
        SizedBox(height: 20),
        ChatBubble(
          message: 'I\'m good, thanks!',
          isMe: true,
        ),
      ],
    );
  }
}

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _bounceAnimation,
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: widget.isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: widget.isMe ? Colors.blue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.isMe ? Colors.white : Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
