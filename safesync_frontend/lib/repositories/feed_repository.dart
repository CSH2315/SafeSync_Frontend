import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safesync_frontend/exceptions/custom_exception.dart';
import 'package:safesync_frontend/model/feed_model.dart';
import 'package:safesync_frontend/utils/logger.dart';
import 'package:uuid/uuid.dart';

class FeedRepository {
  final FirebaseFirestore firebaseFirestore;

  const FeedRepository({
    required this.firebaseFirestore,
  });

  Future<List<FeedModel>> getFeeds() async {
    try {
      QuerySnapshot<Map<String, dynamic>> feedDocs = await firebaseFirestore.collection('feeds').orderBy('created_at', descending: true).get();
      return await Future.wait(feedDocs.docs.map((feedDoc) async {
        return FeedModel.fromMap(feedDoc.data());
      }).toList());
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } on CustomException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception(Internal)',
        message: e.toString(),
      );
    }
  }

  Future<void> uploadFeed({
    required String Title,
    required String Content,
    required String user_uid,
  }) async {
    try {
      String feed_uid = Uuid().v4();

      DocumentReference<Map<String, dynamic>> feedDocRef = firebaseFirestore.collection('feeds').doc(feed_uid);

      FeedModel feedModel = FeedModel(
        feed_uid: feed_uid,
        user_uid: user_uid,
        Title: Title,
        Content: Content,
        likes: 0,
        liked_users: [],
        createdAt: Timestamp.now(),
      );

      feedDocRef.set(feedModel.toMap());
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } on CustomException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception(Internal)',
        message: e.toString(),
      );
    }
  }

  Future<void> deleteFeed({
    required String feed_id,
  }) async {
    try {
      // TODO : 파배 규칙으로 한번 더 막아야함
      DocumentReference<Map<String, dynamic>> feedDocRef = firebaseFirestore.collection('feeds').doc(feed_id);
      logger.d((await feedDocRef.get()).data()!);
      FeedModel feedModel = FeedModel.fromMap((await feedDocRef.get()).data()!);
      // TODO : 권한확인 필요
      /*
      if(feedModel.user_uid != FirebaseAuth.instance.currentUser!.uid){
        throw CustomException(
          code: 'permission-denied',
          message: '작성자만 삭제할 수 있습니다.',
        );
      }
       */
      feedDocRef.delete();
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } on CustomException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception(Internal)',
        message: e.toString(),
      );
    }
  }

  Future<void> updateFeed({
    required String feed_id,
    required String Title,
    required String Content,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> feedDocRef = firebaseFirestore.collection('feeds').doc(feed_id);
      FeedModel feedModel = FeedModel.fromMap((await feedDocRef.get()).data()!);
      if(feedModel.user_uid != FirebaseAuth.instance.currentUser!.uid){
        throw CustomException(
          code: 'permission-denied',
          message: '작성자만 수정할 수 있습니다.',
        );
      }
      feedDocRef.update({
        'Title': Title,
        'Content': Content,
      });
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } on CustomException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception(Internal)',
        message: e.toString(),
      );
    }
  }

  Future<void> likeFeed({
    required String feed_id,
    required String user_uid,
  }) async {
    try {
      DocumentReference<Map<String, dynamic>> feedDocRef = firebaseFirestore.collection('feeds').doc(feed_id);
      FeedModel feedModel = FeedModel.fromMap((await feedDocRef.get()).data()!);

      List<dynamic> liked_users = feedModel.liked_users;
      if(liked_users.contains(user_uid)){
        liked_users.remove(user_uid);
      } else {
        liked_users.add(user_uid);
      }

      feedDocRef.update({
        'liked_users': liked_users,
        'likes': liked_users.length,
      });
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message!,
      );
    } on CustomException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message,
      );
    } catch (e) {
      throw CustomException(
        code: 'Exception(Internal)',
        message: e.toString(),
      );
    }
  }
}