import 'dart:convert';

import 'package:bbigfood/models/user_model.dart';
import 'package:bbigfood/states/show_shop_seller.dart';
import 'package:bbigfood/utility/my_constant.dart';
import 'package:bbigfood/widgets/show_progress.dart';
import 'package:bbigfood/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowAllShopBuyer extends StatefulWidget {
  const ShowAllShopBuyer({Key? key}) : super(key: key);

  @override
  _ShowAllShopBuyerState createState() => _ShowAllShopBuyerState();
}

class _ShowAllShopBuyerState extends State<ShowAllShopBuyer> {
  bool load = true;
  var userModels = <UserModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllShop();
  }

  Future<void> readAllShop() async {
    String path =
        '${MyConstant.domain}/bbigfood/getUserWhereSeller.php?isAdd=true';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(item);
        userModels.add(userModel);
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : GridView.builder(
              itemCount: userModels.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180),
              itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowShopSeller(userModel: userModels[index],),
                      ),
                    ),
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${MyConstant.domain}${userModels[index].avatar}',
                              placeholder: (context, url) => ShowProgress(),
                            ),
                          ),
                          ShowTitle(title: userModels[index].name),
                        ],
                      ),
                    ),
                  )),
    );
  }
}
