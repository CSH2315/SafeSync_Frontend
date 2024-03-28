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
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // 이메일 입력 필드
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 2) {
                        return 'It is not correct';
                      }
                      return null;
                    },
                    key: const ValueKey(1),
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: "Enter Your Email",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16.0),
                  // 비밀번호 입력 필드
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Password';
                      } else if (value.length < 6) {
                        return 'At least 6 characters';
                      }
                      return null;
                    },
                    key: const ValueKey(4),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: "Enter Your Password",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 16.0),

                  // Checkbox asking whether to 'Keep logged in'
                  Row(
                    children: [
                      Checkbox(
                        value: _keepLoggedIn,
                        onChanged: (bool? value) {
                          setState(() {
                            _keepLoggedIn = value ?? false;
                          });
                        },
                        activeColor: Color(0xFFB20000),
                        visualDensity: VisualDensity(horizontal: -4),
                      ),
                      Text(
                        'Keep logged in ',
                        style: TextStyle(
                          fontSize: 18, // 텍스트의 크기를 조정
                          color: _keepLoggedIn ? Color(0xFFB20000) : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  // 로그인 버튼
                  Container(
                    width: double.infinity, // 좌우 여백 추가
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFFB20000)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        // 텍스트 색상
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // 원하는 둥근 정도 설정
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size.fromHeight(50)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        // 위아래 8만큼의 padding 적용
                        child:
                            Text('Continue', style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                  ),
                  // 회원가입 텍스트
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: 회원가입 페이지로 이동하는 로직 추가
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "You don't have an account? ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
