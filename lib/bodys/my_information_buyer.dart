import 'dart:convert';

import 'package:bbigfood/models/user_model.dart';
import 'package:bbigfood/utility/my_constant.dart';
import 'package:bbigfood/widgets/show_progress.dart';
import 'package:bbigfood/widgets/show_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyInformationBuyer extends StatefulWidget {
  final UserModel userModel;
  const MyInformationBuyer({Key? key, required this.userModel})
      : super(key: key);

  @override
  _MyInformationBuyerState createState() => _MyInformationBuyerState();
}

class _MyInformationBuyerState extends State<MyInformationBuyer> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
  }

  Future<Null> refreshUserModel() async {
    print('## refreshUserModel Work');
    String apiGetUserWhereId =
        '${MyConstant.domain}/bbigfood/getUserWhereId.php/?isAdd=true&id=${userModel!.id}';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () =>
              Navigator.pushNamed(context, MyConstant.routeEditInformationBuyer)
                  .then((value) => refreshUserModel()),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(title: 'ชื่อ :', textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShowTitle(
                            title: userModel!.name,
                            textStyle: MyConstant().h1Style()),
                      ),
                    ],
                  ),
                  ShowTitle(
                      title: 'เบอร์โทร :', textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShowTitle(
                            title: userModel!.phone,
                            textStyle: MyConstant().h1Style()),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ShowTitle(
                        title: 'รูปภาพ :', textStyle: MyConstant().h2Style()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        width: constraints.maxWidth * 0.6,
                        child: CachedNetworkImage(
                          imageUrl: '${MyConstant.domain}${userModel!.avatar}',
                          placeholder: (context, url) => ShowProgress(),
                        ),
                      ),
                    ],
                  ),
                  ShowTitle(
                      title: 'ตำแหน่งที่อยู่ :',
                      textStyle: MyConstant().h2Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        width: constraints.maxWidth * 0.6,
                        height: constraints.maxWidth * 0.6,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(userModel!.lat),
                              double.parse(userModel!.lng),
                            ),
                            zoom: 16,
                          ),
                          markers: <Marker>{
                            Marker(
                                markerId: MarkerId('id'),
                                position: LatLng(
                                  double.parse(userModel!.lat),
                                  double.parse(userModel!.lng),
                                ),
                                infoWindow: InfoWindow(
                                    title: 'You Here ',
                                    snippet:
                                        'lat = ${userModel!.lat}, lng = ${userModel!.lng}')),
                          }.toSet(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
