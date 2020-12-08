import 'package:flutter/material.dart';
import '../../service/service_method.dart';
// ignore: unused_import
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // var data = json.decode(snapshot.data.toString());
            var data = snapshot.data;
            List swiperDataList = data['data']['slides'];
            print(swiperDataList);
            // List<Map> swiperDataList =
            //     (data['data']['slides'] as RList).cast(); // 顶部轮播组件数
            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiperDataList),
              ],
            );
            // return Text('qsdasdsa');
          } else {
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      ),
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({this.swiperDataList});
  @override
  Widget build(BuildContext context) {

    // 适配组件 ScreenUtil
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: false);

    return Container(
        height: ScreenUtil().setHeight(170),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.network("${swiperDataList[index]}");
          },
          itemCount: swiperDataList.length,
          pagination: SwiperPagination(),
          autoplay: true,
        ),
        color: Colors.orangeAccent);
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String showText = '还没有请求数据';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(
//           appBar: AppBar(title: Text('请求远程数据')),
//           // SingleChildScrollView 解决键盘或者其他滚动会有bug
//           body: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 RaisedButton(
//                   onPressed: _jike,
//                   child: Text('请求数据'),
//                 ),
//                 Text(showText),
//               ],
//             ),
//           )),
//     );
//   }

//   void _jike() {
//     print('开始向极客时间请求数据');
//     getHttp().then((value) {
//       setState(() {
//         print(value);
//         showText = value['data'].toString();
//       });
//     });
//   }

// // 请求方法
//   Future getHttp() async {
//     try {
//       Response response;
//       Dio dio = new Dio();
//       dio.options.headers = httpHeaders;
//       response = await dio.get('https://time.geekbang.org/serv/v2/explore/all');
//       print(response);
//       return response;
//     } catch (e) {
//       return e;
//     }
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('百姓生活')),
//       body: Center(
//         child: Text('百姓生活'),
//       ),
//     );
//   }
// }

// https://time.geekbang.org/serv/v2/explore/all
