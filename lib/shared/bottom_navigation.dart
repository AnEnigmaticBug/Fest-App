import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final Color selectedItemColor;
  final int initialIndex;

  BottomNavigation({
    Key key,
    @required this.selectedItemColor,
    @required this.initialIndex,
  }) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12.0,
      selectedItemColor: widget.selectedItemColor,
      unselectedItemColor: Colors.black,
      items: [
        _bottomNavigationItem('Profile', 'images/profile.png'),
        _bottomNavigationItem('Shop', 'images/eat.png'),
        _bottomNavigationItem('History', 'images/history.png'),
        _bottomNavigationItem('Events', 'images/event.png'),
        _bottomNavigationItem('More', 'images/more.png'),
      ],
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  BottomNavigationBarItem _bottomNavigationItem(
      String title, String iconAsset) {
    return BottomNavigationBarItem(
      icon: Image.asset(iconAsset),
      activeIcon: Image.asset(iconAsset, color: widget.selectedItemColor),
      title: Text(title),
    );
  }
}
