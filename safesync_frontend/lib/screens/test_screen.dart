import 'package:flutter/material.dart';
import 'package:safesync_frontend/screens/login.dart';
import 'package:safesync_frontend/screens/feed_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 1),
                Text(
                  "Test Room",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(flex: 1),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginApp())
                      );
                    },
                    child: Text('Login')
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FeedScreen())
                      );
                    },
                    child: Text('Feed')
                ),
                Spacer(flex: 1),
              ]
          ),
        ),
      ),
    );
  }
}
