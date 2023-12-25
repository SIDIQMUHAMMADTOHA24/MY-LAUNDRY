import 'package:flutter/material.dart';
import 'package:my_laundry/config/app_constant.dart';

class DashboardPages extends StatelessWidget {
  const DashboardPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppConstant.navMenuDashboard[0]['view'],
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          child: BottomNavigationBar(
              iconSize: 30,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onTap: (value) {},
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.grey[400],
              items: AppConstant.navMenuDashboard.map((e) {
                return BottomNavigationBarItem(
                    icon: Icon(e['icon']), label: e['label']);
              }).toList()),
        ),
      ),
    );
  }
}
