import 'package:flutter/material.dart';
import '../../service/service_method.dart';
// ignore: unused_import
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/* AutomaticKeepAliveClientMixin 数据保持
  1. @override
  bool get wantkeepAlive => true;

*/
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _getHotGoods();
  }

  // GlobalKey<EasyRefreshState> _easyRefreshKey =new GlobalKey<EasyRefreshState>();
  // GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('京东')),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // var data = json.decode(snapshot.data.toString());
            var data = snapshot.data;
            List swiperDataList = data['data']['slides'];
            List navgatorList = data['data']['category'];
            String advertesPicture =
                data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
            String newsLeftBanner = data['data']['newsBanner'][0]['image'];
            String newsRightBanner = data['data']['newsBanner'][1]['image'];
            List recommendList = data['data']['recommend']; // 商品推荐
            String floor1Title =
                data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片

            String floor2Title =
                data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            List floor2 = data['data']['floor2'];
            // List<Map> swiperDataList =
            //     (data['data']['slides'] as RList).cast(); // 顶部轮播组件数
            return EasyRefresh(
              // onRefresh: ClassicsFooter(
              //     // key: _footerKey,
              //     bgColor: Colors.white,
              //     textColor: Colors.pink,
              //     moreInfoColor: Colors.pink,
              //     showMore: true,
              //     noMoreText: '',
              //     moreInfo: '加载中',
              //     loadReadyText: '上拉加载....'
              // ),
              footer: ClassicalFooter(
                bgColor: Colors.white,
                textColor: Colors.redAccent,
                noMoreText: '',
                loadFailedText: '上拉加载....',
              ),

              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList),
                  TopNavigator(navigatorList: navgatorList),
                  Recommend(recommendList: recommendList),
                  AdBanner(adPicture: advertesPicture),
                  NewsPBanners(
                    newsLeftBanner: newsLeftBanner,
                    newsRightBanner: newsRightBanner,
                  ),
                  FloorTitle(picture_address: floor1Title),
                  FloorTitle(picture_address: floor2Title),
                  FloorContent(floorGoodsList: floor2),
                  _hotGoods(),
                ],
              ),
              onLoad: () async {
                print('开始加载更多');
                var formPage = {'page': page};
                await request('homePageBelowConten', formData: formPage)
                    .then((val) {
                  var data = val;
                  List newGoodsList = data['data'];
                  setState(() {
                    hotGoodsList.addAll(newGoodsList);
                    page++;
                  });
                });
              },
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

  //火爆商品接口
  void _getHotGoods() {
    var formPage = {'page': page};
    request('homePageBelowConten', formData: formPage).then((val) {
      var data = val;
      List newGoodsList = data['data'];
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  //火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
    child: Text(
      '猜你喜欢',
    ),
  );

//火爆专区子项
  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
            onTap: () {
              // Application.router.navigateTo(context,"/detail?id=${val['goodsId']}");
            },
            child: Container(
              width: ScreenUtil().setWidth(372),
              color: Colors.white,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.only(bottom: 3.0),
              child: Column(
                children: <Widget>[
                  Image.network(
                    val['image'],
                    width: ScreenUtil().setWidth(375),
                  ),
                  Text(
                    val['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                  ),
                  Row(
                    children: <Widget>[
                      Text('￥${val['mallPrice']}'),
                      Text(
                        '￥${val['price']}',
                        style: TextStyle(
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough),
                      )
                    ],
                  )
                ],
              ),
            ));
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  //火爆专区组合
  Widget _hotGoods() {
    return Container(
        child: Column(
      children: <Widget>[
        hotTitle,
        _wrapList(),
      ],
    ));
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({this.swiperDataList});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(300),
        width: ScreenUtil().setWidth(750),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "${swiperDataList[index]}",
              fit: BoxFit.fill,
            );
          },
          itemCount: swiperDataList.length,
          pagination: SwiperPagination(),
          autoplay: true,
        ),
        color: Colors.orangeAccent);
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({this.navigatorList});

  Widget _gridViewItemUI(BuildContext context, item) {
// InkWell
    return InkWell(
      onTap: () {
        print('点击了');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(80),
          ),
          Text(
            item['mallCategoryName'],
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(300),
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.only(top: 10),
      child: GridView.count(
        // 禁止上下滚动
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 商品推介
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({this.recommendList});

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '京东秒杀',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

// 商品单独项
  Widget _item(index, context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(750 / 3),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

// 横向列表
  Widget _recommedList(context) {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index, context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommedList(context)],
      ),
    );
  }
}

class NewsPBanners extends StatelessWidget {
  final String newsLeftBanner;
  final String newsRightBanner;

  NewsPBanners({this.newsLeftBanner, this.newsRightBanner});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(220),
      margin: EdgeInsets.only(top: 10),
      // padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            this.newsLeftBanner,
            fit: BoxFit.fill,
            width: ScreenUtil().setWidth(360),
          ),
          Image.network(
            this.newsRightBanner,
            fit: BoxFit.fill,
            width: ScreenUtil().setWidth(360),
          ),
        ],
      ),
    );
  }
}

// 广告页
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({this.adPicture});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Image.network(adPicture),
    );
  }
}

class FloorTitle extends StatelessWidget {
  final String picture_address; // 图片地址
  FloorTitle({this.picture_address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(this.picture_address),
    );
  }
}

// 楼层商品
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({this.floorGoodsList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(360),
      margin: EdgeInsets.only(left: 10, right: 10),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        // padding: EdgeInsets.all(5),
        children: floorGoodsList.map((item) {
          return _goodsItem(item);
        }).toList(),
      ),
    );
  }

  Widget _goodsItem(item) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          // Application.router.navigateTo(context,)
        },
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                item['name'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Text(
                item['descrition'],
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            Container(
                child: Image.network(
              item['image'],
              width: ScreenUtil().setWidth(90),
            )),
          ],
        ),
      ),
    );
  }
}
