import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'signup.dart';

void main() {
  runApp(LoginApp());
}

// 로그인 페이지
class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 아이디, 비밀번호 정보
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // keep logged in 여부
  bool _keepLoggedIn = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // 로그인 성공 시 처리
      print("User logged in: ${userCredential.user!.uid}");
    } catch (e) {
      // 로그인 실패 시 처리
      print("Failed to log in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 이메일 입력 텍스트필드
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: CupertinoTextField(
                    controller: _emailController,
                    placeholder: 'Email',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // 비밀번호 입력 텍스트필드
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    textAlign: TextAlign.center,
                    obscureText: true,
                  ),
                ),
              ),
              // Checkbox asking whether to 'Keep logged in'
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Keep logged in ',
                    ),
                    Checkbox(
                      value: _keepLoggedIn,
                      onChanged: (bool? value) {
                        setState(() {
                          _keepLoggedIn = value ?? false;
                        });
                      },
                    ),
                    Text('    '),
                  ],
                ),
              ),
              // 로그인 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text('Continue'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red), // 버튼의 배경색을 빨간색으로 변경
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // 버튼의 글자색을 하얀색으로 변경
                    ),
                  ),
                ),
              ),
              // 회원가입 텍스트
              GestureDetector(
                onTap: () {
                  // TODO: 회원가입 페이지로 이동하는 로직 추가
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  "You don't have an account? Sign in",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
