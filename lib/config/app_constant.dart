import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:my_laundry/pages/dashboard_view/account_view.dart';

class AppConstant {
  static const appName = 'My Laundry';

  static const _host = 'http://192.168.43.74:8000';

  ///``` http://192.168.43.74:8000/api ```
  static const baseUrl = '$_host/api';

  ///``` http://192.168.43.74:8000/storage ```
  static const baseImageUrl = '$_host/storage';

  static const laundryStatusCatagory = {
    'All',
    'Pickup',
    'Queue',
    'Process',
    'Washing',
    'Dried',
    'Ironed',
    'Done',
    'Delivery'
  };

  static const user = 'user';
  static const bearerToken = 'bearer_token';
  static const version = 'v1.0.0';
  static const descriptionInfo =
      'Laundry Market App to monitor you laundry status';

  static List<Map> navMenuDashboard = [
    {'view': DView.empty('Home'), 'icon': Icons.home, 'label': 'Home'},
    {
      'view': DView.empty('My Laundry'),
      'icon': Icons.local_laundry_service,
      'label': 'My Laundry'
    },
    {
      'view': const AccountView(),
      'icon': Icons.account_circle,
      'label': 'Account'
    }
  ];
}
