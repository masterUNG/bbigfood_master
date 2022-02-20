import 'dart:convert';

import 'package:bbigfood/models/menu_model.dart';
import 'package:bbigfood/states/edit_food.dart';
import 'package:bbigfood/utility/my_constant.dart';
import 'package:bbigfood/widgets/show_image.dart';
import 'package:bbigfood/widgets/show_progress.dart';
import 'package:bbigfood/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowFoodSeller extends StatefulWidget {
  const ShowFoodSeller({Key? key}) : super(key: key);

  @override
  _ShowFoodSellerState createState() => _ShowFoodSellerState();
}

class _ShowFoodSellerState extends State<ShowFoodSeller> {
  bool load = true;
  bool? haveData;
  List<MenuModel> menuModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    if (menuModels.length != 0) {
      menuModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetMenuWhereIdSeller =
        '${MyConstant.domain}/bbigfood/getMenuWhereIdSeller.php/?isAdd=true&idSeller=$id';
    await Dio().get(apiGetMenuWhereIdSeller).then((value) {
      // print('value ==> $value');

      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        // Have Data
        for (var item in json.decode(value.data)) {
          MenuModel model = MenuModel.fromMap(item);
          print('name Menu ==>> ${model.name}');

          setState(() {
            load = false;
            haveData = true;
            menuModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListView(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'ไม่มีเมนูอาหาร',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'กรุณาเพิ่มเมนูอาหาร',
                          textStyle: MyConstant().h2Style()),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, MyConstant.routeAddFood)
            .then((value) => loadValueFromAPI()),
        child: Text('Add'),
      ),
    );
  }

  String createUrl(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String url = '${MyConstant.domain}/bbigfood${strings[0]}';
    return url;
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: menuModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.5,
                    height: constraints.maxWidth * 0.4,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: createUrl(menuModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.image3),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShowTitle(
                      title: menuModels[index].name,
                      textStyle: MyConstant().h2Style()),
                  ShowTitle(
                      title: 'ราคา ${menuModels[index].price} บาท',
                      textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            print('## You Click Edit');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFood(
                                    menuModel: menuModels[index],
                                  ),
                                )).then((value) => loadValueFromAPI());
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 36,
                            color: MyConstant.dart,
                          )),
                      IconButton(
                          onPressed: () {
                            print('## You Click Delete from index = $index');
                            confirmDialogDelete(menuModels[index]);
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            size: 36,
                            color: MyConstant.dart,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> confirmDialogDelete(MenuModel menuModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: createUrl(menuModel.images),
            placeholder: (context, url) => ShowProgress(),
          ),
          title: ShowTitle(
            title: 'คุณต้องการจะลบ ${menuModel.name} ?',
            textStyle: MyConstant().h2Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('## Confirm Delete at id ==> ${menuModel.id}');
              String apiDeleteMenuWhereId =
                  '${MyConstant.domain}/bbigfood/deleteMenuWhereId.php/?isAdd=true&id=${menuModel.id}';
              await Dio().get(apiDeleteMenuWhereId).then((value) {
                Navigator.pop(context);
                loadValueFromAPI();
              });
            },
            child: Text('ใช่'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ไม่'),
          ),
        ],
      ),
    );
  }
}
