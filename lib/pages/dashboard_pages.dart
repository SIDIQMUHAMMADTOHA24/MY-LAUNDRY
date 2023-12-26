import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/providers/dashboard_provider.dart';

class DashboardPages extends StatelessWidget {
  const DashboardPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, wiRef, __) {
          int navindex = wiRef.watch(dashboardNavIndexProvider);
          return AppConstant.navMenuDashboard[navindex]['view'] as Widget;
        },
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
        child: Consumer(builder: (_, wiRef, __) {
          int navindex = wiRef.watch(dashboardNavIndexProvider);
          return Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            child: BottomNavigationBar(
                currentIndex: navindex,
                iconSize: 30,
                backgroundColor: Colors.transparent,
                elevation: 0,
                onTap: (value) {
                  wiRef.read(dashboardNavIndexProvider.notifier).state = value;
                },
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey[400],
                items: AppConstant.navMenuDashboard.map((e) {
                  return BottomNavigationBarItem(
                      icon: Icon(e['icon']), label: e['label']);
                }).toList()),
          );
        }),
      ),
    );
  }
}
