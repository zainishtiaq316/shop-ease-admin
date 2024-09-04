// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user-model.dart';
import '../utils/app-constant.dart';
import '../controllers/get-all-user-length-controller.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  final GetUserLengthController _getUserLengthController =
      Get.put(GetUserLengthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
              'Users (${_getUserLengthController.userCollectionLength.toString()})');
        }),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdOn', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occurred while fetching category!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: Center(
                child: Text('No users found!'),
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                UserModel userModel = UserModel(
                    country: data['country'],
                    createdOn: data['createdOn'],
                    city: data['city'],
                    Gender: data['gender'],
                    language: data['language'],
                    email: data['email'],
                    dateOfBirth: data['dateOfBirth'],
                    isAdmin: data['isAdmin'],
                    isActive: data['isActive'],
                    phone: data['phone'],
                    street: data['street'],
                    uid: data['uid'],
                    updatedOn: data['updatedOn'],
                    userAddress: data['userAddress'],
                    userDeviceToken: data['userDeviceToken'],
                    userImg: data['userImg'],
                    firstName: data['firstName'],
                    updatedTime: data['updatedTime'],
                    joinedTime: data['joinedTime'],
                    isOnline: data['is_online'] ??
                        false, // Default value if not present
                    lastActive: data['last_active'] ??
                        '', // Default value if not present
                    lastName: data['lastName']);

                return Card(
                  elevation: 5,
                  child: ListTile(
                    // onTap: () => Get.to(
                    //   () => SpecificCustomerOrderScreen(
                    //       docId: snapshot.data!.docs[index]['uId'],
                    //       customerName: snapshot.data!.docs[index]
                    //           ['customerName']),
                    // ),

                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appSecondaryColor,
                      backgroundImage: CachedNetworkImageProvider(
                        userModel.userImg,
                        errorListener: (err) {
                          // Handle the error here
                          print('Error loading image');
                          Icon(Icons.error);
                        },
                      ),
                    ),
                    title: Text(userModel.firstName),
                    subtitle: Text(userModel.email),
                    trailing: Icon(Icons.edit),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
