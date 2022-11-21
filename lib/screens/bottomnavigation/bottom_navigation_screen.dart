import 'package:betting_admin/screens/bottomnavigation/ticket_screens/create_prize_screen.dart';
import 'package:betting_admin/screens/bottomnavigation/result_screen.dart';
import 'package:betting_admin/screens/search_screen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../helpers/constant.dart';
import '../../helpers/screen_navigation.dart';
import '../../widgets/drawer.dart';
import 'add_bet_screen.dart';
import 'bet_screens/bet_screen.dart';
import 'user_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);
  static String id = 'navigaationScreenId';

  @override
  State<BottomNavigationScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomNavigationScreen> {
  final PageController controller = PageController(initialPage: 0);
  var pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildScreens() {
      return [
        const BetScreen(),
        const UserScreen(),
        const AddBetScreen(),
        const PrizeScreen(),
        const ResultVerificationScreen()
      ];
    }

    return Scaffold(
        drawer: const Drawerr(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
              child: Title(
                  color: yellow,
                  child: Text(
                    'P-Admin',
                    style: TextStyle(color: yellow),
                  ))),
          shadowColor: Colors.black,
          backgroundColor: Colors.black,
          leading: pageIndex != 0
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: yellow,
                    size: 25,
                  ),
                  onPressed: () => changeScreen(context, SearchScreen()))
              : Builder(builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: Icon(
                        Icons.menu,
                        color: yellow,
                      ));
                }),
          // actions: [
          //   Row(
          //     children: [
          //       Text(
          //         '123',
          //         style: TextStyle(
          //             color: white, fontSize: 18, fontWeight: FontWeight.bold),
          //       ),
          //       IconButton(
          //           onPressed: () {},
          //           icon: Image(
          //             image: const AssetImage(
          //               'assets/black-coin.png',
          //             ),
          //             color: yellow,
          //             height: 20,
          //             width: 20,
          //           ))
          //     ],
          //   )
          // ],
        ),
        bottomNavigationBar: CustomNavigationBar(
            backgroundColor: black,
            scaleFactor: 0.2,
            scaleCurve: Curves.linear,
            bubbleCurve: Curves.linear,
            selectedColor: yellow,
            strokeColor: Colors.black12,
            elevation: 16,
            currentIndex: pageIndex,
            onTap: (index) {
              setState(() {
                pageIndex = index;
                controller.animateToPage(pageIndex,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linearToEaseOut);
              });
            },
            iconSize: 29,
            items: [
              CustomNavigationBarItem(icon: const Icon(Icons.home)),
              CustomNavigationBarItem(icon: const Icon(Icons.group)),
              CustomNavigationBarItem(
                icon: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)),
                    child: Icon(Icons.add, color: yellow)),
              ),
              CustomNavigationBarItem(
                  icon: const Icon(Icons.card_giftcard_sharp)),
              CustomNavigationBarItem(icon: const Icon(Icons.person)),
            ]),
        body: PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          children: buildScreens(),
        ));
  }
}
