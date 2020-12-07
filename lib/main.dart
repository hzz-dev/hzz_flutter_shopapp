import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '伏兔科技',
        // 去掉右上角debug
        debugShowCheckedModeBanner: false,
        // 设置主题
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
      ),
    );
  }
}
