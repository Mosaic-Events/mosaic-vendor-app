import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vendor_app/screens/business_setting.dart';
import 'package:vendor_app/screens/category_setting.dart';
import 'package:vendor_app/screens/promotion_banners.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting Screen"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.business),
                title: const Text('Business'),
                value: const Text('Add | Update | Remove'),
                onPressed: ((context) {
                  Get.to(() => const BusinessSettingScreen());
                }),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.category),
                title: const Text('Category'),
                value: const Text('Add | Update | Remove'),
                onPressed: ((context) {
                  Get.to(() => const CategorySettingScreen());
                }),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.view_carousel),
                title: const Text('Promotion Banners'),
                value: const Text('Add | Update | Remove'),
                onPressed: ((context) {
                  Get.to(() => const PromotionBannerSetting());
                }),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: const Icon(Icons.format_paint),
                title: const Text('Enable custom theme'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
