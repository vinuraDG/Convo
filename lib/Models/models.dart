// Models
import 'dart:ui';

class ChatUser {
  final String name;
  final String message;
  final String time;
  final Color avatarColor;
  final bool isOnline;

  ChatUser({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarColor,
    this.isOnline = false,
  });
}

class StoryUser {
  final String name;
  final Color avatarColor;
  final bool hasStory;
  final bool isAddStory;

  StoryUser({
    required this.name,
    required this.avatarColor,
    this.hasStory = false,
    this.isAddStory = false,
  });
}