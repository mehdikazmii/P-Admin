import 'package:flutter/material.dart';

import '../helpers/constant.dart';

class Drawerr extends StatelessWidget {
  const Drawerr({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: yellow),
              currentAccountPicture: const CircleAvatar(
                foregroundImage: AssetImage('assets/splash.png'),
                backgroundColor: Colors.white,
              ),
              arrowColor: Colors.white,
              accountName: const Text('Admin'),
              accountEmail: const Text('Admin@mail.com'),
            ),
          ],
        ));
  }
}
