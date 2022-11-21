// ignore_for_file: avoid_print

import 'package:betting_admin/helpers/constant.dart';
import 'package:betting_admin/helpers/screen_navigation.dart';
import 'package:betting_admin/remote/firebase_storage_source.dart';
import 'package:betting_admin/remote/response.dart';
import 'package:betting_admin/screens/bottomnavigation/ticket_screens/tickets_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/utils.dart';
import '../../../widgets/custom_modal_progress_hud.dart';
import '../../../widgets/custom_round_button.dart';
import '../../../widgets/image_portrait.dart';
import '../../../widgets/rounded_icon_button.dart';

class PrizeScreen extends StatefulWidget {
  const PrizeScreen({super.key});

  @override
  State<PrizeScreen> createState() => _PrizeScreenState();
}

class _PrizeScreenState extends State<PrizeScreen> {
  final FirebaseStorageSource _storageSource = FirebaseStorageSource();
  final picker = ImagePicker();
  String? _imagePath;
  TextEditingController titleController = TextEditingController();
  TextEditingController ticketController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: CustomModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () =>
                                  changeScreen(context, const TicketsScreen()),
                              tooltip: 'Available Tickets',
                              icon: Icon(
                                Icons.auto_awesome_motion_sharp,
                                color: white,
                                size: 23,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Container(
                            child: _imagePath == null
                                ? const ImagePortrait(imageType: ImageType.NONE)
                                : ImagePortrait(
                                    imagePath: _imagePath,
                                    imageType: ImageType.FILE_IMAGE,
                                  ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: _imagePath == null
                                  ? RoundedIconButton(
                                      onPressed: pickImageFromGallery,
                                      iconData: Icons.add,
                                      buttonColor: Colors.grey,
                                      iconSize: 20,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFE1E4E8),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Title',
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.4))),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE1E4E8),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Price of ticket',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.4))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.3,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE1E4E8),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: ticketController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Total tickets',
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.4))),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                CRoundButton(
                  function: () {
                    _imagePath != null
                        ? addPrize()
                        : showSnackBar('All fields are required', context);
                  },
                  text: 'Add Prize',
                  color: yellow,
                  textColor: black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  addPrize() async {
    setState(() {
      _isLoading = true;
    });
    Response response = await (_storageSource.uploadPrizeImage(
        title: titleController.text.toString(), filePath: _imagePath));

    if (response is Success<String>) {
      String imagePath = response.value;
      instance.collection('tickets').doc().set({
        'title': titleController.text.trim(),
        'tickets': ticketController.text.trim(),
        'price': priceController.text.trim(),
        'buyers': [],
        'image_path': imagePath,
        'time': DateTime.now(),
        'winner': 'In process',
        'sold': 0
      }).then((value) {
        showSnackBar('Prize card added', context);
        setState(() {
          _isLoading = false;
          titleController.clear();
          priceController.clear();
          ticketController.clear();
        });
      }).onError((error, stackTrace) {
        print(error.toString());
        showSnackBar(error.toString(), context);
      });
    }
    if (response is Error) {
      if (!mounted) return;
      showSnackBar(response.message.toString(), context);
    }
  }
}
