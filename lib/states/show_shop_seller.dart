// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_collection_literals
import 'package:bbigfood/states/show_all_food.dart';
import 'package:bbigfood/utility/my_constant.dart';
import 'package:bbigfood/widgets/show_progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:bbigfood/models/user_model.dart';
import 'package:bbigfood/widgets/show_title.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowShopSeller extends StatelessWidget {
  final UserModel userModel;
  const ShowShopSeller({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('Menu'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowAllFood(userModel: userModel,),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(userModel.name),
      ),
      body: Center(
        child: Column(
          children: [
            ShowTitle(
              title: userModel.name,
              textStyle: MyConstant().h1Style(),
            ),
            displayTitle(head: 'Phone :', detail: userModel.phone),
            displayTitle(head: 'Profile', detail: ''),
            SizedBox(
              width: 150,
              height: 180,
              child: CachedNetworkImage(
                imageUrl: '${MyConstant.domain}${userModel.avatar}',
                placeholder: (context, url) => const ShowProgress(),
              ),
            ),
            displayTitle(head: 'Location', detail: ''),
            SizedBox(
              width: 200,
              height: 180,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(userModel.lat),
                    double.parse(userModel.lng),
                  ),
                  zoom: 16,
                ),
                markers: <Marker>[
                  Marker(
                      infoWindow: InfoWindow(title: userModel.name),
                      markerId: MarkerId('id'),
                      position: LatLng(
                        double.parse(userModel.lat),
                        double.parse(userModel.lng),
                      ))
                ].toSet(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding displayTitle({required String head, required String detail}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ShowTitle(
            title: '$head $detail',
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }
}
