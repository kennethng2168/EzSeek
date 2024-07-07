import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../utils/tik_tok_icons_icons.dart';

// Define a StateProvider for the current screen index
final currentScreenProvider = StateProvider<int>((ref) => 0);

class BottomBar extends ConsumerWidget {
  static const double NavigationIconSize = 20.0;
  static const double CreateButtonWidth = 38.0;

  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget customCreateIcon = Container(
      width: 45.0,
      height: 27.0,
      child: Stack(children: [
        Container(
            margin: EdgeInsets.only(left: 10.0),
            width: CreateButtonWidth,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(7.0))),
        Container(
            margin: EdgeInsets.only(right: 10.0),
            width: CreateButtonWidth,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7.0))),
        Center(
            child: Container(
          height: double.infinity,
          width: CreateButtonWidth,
          decoration: BoxDecoration(
              color: ref.read(screenIndexProvider) == 0
                  ? Colors.white
                  : Colors.black,
              borderRadius: BorderRadius.circular(7.0)),
          child: Icon(
            Icons.add,
            color: ref.read(screenIndexProvider) == 0
                ? Colors.black
                : Colors.white,
            size: 20.0,
          ),
        )),
      ]),
    );

    return Container(
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menuButton(ref, 'Home', TikTokIcons.home, 0),
              menuButton(ref, 'Try On', Icons.shopping_bag, 1),
              SizedBox(
                width: 15,
              ),
              customCreateIcon,
              SizedBox(
                width: 15,
              ),
              menuButton(ref, 'ESG Album', Icons.photo_album, 2),
              menuButton(ref, 'Profile', TikTokIcons.profile, 3)
            ],
          ),
          SizedBox(
            height: Platform.isIOS ? 40 : 10,
          )
        ],
      ),
    );
  }

  Widget menuButton(WidgetRef ref, String text, IconData icon, int index) {
    return GestureDetector(
        onTap: () {
          ref.read(screenIndexProvider.notifier).state = index;
          print(index);
        },
        child: Container(
          height: 45,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon,
                  color: ref.read(screenIndexProvider) == 0
                      ? ref.read(screenIndexProvider) == index
                          ? Colors.white
                          : Colors.white70
                      : ref.read(screenIndexProvider) == index
                          ? Colors.black
                          : Colors.black54,
                  size: NavigationIconSize),
              SizedBox(
                height: 7,
              ),
              Text(
                text,
                style: TextStyle(
                    fontWeight: ref.read(screenIndexProvider) == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: ref.read(screenIndexProvider) == 0
                        ? ref.read(screenIndexProvider) == index
                            ? Colors.white
                            : Colors.white70
                        : ref.read(screenIndexProvider) == index
                            ? Colors.black
                            : Colors.black54,
                    fontSize: 11.0),
              )
            ],
          ),
        ));
  }
}
