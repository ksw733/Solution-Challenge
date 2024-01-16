import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IdFindPage extends StatefulWidget {
  @override
  _IdFindPageState createState() => _IdFindPageState();
}

class _IdFindPageState extends State<IdFindPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9AD0C2),
      appBar: AppBar(
        title: Text('이메일 찾기'),
      ),
      body: Center(
        child: Container(
          width: 340,
          height: 360,
          decoration: ShapeDecoration(
            color: const Color(0xFFECF4D6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10.0),
                alignment: Alignment.centerLeft,
                child: Text("Email",
                style: TextStyle(
                color: Color(0xFF194062),
                fontSize: 20,
                fontFamily: 'Gowun Dodum',
                fontWeight: FontWeight.w400,
                height: 0,
                ),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _findId();
                },
                child: const Text(
                  '이메일 확인해보기',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xCC2D9596),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _findId() async {
    final String apiUrl = 'http://localhost:8080/signup/user';

    String email = _emailController.text;

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        String foundId = response.body;

        if (foundId.isNotEmpty) {
          _showAlertDialog('가입되어 있는 이메일입니다', foundId);
        } else {
          _showAlertDialog('가입되어 있지 않은 이메일입니다', '');
        }
      } else {
        print('서버 응답 에러: ${response.statusCode}');
        print('에러 내용: ${response.body}');
        _showAlertDialog('에러 발생', '서버 응답 에러: ${response.statusCode}');
      }
    } catch (error) {
      print('에러 발생: $error');
      _showAlertDialog('에러 발생', '에러 발생: $error');
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
