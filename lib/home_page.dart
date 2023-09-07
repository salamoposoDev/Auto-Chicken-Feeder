import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:smart_feeder/constant.dart';
import 'package:smart_feeder/screens/dashboard/dashboard_screen.dart';
import 'package:smart_feeder/screens/history/history_screen.dart';
import 'package:smart_feeder/screens/setting/setting_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int? index;

  final screens = [
    DashboardScreen(),
    const HistoryScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
            index = value;
          });
        },
        backgroundColor: Colors.grey.shade100,
        color: const Color.fromARGB(255, 199, 231, 255),
        buttonBackgroundColor: Colors.grey.shade100,
        height: 70,
        animationDuration: const Duration(milliseconds: 400),
        items: const [
          Icon(
            Icons.dashboard,
            color: AppColors.grey80,
          ),
          Icon(
            Icons.history,
            color: AppColors.grey80,
          ),
          Icon(
            Icons.tune,
            color: AppColors.grey80,
          ),
        ],
      ),
      body: screens[_currentIndex],
    );
  }
}
