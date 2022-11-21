// ignore_for_file: avoid_print

import 'package:badges/badges.dart';
import 'package:betting_admin/helpers/constant.dart';
import 'package:betting_admin/helpers/utils.dart';
import 'package:betting_admin/widgets/input_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../widgets/custom_round_button.dart';

class UserCardScreen extends StatefulWidget {
  const UserCardScreen({super.key, required this.userData});
  final QueryDocumentSnapshot<Object?> userData;

  @override
  State<UserCardScreen> createState() => _UserCardScreenState();
}

class _UserCardScreenState extends State<UserCardScreen> {
  double coins = 0.0;
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  int selected = 0;
  addCoins(coins, context) {
    try {
      instance
          .collection('users')
          .doc(widget.userData.id)
          .update({'wallet': coins}).then((value) {
        Navigator.pop(context);
        showSnackBar('Coins have been added', context);
      });
    } catch (e) {
      print(e.toString());
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    barrierColor: Colors.white,
                    context: context,
                    builder: (_) => InputDialog(
                      keyboardType: TextInputType.number,
                      onSavePressed: (value) {
                        setState(() {
                          coins =
                              double.parse(value) + widget.userData['wallet'];
                        });
                        print('-------');
                        coins != 0.0
                            ? addCoins(coins, context)
                            : showSnackBar('add coins', context);
                      },
                      labelText: 'Add Coins',
                    ),
                  );
                },
                icon: const Icon(Icons.add)),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Image(
                color: yellow,
                image: const AssetImage('assets/black-coin.png'),
                height: 20,
                width: 20,
              ),
            )
          ],
          shadowColor: black,
          backgroundColor: black,
          title: Text(
            'User',
            style: TextStyle(color: white),
          ),
        ),
        body: SafeArea(
            child: Container(
                height: MediaQuery.of(context).size.height,
                color: black,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        height: height / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: width / 3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  widget.userData['verified']
                                      ? Badge(
                                          badgeColor: Colors.blue,
                                          toAnimate: false,
                                          padding: const EdgeInsets.all(4),
                                          position: BadgePosition.topEnd(
                                              top: 0, end: 0),
                                          badgeContent: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: GestureDetector(
                                              onTap: () {
                                                unVerifyUser();
                                              },
                                              child: const Icon(
                                                Icons.verified,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    widget.userData[
                                                        'profile_photo_path']),
                                            backgroundColor: Colors.grey,
                                            radius: 40,
                                          ),
                                        )
                                      : Badge(
                                          badgeColor: Colors.grey,
                                          toAnimate: false,
                                          padding: const EdgeInsets.all(4),
                                          position: BadgePosition.topEnd(
                                              top: 0, end: 0),
                                          badgeContent: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: GestureDetector(
                                              onTap: () {
                                                verifyUser();
                                              },
                                              child: const Icon(
                                                Icons.verified,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    widget.userData[
                                                        'profile_photo_path']),
                                            backgroundColor: Colors.grey,
                                            radius: 40,
                                          ),
                                        ),
                                  Text(
                                    widget.userData['name'],
                                    style:
                                        TextStyle(color: white, fontSize: 15),
                                  ),
                                  Text(
                                    widget.userData['bio'] ?? 'Bio',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.emoji_events_outlined,
                                          color: yellow,
                                        ),
                                        Text(
                                          widget.userData['level'].toString(),
                                          style: TextStyle(
                                              color: white, fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                widget.userData['wallet']
                                                    .toString(),
                                                style: TextStyle(color: white),
                                              ),
                                              Image(
                                                color: yellow,
                                                image: const AssetImage(
                                                    'assets/black-coin.png'),
                                                height: 20,
                                                width: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              '20',
                                              style: TextStyle(
                                                  color: white, fontSize: 15),
                                            ),
                                            Text(
                                              'Following',
                                              style: TextStyle(
                                                  color: white, fontSize: 15),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              '350',
                                              style: TextStyle(
                                                  color: white, fontSize: 15),
                                            ),
                                            Text(
                                              'Followers',
                                              style: TextStyle(
                                                  color: white, fontSize: 15),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CRoundButton(
                                  active: true,
                                  function: () {
                                    selected == 0
                                        ? null
                                        : setState(() {
                                            selected = 0;
                                          });
                                  },
                                  text: 'Active Bets',
                                ),
                                CRoundButton(
                                  active: true,
                                  function: () {
                                    selected == 1
                                        ? null
                                        : setState(() {
                                            selected = 1;
                                          });
                                  },
                                  text: 'History',
                                )
                              ],
                            ),
                            selected == 0
                                ? Container(
                                    height: height / 1.95,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('publish')
                                                    .orderBy('publishTime',
                                                        descending: true)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container();
                                                  }
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container();
                                                  }
                                                  var item =
                                                      snapshot.data!.docs;

                                                  return ListView.builder(
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var data = item[index];
                                                      DateTime dateTime =
                                                          DateTime.parse(
                                                              data['dateTime']
                                                                  .toDate()
                                                                  .toString());
                                                      return data['uid'] ==
                                                              widget.userData[
                                                                  'id']
                                                          ? Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4),
                                                              decoration: BoxDecoration(
                                                                  color: dateTime.isAfter(
                                                                          DateTime
                                                                              .now())
                                                                      ? blue
                                                                      : Colors
                                                                          .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: ListTile(
                                                                  subtitle:
                                                                      Text(
                                                                    "${data['option1']} - ${data['option2']}",
                                                                    style: TextStyle(
                                                                        color:
                                                                            white),
                                                                  ),
                                                                  trailing:
                                                                      Text(
                                                                    data['totalBet'] ==
                                                                            ''
                                                                        ? '100'
                                                                        : data[
                                                                            'totalBet'],
                                                                    style: TextStyle(
                                                                        color:
                                                                            white,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                  title: Text(
                                                                    data['def'],
                                                                    style: TextStyle(
                                                                        color:
                                                                            white),
                                                                  )),
                                                            )
                                                          : Container();
                                                    },
                                                  );
                                                })),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: height / 1.95,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(widget.userData.id)
                                                    .collection('history')
                                                    .orderBy('publishTime',
                                                        descending: true)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container();
                                                  }
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container();
                                                  }
                                                  var item =
                                                      snapshot.data!.docs;

                                                  return ListView.builder(
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var data = item[index];
                                                      DateTime dateTime =
                                                          DateTime.parse(
                                                              data['dateTime']
                                                                  .toDate()
                                                                  .toString());
                                                      return data['uid'] ==
                                                              widget.userData[
                                                                  'id']
                                                          ? Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4),
                                                              decoration: BoxDecoration(
                                                                  color: blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: ListTile(
                                                                  subtitle:
                                                                      Text(
                                                                    "${data['option1']} - ${data['option2']}",
                                                                    style: TextStyle(
                                                                        color:
                                                                            white),
                                                                  ),
                                                                  trailing:
                                                                      Text(
                                                                    data['totalBet'] ==
                                                                            ''
                                                                        ? '100'
                                                                        : data[
                                                                            'totalBet'],
                                                                    style: TextStyle(
                                                                        color:
                                                                            white,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                  title: Text(
                                                                    data['def'],
                                                                    style: TextStyle(
                                                                        color:
                                                                            white),
                                                                  )),
                                                            )
                                                          : Container();
                                                    },
                                                  );
                                                })),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))));
  }

  verifyUser() {
    try {
      instance
          .collection('users')
          .doc(widget.userData.id)
          .update({'verified': true}).then((value) {
        showSnackBar('user has been verified', context);
        Navigator.pop(context);
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
      print(e.toString());
    }
  }

  unVerifyUser() {
    try {
      instance
          .collection('users')
          .doc(widget.userData.id)
          .update({'verified': false}).then((value) {
        showSnackBar('user has been unVerified', context);
        Navigator.pop(context);
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
      print(e.toString());
    }
  }
}
