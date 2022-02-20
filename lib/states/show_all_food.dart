// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bbigfood/models/menu_model.dart';
import 'package:bbigfood/models/sqlite_model.dart';
import 'package:bbigfood/utility/my_constant.dart';
import 'package:bbigfood/utility/sqlite_helper.dart';
import 'package:bbigfood/widgets/show_image.dart';
import 'package:bbigfood/widgets/show_progress.dart';
import 'package:bbigfood/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:bbigfood/models/user_model.dart';

class ShowAllFood extends StatefulWidget {
  final UserModel userModel;
  const ShowAllFood({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<ShowAllFood> createState() => _ShowAllFoodState();
}

class _ShowAllFoodState extends State<ShowAllFood> {
  UserModel? userModel;
  bool load = true;
  bool? haveData;
  var menuModels = <MenuModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readAllFood();
  }

  Future<void> readAllFood() async {
    String path =
        '${MyConstant.domain}/bbigfood/getMenuWhereIdSeller.php?isAdd=true&idSeller=${userModel!.id}';
    await Dio().get(path).then((value) {
      if (value.toString() == 'null') {
        haveData = false;
      } else {
        haveData = true;
        for (var item in json.decode(value.data)) {
          MenuModel menuModel = MenuModel.fromMap(item);
          menuModels.add(menuModel);
        }
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name),
      ),
      body: load
          ? const ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: menuModels.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      showAddFoodDialog(menuModel: menuModels[index]);
                    },
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 160,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: findImage(menuModels[index].images),
                                placeholder: (context, url) =>
                                    const ShowProgress(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 180,
                            height: 160,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ShowTitle(
                                  title: menuModels[index].name,
                                  textStyle: MyConstant().h2Style(),
                                ),
                                ShowTitle(
                                  title: menuModels[index].price,
                                  textStyle: MyConstant().h1Style(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: ShowTitle(
                  title: 'ไม่มีเมนู',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }

  String findImage(String images) {
    String string = images;
    print('string ===> $string');
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    // print('${MyConstant.domain}${strings[0].trim()}');
    return '${MyConstant.domain}/bbigfood${strings[0].trim()}';
  }

  Future<void> showAddFoodDialog({required MenuModel menuModel}) async {
    int amount = 1;
    String string = menuModel.images;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    int i = 0;
    for (var item in strings) {
      strings[i] = item.trim();
      i++;
    }

    int indexImage = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: ListTile(
            leading: const ShowImage(path: 'images/image2.png'),
            title: ShowTitle(
              title: menuModel.name,
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: ShowTitle(title: 'ราคา ${menuModel.price} บาท/หน่วย'),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      '${MyConstant.domain}/bbigfood${strings[indexImage]}',
                  placeholder: (context, string) => const ShowProgress(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          indexImage = 0;
                        });
                      },
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: ShowImage(path: 'images/image4.png'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          indexImage = 1;
                        });
                      },
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: ShowImage(path: 'images/image4.png'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          indexImage = 2;
                        });
                      },
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: ShowImage(path: 'images/image4.png'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (amount != 1) {
                              amount--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle)),
                    ShowTitle(
                      title: amount.toString(),
                      textStyle: MyConstant().h1Style(),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            amount++;
                          });
                        },
                        icon: const Icon(Icons.add_circle)),
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processAddCart(menuModel: menuModel, amount: amount);
                },
                child: const Text('Add')),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }

  Future<void> processAddCart({
    required MenuModel menuModel,
    required int amount,
  }) async {
    print('food ==>> ${menuModel.name} amount ==> $amount');

    int priceInt = int.parse(menuModel.price);
    int sumInt = priceInt * amount;

    SQLiteModel sqLiteModel = SQLiteModel(
        idSeller: menuModel.idSeller,
        nameSeller: menuModel.nameSeller,
        idMenu: menuModel.id,
        nameMenu: menuModel.name,
        price: menuModel.price,
        amount: amount.toString(),
        sum: sumInt.toString());

    await SQLiteHelper().insertData(sqLiteModel).then((value) => print('Add Success'));
  }
}
