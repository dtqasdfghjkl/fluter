import 'package:flutter/material.dart';
import 'package:flutter_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter_app/features/home/presentation/home_scaffold.dart';
import 'package:flutter_app/features/home/presentation/tabs/dashboard_tab.dart';
import 'package:flutter_app/features/home/presentation/tabs/setting_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    BlogPage(),
    SettingTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      body: _tabs[_selectedIndex],
      selectedIndex: _selectedIndex,
      onTabSelected: _onItemTapped,
    );
  }
}