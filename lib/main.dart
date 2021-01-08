import 'package:flutter/material.dart';
import 'package:hzz_flutter_shopapp/provide/child_category.dart';
import 'pages/index_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';

void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var providers = Providers();

  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(
        Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<ChildCategory>.value(childCategory));
  runApp(ProviderNode(child: MyApp(), providers: providers));
  // runApp(MyApp());
}

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
          primaryColor: Colors.red,
        ),
        home: IndexPage(),
      ),
    );
  }
}
