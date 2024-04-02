import 'package:flutter/material.dart';

// Screens
import 'package:safesync_frontend/screens/test_screen.dart';

// Feed Repository, Provider and State
import 'package:safesync_frontend/repositories/feed_repository.dart';
import 'package:safesync_frontend/providers/feed/feed_provider.dart';
import 'package:safesync_frontend/providers/feed/feed_state.dart';

// Provider and State Notifier
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// env
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await dotenv.load(fileName: "assets/config/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => FeedRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StateNotifierProvider<FeedProvider, FeedState>(
          create: (context) => FeedProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TestScreen()
      ),
    );
  }
}
