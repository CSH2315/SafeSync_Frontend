import 'package:flutter/material.dart';
import 'package:safesync_frontend/providers/feed/feed_provider.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final FeedProvider _feedProvider;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _uidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _feedProvider = context.read<FeedProvider>();
      _feedProvider.loadFeed();
    });
  }

  void doReload() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: CircularProgressIndicator()
          ),
        );
      },
    );

    await _feedProvider.loadFeed();

    Navigator.pop(context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _uidController.text = 'Test_UID_1';
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _uidController,
                  decoration: InputDecoration(
                    labelText: 'UID',
                  ),
                ),
              ),
              Consumer<FeedProvider>(
                builder: (context, feedProvider, child) {
                  if (feedProvider.state.feedList.isEmpty) {
                    return Center(child: Text('No feeds available'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: feedProvider.state.feedList.length,
                      itemBuilder: (context, index) {
                        var feed = feedProvider.state.feedList[index];
                        return InkWell(
                          onTap: () {
                            feedProvider.likeFeed(
                              feed_id: feed.feed_uid,
                              user_uid: _uidController.text,
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text('Title: ${feed.Title}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Content: ${feed.Content}'),
                                  Text('User UID: ${feed.user_uid}'),
                                  Text('Feed UID: ${feed.feed_uid}'),
                                  Text('Created At: ${feed.createdAt}'),
                                  Text('liked_users: ${feed.liked_users}')
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await feedProvider.deleteFeed(
                                        feed_id: feed.feed_uid,
                                      );
                                      doReload();
                                    },
                                  ),
                                  Text('Likes: ${feed.likes}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _feedProvider.uploadFeed(
                          Title: _titleController.text,
                          Content: _contentController.text,
                          user_uid: _uidController.text,
                        );
                        doReload();
                        _titleController.clear();
                        _contentController.clear();
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          doReload();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
