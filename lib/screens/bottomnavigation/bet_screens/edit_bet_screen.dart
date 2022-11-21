// ignore_for_file: avoid_print

import 'package:betting_admin/model/add_bet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../helpers/constant.dart';
import '../../../helpers/screen_navigation.dart';
import '../../../helpers/utils.dart';
import '../../../widgets/custom_round_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/input_dialog.dart';
import '../../invite_sub_screens/invite_friends.dart';

class EditBetScreen extends StatefulWidget {
  const EditBetScreen({super.key, required this.data});
  final QueryDocumentSnapshot<Object?> data;
  @override
  State<EditBetScreen> createState() => _EditBetScreenState();
}

class _EditBetScreenState extends State<EditBetScreen> {
  TextEditingController defController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  bool isSwitched = false;
  String option1 = 'option 1';
  String option2 = 'option 2';
  String option3 = 'option 3';
  bool addOption = true;
  AddBet addBet = AddBet();
  String multiplier = '2';
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    saveData();
    super.initState();
  }

  saveData() {
    defController.text = widget.data['def'];
    commentController.text = widget.data['comment'];
    option1 = widget.data['option1'];
    option2 = widget.data['option2'];
    option3 = widget.data['option3'];
    multiplier = widget.data['multiplier'];

    addBet.comment = widget.data['comment'];
    addBet.uid = widget.data['uid'];
    addBet.name = widget.data['name'];
    addBet.option1 = widget.data['option1'];
    addBet.option2 = widget.data['option2'];
    addBet.option3 = widget.data['option3'];
    addBet.privacy = widget.data['privacy'];
    addBet.def = widget.data['def'];
    addBet.multiplier = widget.data['multiplier'];
    addBet.totalBet = widget.data['totalBet'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: black,
        backgroundColor: black,
      ),
      backgroundColor: black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlutterSwitch(
                    activeText: "private",
                    inactiveText: "public",
                    activeTextColor: Colors.white,
                    inactiveTextColor: Colors.white,
                    showOnOff: true,
                    width: 110.0,
                    height: 45.0,
                    toggleSize: 45.0,
                    value: isSwitched,
                    borderRadius: 30.0,
                    padding: 2.0,
                    activeToggleColor: Colors.blue,
                    inactiveToggleColor: Colors.grey,
                    activeSwitchBorder: Border.all(
                      color: Colors.blue,
                      width: 6.0,
                    ),
                    inactiveSwitchBorder: Border.all(
                      color: Colors.grey,
                      width: 6.0,
                    ),
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    activeIcon: const Icon(Icons.lock),
                    inactiveIcon: const Icon(Icons.lock_open_rounded),
                    onToggle: (val) {
                      setState(() {
                        isSwitched = val;
                        !val
                            ? addBet.privacy = 'public'
                            : addBet.privacy = 'private';
                      });
                      print(addBet.privacy);
                    },
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        IconButton(
                            splashRadius: 1.0,
                            onPressed: () =>
                                changeScreen(context, const InviteFriends()),
                            icon: Icon(
                              Icons.add,
                              color: white,
                              size: 27,
                            )),
                        IconButton(
                            splashRadius: 1.0,
                            onPressed: () {},
                            icon: Icon(
                              Icons.group,
                              color: white,
                              size: 27,
                            )),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  icon: Icons.pending,
                  hint: 'Define your bet',
                  label: 'Discription',
                  controller: defController),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CRoundButton(
                      function: () {
                        showDialog(
                          barrierColor: Colors.white,
                          context: context,
                          builder: (_) => InputDialog(
                            onSavePressed: (value) {
                              setState(() {
                                option1 = value;
                                addBet.option1 = value;
                              });
                            },
                            labelText: 'Option',
                          ),
                        );
                      },
                      text: option1,
                      active: true),
                  CustomText(
                    text: 'X $multiplier',
                    size: 20,
                    weight: FontWeight.bold,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CRoundButton(
                      function: () {
                        showDialog(
                          barrierColor: Colors.white,
                          context: context,
                          builder: (_) => InputDialog(
                            onSavePressed: (value) {
                              setState(() {
                                option2 = value;
                                addBet.option2 = value;
                              });
                            },
                            labelText: 'option',
                          ),
                        );
                      },
                      text: option2,
                      active: true),
                  CustomText(
                    text: 'X $multiplier',
                    size: 20,
                    weight: FontWeight.bold,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              addOption
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => setState(() {
                                      addOption = false;
                                      multiplier = '1.5';
                                    }),
                                icon: CircleAvatar(
                                    backgroundColor: blue,
                                    child: Icon(
                                      Icons.add,
                                      color: white,
                                    ))),
                            const CustomText(
                              text: 'New Option',
                              size: 23,
                              weight: FontWeight.bold,
                            )
                          ],
                        ),
                        const CustomText(
                          text: 'X 0',
                          weight: FontWeight.bold,
                          size: 20,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CRoundButton(
                                function: () {
                                  showDialog(
                                    barrierColor: Colors.white,
                                    context: context,
                                    builder: (_) => InputDialog(
                                      onSavePressed: (value) {
                                        setState(() {
                                          option3 = value;
                                          addBet.option3 = value;
                                        });
                                      },
                                      labelText: 'Option',
                                    ),
                                  );
                                },
                                text: option3,
                                active: true),
                            CustomText(
                              text: 'X $multiplier',
                              size: 20,
                              weight: FontWeight.bold,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            addOption = true;
                            multiplier = '2';
                          }),
                          child: CustomText(
                            color: yellow,
                            text: 'remove',
                          ),
                        )
                      ],
                    ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  icon: Icons.pending,
                  hint: '#bets #firstcomment',
                  label: 'Comment',
                  controller: commentController),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: 'Finalize',
                  size: 25,
                  weight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimePicker(
                    icon: Icon(
                      Icons.event,
                      color: black,
                    ),
                    style: TextStyle(color: black),
                    type: DateTimePickerType.dateTimeSeparate,
                    firstDate: DateTime.now(),
                    initialValue: '',
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date',
                    timeLabelText: "Time",
                    cursorColor: white,
                    onChanged: (val) {
                      addBet.dateTime = DateTime.parse(val);
                      print(addBet.dateTime);
                    },
                    validator: (val) {
                      print(val);
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CRoundButton(
                function: () {
                  addBet.multiplier = multiplier;
                  addBet.dateTime != null
                      ? addToFirebase()
                      : showSnackBar('Please Select end date for bet', context);
                },
                textColor: black,
                text: 'Edit',
                color: yellow,
                fontSize: 17,
                width: 120,
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  addToFirebase() {
    try {
      instance
          .collection('publish')
          .doc(widget.data.id)
          .update(addBet.toMap())
          .then((value) => showSnackBar('The bet has been Edit', context));
    } catch (e) {
      print(e.toString());
      showSnackBar(e.toString(), context);
    }
  }
}
