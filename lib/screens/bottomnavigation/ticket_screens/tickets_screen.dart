// ignore_for_file: avoid_print
import 'dart:math';

import 'package:betting_admin/helpers/utils.dart';
import 'package:betting_admin/widgets/custom_modal_progress_hud.dart';
import 'package:betting_admin/widgets/custom_round_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../helpers/constant.dart';
import '../../../widgets/custom_text.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({
    super.key,
  });

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<String> tickets = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        shadowColor: black,
        backgroundColor: black,
        title: const Text('My Tickets'),
      ),
      body: CustomModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          color: black,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CustomText(
                      text: 'My Tickets',
                      size: 25,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tickets')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }
                        var item = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: item.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = item[index];

                            return Container(
                                height: MediaQuery.of(context).size.height / 4,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: data['title'],
                                          weight: FontWeight.bold,
                                          size: 20,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            image: CachedNetworkImageProvider(
                                                data['image_path']),
                                            fit: BoxFit.cover,
                                            height: 130,
                                            width: 130,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: (data['buyers'] as List)
                                              .length
                                              .toString(),
                                          weight: FontWeight.bold,
                                        ),
                                        CustomText(
                                          text:
                                              '${data['sold']}/${data['tickets']} ticket',
                                          weight: FontWeight.bold,
                                        ),
                                        CustomText(
                                          text: data['winner'] == 'In process'
                                              ? data['winner']
                                              : 'winner: @${data['winner']}',
                                          weight: FontWeight.bold,
                                        ),
                                        data['sold'].toString() !=
                                                data['tickets']
                                            ? CRoundButton(
                                                color: Colors.grey,
                                                textColor: black,
                                                function: () => showSnackBar(
                                                    'Tickets have not been sold yet',
                                                    context),
                                                text: 'Selling')
                                            : data['winner'] == 'In process'
                                                ? CRoundButton(
                                                    color: Colors.green,
                                                    textColor: black,
                                                    function: () =>
                                                        announce(data),
                                                    text: 'Announce')
                                                : CRoundButton(
                                                    color: yellow,
                                                    textColor: black,
                                                    function: () =>
                                                        remove(data),
                                                    text: 'Remove')
                                      ],
                                    )
                                  ],
                                ));
                          },
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  announce(QueryDocumentSnapshot<Object?> data) {
    setState(() {
      _isLoading = true;
    });
    List list = [];
    final random = Random();
    try {
      instance.collection('tickets').doc(data.id).get().then((value) {
        list = value['buyers'];
        var element = list[random.nextInt(list.length)];
        print(element);
        instance.collection('users').doc(element).get().then((value) {
          print(value['name']);
          instance
              .collection('tickets')
              .doc(data.id)
              .update({'winner': value['name']}).then((value) {
            setState(() {
              _isLoading = false;
            });
            showSnackBar('Winner has been announced', context);
          });
        });
      });
    } catch (e) {
      print(e);
      showSnackBar(e.toString(), context);
    }
  }

  remove(QueryDocumentSnapshot<Object?> data) {
    try {
      instance.collection('tickets').doc(data.id).delete().then((value) {
        showSnackBar('Prize removed', context);
      });
    } catch (e) {
      print(e);
      showSnackBar(e.toString(), context);
    }
  }
}
