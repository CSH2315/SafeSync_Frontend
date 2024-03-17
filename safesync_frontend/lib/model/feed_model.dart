import 'package:cloud_firestore/cloud_firestore.dart';

class FeedModel {
  final String feed_uid;
  final String user_uid;
  final String Title;
  final String Content;
  final int likes;
  final List<dynamic> liked_users;
  final Timestamp createdAt;

  const FeedModel({
    required this.feed_uid,
    required this.user_uid,
    required this.Title,
    required this.Content,
    required this.likes,
    required this.liked_users,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'feed_uid': feed_uid,
      'user_uid': user_uid,
      'Title': Title,
      'Content': Content,
      'likes': likes,
      'liked_users': liked_users,
      'created_at': createdAt,
    };
  }

  factory FeedModel.fromMap(
      Map<String, dynamic> map
  ) {
    return FeedModel(
      feed_uid: map['feed_uid'],
      user_uid: map['user_uid'],
      Title: map['Title'],
      Content: map['Content'],
      likes: map['likes'],
      liked_users: map['liked_users'],
      createdAt: map['created_at'],
    );
  }
}