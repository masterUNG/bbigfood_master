// ignore_for_file: avoid_print

import 'package:bbigfood/states/add_food.dart';
import 'package:bbigfood/states/authen.dart';
import 'package:bbigfood/states/buyer_service.dart';
import 'package:bbigfood/states/create_account.dart';
import 'package:bbigfood/states/edit_information_buyer.dart';
import 'package:bbigfood/states/edit_information_seller.dart';
import 'package:bbigfood/states/seller_servive.dart';
import 'package:bbigfood/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => const Authen(),
  '/createAccount': (BuildContext context) => const CreateAccount(),
  '/buyerService': (BuildContext context) => const BuyerService(),
  '/sellerService': (BuildContext context) => const SellerService(),
  '/addFood': (BuildContext context) => const AddFood(),
  '/editInformationSeller': (BuildContext context) => const EditInformationSeller(),
  '/editInformationBuyer': (BuildContext context) => const EditInformationBuyer(),
};

String? initlalRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('### type ===>> $type');
  if (type?.isEmpty ?? true) {
    initlalRoute = MyConstant.routeAuthen;
    runApp(const MyApp());
  } else {
    switch (type) {
      case 'buyer':
        initlalRoute = MyConstant.routeBuyerService;
        runApp(const MyApp());
        break;
      case 'seller':
        initlalRoute = MyConstant.routeSellerService;
        runApp(const MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xff0088a3, MyConstant.mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initlalRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
