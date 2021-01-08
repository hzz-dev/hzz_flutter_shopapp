
# hzz_flutter_shopapp

笔记:

451:请求非法  (设置请求头 )

模拟数据:
https://www.fastmock.site/#/project/2c00e190d27ec9fef9feb0ad9e03b234

FutureBuilder: 这个布局可以很好的解决异步渲染的问

工厂构造函数:factory 关键字的功能，当实现构造函数但是不想每次都创建该类的一个实例的时候使用。工厂模式-用这种模式可以省略New关键字,工程模式的构造方法 ,工程模式就是实力对象模式

json解析网站 :http://www.bejson.com/
快速生产数据模型:https://javiercbk.github.io/json_to_dart/

Expanded解决宽高度溢出bug

Provide状态管理
Scoped Model : 最早的状态管理方案，我刚学Flutter的时候就使用的这个，虽然还有公司在用，但是大部分已经选用其它方案了。
Redux：现在国内用的最多，因为咸鱼团队一直在用，还出了自己fish redux。
bloc：个人觉的比Redux简单，而且好用，特别是一个页面里的状态管理，用起来很爽。
state：我们首页里已经简单接触，缺点是耦合太强，如果是大型应用，管理起来非常混乱。
Provide：是在Google的Github下的一个项目，刚出现不久，所以可以推测他是Google的亲儿子，用起来也是相当的爽。
      
fluro:https://github.com/theyakka/fluro 路由框架 

数据持久化三种 :
sqfilte sql
shared_preferences
file
