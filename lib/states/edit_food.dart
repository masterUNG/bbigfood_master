import 'dart:io';
import 'dart:math';

import 'package:bbigfood/models/menu_model.dart';
import 'package:bbigfood/utility/my_constant.dart';
import 'package:bbigfood/utility/my_dialog.dart';
import 'package:bbigfood/widgets/show_progress.dart';
import 'package:bbigfood/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditFood extends StatefulWidget {
  final MenuModel menuModel;
  const EditFood({Key? key, required this.menuModel}) : super(key: key);

  @override
  _EditFoodState createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  MenuModel? menuModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<String> pathImages = [];
  List<File?> files = [];
  bool statusImage = false; // false => Not Change Image

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuModel = widget.menuModel;
    // print('### image from mySQL ==>> ${menuModel!.images}');
    convertStringToArray();
    nameController.text = menuModel!.name;
    priceController.text = menuModel!.price;
  }

  void convertStringToArray() {
    String string = menuModel!.images;
    // print('string ก่อนตัด ==>> $string');
    string = string.substring(1, string.length - 1);
    // print('string หลังตัด ==>> $string');
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImages.add(item.trim());
      files.add(null);
    }
    print('### pathImages ==>> $pathImages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Food Menu'),
          actions: [
            IconButton(
              onPressed: () => processEdit(),
              icon: Icon(Icons.edit),
              tooltip: 'Edit Food Menu',
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Center(
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                behavior: HitTestBehavior.opaque,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle('ข้อมูลทั่วไป :'),
                      buildName(constraints),
                      buildPrice(constraints),
                      buildTitle('รูปภาพ :'),
                      buildImage(constraints, 0),
                      buildImage(constraints, 1),
                      buildImage(constraints, 2),
                      buildEditFood(constraints)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Container buildEditFood(BoxConstraints constraints) {
    return Container(
        margin: EdgeInsets.only(top: 16),
        width: constraints.maxWidth,
        child: ElevatedButton.icon(
            onPressed: () => processEdit(),
            icon: Icon(Icons.edit),
            label: Text('Edit Food Menu')));
  }

  Future<Null> chooseImage(int index, ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        files[index] = File(result!.path);
        statusImage = true;
      });
    } catch (e) {}
  }

  Container buildImage(BoxConstraints constraints, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.camera),
            icon: Icon(Icons.add_a_photo),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: constraints.maxWidth * 0.5,
            child: files[index] == null
                ? CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}/bbigfood/${pathImages[index]}',
                    placeholder: (context, url) => ShowProgress(),
                  )
                : Image.file(files[index]!),
          ),
          IconButton(
            onPressed: () => chooseImage(index, ImageSource.gallery),
            icon: Icon(Icons.add_photo_alternate),
          ),
        ],
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ชื่อเมนู';
              } else {
                return null;
              }
            },
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'ชื่อเมนู :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPrice(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ราคา';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.number,
            controller: priceController,
            decoration: InputDecoration(
              labelText: 'ราคา :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Future<Null> processEdit() async {
    if (formKey.currentState!.validate()) {
      MyDialog().showProgressDialog(context);

      String name = nameController.text;
      String price = priceController.text;
      String id = menuModel!.id;
      String images;

      if (statusImage) {
        // upload Image and Refresh array pathImages
        int index = 0;
        for (var item in files) {
          if (item != null) {
            int i = Random().nextInt(1000000);
            String nameImage = 'menuEdit$i.jpg';
            String apiUploadImage =
                '${MyConstant.domain}/bbigfood/saveMenu.php';

            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            await Dio().post(apiUploadImage, data: formData).then((value) {
              pathImages[index] = '/food menu/$nameImage';
            });
          }
          index++;
        }

        images = pathImages.toString();
        Navigator.pop(context);
      } else {
        images = pathImages.toString();
        Navigator.pop(context);
      }

      print('## statusImage = $statusImage');
      print('## id = $id, = $name, price = $price,');
      print('## images = $images');

      String apiEditMenu =
          '${MyConstant.domain}/bbigfood/editMenuWhereId.php/?isAdd=true&id=$id&name=$name&price=$price&images=$images';
      await Dio().get(apiEditMenu).then((value) => Navigator.pop(context));
       
    }
  }
}
