import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:safesync_frontend/exceptions/custom_exception.dart';
import 'package:safesync_frontend/model/feed_model.dart';
import 'package:safesync_frontend/providers/feed/feed_state.dart';
import 'package:safesync_frontend/repositories/feed_repository.dart';
import 'package:safesync_frontend/utils/logger.dart';

class FeedProvider extends StateNotifier<FeedState> with LocatorMixin {
  FeedProvider() : super(FeedState.init());

  Future<void> loadFeed() async {
    try{
      state = state.copyWith(feedStatus: FeedStatus.fetching);

      List<FeedModel> feedList = await read<FeedRepository>().getFeeds();
      logger.d("Feed List: $feedList");

      state = state.copyWith(
          feedList: feedList,
          feedStatus: FeedStatus.success
      );
    } on CustomException catch(_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }

  Future<void> uploadFeed({
    required String Title,
    required String Content,
    required String user_uid,
  }) async {
    try{
      state = state.copyWith(feedStatus: FeedStatus.submitting);

      await read<FeedRepository>().uploadFeed(
        Title: Title,
        Content: Content,
        user_uid: user_uid,
      );

      state = state.copyWith(feedStatus: FeedStatus.success);
    } on CustomException catch(_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }

  Future<void> updateFeed({
    required String feed_id,
    required String Title,
    required String Content,
  }) async {
    try{
      state = state.copyWith(feedStatus: FeedStatus.submitting);

      await read<FeedRepository>().updateFeed(
        feed_id: feed_id,
        Title: Title,
        Content: Content,
      );

      state = state.copyWith(feedStatus: FeedStatus.success);
    } on CustomException catch(_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }

  Future<void> deleteFeed({
    required String feed_id,
  }) async {
    try{
      state = state.copyWith(feedStatus: FeedStatus.submitting);

      logger.d("Feed ID: $feed_id");
      await read<FeedRepository>().deleteFeed(
        feed_id: feed_id,
      );

      state = state.copyWith(feedStatus: FeedStatus.success);
    } on CustomException catch(_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }

Future<void> likeFeed({
    required String feed_id,
    required String user_uid,
  }) async {
    try{
      state = state.copyWith(feedStatus: FeedStatus.submitting);

      logger.d("Feed ID: $feed_id, User UID: $user_uid");

      await read<FeedRepository>().likeFeed(
        feed_id: feed_id,
        user_uid: user_uid,
      );

      state = state.copyWith(feedStatus: FeedStatus.success);
    } on CustomException catch(_) {
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }
}