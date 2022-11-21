import 'package:badges/badges.dart';
import 'package:betting_admin/helpers/constant.dart';
import 'package:betting_admin/helpers/screen_navigation.dart';
import 'package:betting_admin/screens/bottomnavigation/user_sub_screens/user_card_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                var item = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = item[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), color: blue),
                      child: ListTile(
                        onTap: (() => changeScreen(
                            context,
                            UserCardScreen(
                              userData: data,
                            ))),
                        leading: data['verified']
                            ? Badge(
                                badgeColor: Colors.blue,
                                toAnimate: false,
                                padding: const EdgeInsets.all(4),
                                position: BadgePosition.topEnd(top: 0, end: 0),
                                badgeContent: const Padding(
                                  padding: EdgeInsets.only(bottom: 0),
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      data['profile_photo_path']),
                                  backgroundColor: Colors.grey,
                                  radius: 40,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    data['profile_photo_path']),
                                backgroundColor: Colors.grey,
                              ),
                        title: Text(data['name']),
                        textColor: white,
                        subtitle: Text(data['email']),
                        trailing: SizedBox(
                          width: 70,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(data['wallet'].toString()),
                              Image(
                                color: yellow,
                                image:
                                    const AssetImage('assets/black-coin.png'),
                                height: 20,
                                width: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ));
  }
}
