import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_laundry/config/app_colors.dart';

import 'package:my_laundry/config/app_session.dart';
import 'package:my_laundry/pages/auth/login_pages.dart';

import 'package:my_laundry/pages/dashboard_pages.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: AppColors.green,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.light(
              primary: AppColors.green, secondary: Colors.greenAccent[400]!),
          textTheme: GoogleFonts.latoTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      const MaterialStatePropertyAll(AppColors.green),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16)),
                  textStyle: const MaterialStatePropertyAll(
                      TextStyle(fontSize: 15))))),
      home: FutureBuilder(
        future: AppSession.getUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const LoginPages();
          }
          return const DashboardPages();
        },
      ),
    );
  }
}
