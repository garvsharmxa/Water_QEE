import 'package:flutter/material.dart';
import 'package:sample/Views/Graph/Screen/GraphScreen.dart';
import 'package:sample/Views/Home/Screen/HomeScreen.dart';
import 'package:sample/Views/Map/Screen/MapScreen.dart';
import 'package:sample/Views/Settings/Screen/SettingsScreen.dart';

class BottomNav extends StatefulWidget {
  final loginToken;
  final id;
  BottomNav({super.key, this.loginToken, this.id});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentstate = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentstate = index;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(),
      MapScreen(),
      GraphScreen(),
      SettingScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: currentstate,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Colors.white,
        destinations: const[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Map',),
          NavigationDestination(
            icon: Icon(Icons.auto_graph),
            label: 'Graph',),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',),
        ],
        selectedIndex: currentstate,
        onDestinationSelected: (index) {
          _onItemTapped(index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
