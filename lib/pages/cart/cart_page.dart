import 'package:flutter/material.dart';
import 'package:hzz_flutter_shopapp/provide/counter.dart';
import 'package:provide/provide.dart';
import '../../provide/counter.dart';

import '../../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _getCartInfo(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          List cartList = Provide.value<CartProvide>(context).cartList;
          if (snapshot.hasData && cartList != null) {
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(builder: (context, child, childCategory) {
                  cartList = Provide.value<CartProvide>(context).cartList;
                  print(cartList);
                  return ListView.builder(
                    itemCount: cartList.length,
                    itemBuilder: (context, index) {
                      return CartItem(cartList[index]);
                    },
                  );
                }),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                )
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}

// class CartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: <Widget>[Number(), MyButton()],
//         ),
//       ),
//     );
//   }
// }

// class Number extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: EdgeInsets.only(top: 200),
//         child: Provide<Counter>(
//           builder: (context, child, counter) {
//             return Text('${counter.value}');
//           },
//         ));
//   }
// }

// class MyButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: RaisedButton(
//         onPressed: () {
//           Provide.value<Counter>(context).increment();
//         },
//         child: Text('递增'),
//       ),
//     );
//   }
// }
