import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_laundry/config/app_assets.dart';
import 'package:my_laundry/config/app_colors.dart';
import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/config/app_session.dart';
import 'package:my_laundry/config/nav.dart';
import 'package:my_laundry/model/user_model.dart';
import 'package:my_laundry/pages/auth/login_pages.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  logout() {
    DInfo.dialogConfirmation(context, 'Logout', 'You sure to logout?',
            textNo: 'Cancel')
        .then((yes) {
      if (yes ?? false) {
        AppSession.removeUser();
        AppSession.removeBearerToken();
        Nav.replace(context, const LoginPages());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppSession.getUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return DView.loadingCircle();
        UserModel userModel = snapshot.data!;

        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: Text(
                'Account',
                style: GoogleFonts.montserrat(
                    fontSize: 24,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 70,
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          AppAssets.profile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        userModel.username,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        userModel.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomListTile(
              title: 'Change Profile',
              iconLeading: Icons.image,
              onTap: () {},
            ),
            CustomListTile(
              title: 'Edit Account',
              iconLeading: Icons.edit,
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: OutlinedButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text('Logout')),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Settings',
                style: TextStyle(
                    height: 1, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            CustomListTile(
              title: 'Dark Mode',
              iconLeading: Icons.dark_mode,
              onTap: () {},
            ),
            CustomListTile(
              title: 'Language',
              iconLeading: Icons.translate,
              onTap: () {},
            ),
            CustomListTile(
              title: 'Notifications',
              iconLeading: Icons.notifications,
              onTap: () {},
            ),
            CustomListTile(
              title: 'Feedback',
              iconLeading: Icons.feedback,
              onTap: () {},
            ),
            CustomListTile(
              title: 'Support',
              iconLeading: Icons.support_agent,
              onTap: () {},
            ),
            CustomListTile(
              title: 'About',
              iconLeading: Icons.info,
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationIcon: const Icon(
                      Icons.local_laundry_service,
                      size: 50,
                      color: AppColors.green,
                    ),
                    applicationName: AppConstant.appName,
                    applicationVersion: AppConstant.version,
                    children: [const Text(AppConstant.descriptionInfo)]);
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.iconLeading,
    required this.onTap,
  });

  final String title;
  final IconData iconLeading;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListTile(
          onTap: () => onTap(),
          dense: true,
          horizontalTitleGap: 0,
          leading: Icon(iconLeading),
          trailing: (title != 'Dark Mode')
              ? const Icon(Icons.navigate_next)
              : Switch(
                  value: false,
                  onChanged: (value) {},
                ),
          title: Text(title),
        ),
      ),
    );
  }
}
