import 'package:d_button/d_button.dart';
import 'package:d_info/d_info.dart';

import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_laundry/config/app_assets.dart';
import 'package:my_laundry/config/app_colors.dart';
import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/config/app_response.dart';
import 'package:my_laundry/config/app_session.dart';
import 'package:my_laundry/config/failure.dart';
import 'package:my_laundry/config/nav.dart';
import 'package:my_laundry/data_source/data_source.dart';
import 'package:my_laundry/pages/auth/register_pages.dart';
import 'package:my_laundry/pages/dashboard_pages.dart';
import 'package:my_laundry/pages/widget/field_data_user_widget.dart';
import 'package:my_laundry/providers/login_providers.dart';

class LoginPages extends ConsumerStatefulWidget {
  const LoginPages({super.key});

  @override
  ConsumerState<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends ConsumerState<LoginPages> {
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    setLoginStatus(ref, 'Loading');

    UserDataSource.login(
      email: edtEmail.text,
      password: edtPassword.text,
    ).then((value) {
      String newStatus = '';

      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              newStatus = 'Server Error';
              DInfo.toastError(newStatus);
              break;
            case NotFoundFailure:
              newStatus = 'Error Not Found';
              DInfo.toastError(newStatus);
              break;
            case ForbiddenFailure:
              newStatus = 'You don\'t have access';
              DInfo.toastError(newStatus);
              break;
            case BadRequestFailure:
              newStatus = 'Bad request';
              DInfo.toastError(newStatus);
              break;
            case InvalidInputFailure:
              newStatus = 'Invalid Input';
              AppResponse.invalidInput(context, failure.mesaage ?? '{}');
              break;
            case UnauthorisedFailure:
              newStatus = 'Login Failed';
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = 'Request Error';
              DInfo.toastError(newStatus);
              newStatus = failure.mesaage ?? '-';
              break;
          }
          setLoginStatus(ref, newStatus);
        },
        (result) {
          AppSession.setUser(result['data']);
          AppSession.setBearerToken(result['token']);
          DInfo.toastSuccess('Login Success');
          setLoginStatus(ref, 'Success');
          Nav.replace(context, const DashboardPages());
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.bgAuth,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.sizeOf(context).height / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppConstant.appName,
                        style: GoogleFonts.poppins(
                            fontSize: 40,
                            color: Colors.green[400],
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.green.withOpacity(0.5)),
                      )
                    ],
                  ),
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        FieldDataUserWidget(
                          controller: edtEmail,
                          hint: 'Email',
                          icon: const Icon(
                            Icons.email,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FieldDataUserWidget(
                          controller: edtPassword,
                          hint: 'Password',
                          icon: const Icon(
                            Icons.key,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                          child: Row(children: [
                            AspectRatio(
                                aspectRatio: 1,
                                child: DButtonFlat(
                                    onClick: () {
                                      Nav.push(context, const RegisterPages());
                                    },
                                    mainColor: Colors.white70,
                                    radius: 10,
                                    padding: const EdgeInsets.all(0),
                                    child: const Text(
                                      'REG',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ))),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Consumer(builder: (_, wiRef, __) {
                                String status =
                                    wiRef.watch(loginStatusProviders);

                                if (status == 'Loading') {
                                  return DView.loadingCircle();
                                }
                                return ElevatedButton(
                                    onPressed: () {
                                      //Logic
                                      execute();
                                    },
                                    style: const ButtonStyle(
                                        alignment: Alignment.centerLeft),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.5),
                                      child: Text(
                                        'Login',
                                      ),
                                    ));
                              }),
                            )
                          ]),
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
