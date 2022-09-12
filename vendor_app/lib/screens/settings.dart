// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vendor_app/screens/category_setting.dart';

import 'business_setting.dart';
import 'promotion_banners.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting Screen"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.business),
                title: Text('Business'),
                value: Text('Add | Update | Remove'),
                onPressed: ((context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessSettingScreen()));
                }),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.category),
                title: Text('Category'),
                value: Text('Add | Update | Remove'),
                onPressed: ((context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategorySettingScreen()));
                }),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.view_carousel),
                title: Text('Promotion Banners'),
                value: Text('Add | Update | Remove'),
                onPressed: ((context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PromotionBannerSetting()));
                }),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
