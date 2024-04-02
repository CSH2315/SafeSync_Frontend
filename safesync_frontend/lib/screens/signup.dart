import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  String _verificationId = '';

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 회원가입 성공 시 처리
      print("User registered: ${userCredential.user!.uid}");

      // 인증번호 확인
      _certify();
    } catch (e) {
      // 회원가입 실패 시 처리
      print("Failed to register: $e");
    }
  }

  void _startPhoneVerification() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('인증 문자 수신');
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e);
          print('인증 문자 전송 실패');
        },
        codeSent: (String verificationId, int? resendToken) async {
          print('인증 문자 전송');
          setState(() {
            _verificationId = verificationId; // 인증 코드 확인때 필요한 값
          });
        },
        codeAutoRetrievalTimeout: (String verificationId){},
      );
    } catch (e) {
      print("Failed to start phone verification: $e");
    }
  }

  Future<void> _certify() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: _verificationCodeController.text);
      final UserCredential authCredential = await _auth.signInWithCredential(credential);

      // 인증 성공 시 처리
      print("Phone number verified: ${authCredential.user!.phoneNumber}");
    } catch (e) {
      // 인증 실패 시 처리
      print("Failed to verify phone number: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: '휴대폰 번호'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _verificationCodeController,
              decoration: InputDecoration(labelText: '인증 번호'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('회원가입'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _startPhoneVerification,
              child: Text('인증번호 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
