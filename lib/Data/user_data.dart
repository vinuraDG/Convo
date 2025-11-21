// Sample chat data
  import 'package:convo_app/Models/models.dart';
import 'package:flutter/material.dart';

final List<ChatUser> chats = [
    ChatUser(
      name: 'Deelaka',
      message: 'Hey! How are you doing today?',
      time: '12:30',
      avatarColor: Colors.purple,
      isOnline: true,
    ),
    ChatUser(
      name: 'Samsul',
      message: 'Hey! How are you doing today?',
      time: '11:05',
      avatarColor: Colors.deepPurple,
      isOnline: false,
    ),
    ChatUser(
      name: 'Priya',
      message: 'Hey! How are you doing today?',
      time: '10:30',
      avatarColor: Colors.pink,
      isOnline: true,
    ),
    ChatUser(
      name: 'Chanika',
      message: 'Hey! How are you doing today?',
      time: '3:20',
      avatarColor: Colors.indigo,
      isOnline: false,
    ),
  ];