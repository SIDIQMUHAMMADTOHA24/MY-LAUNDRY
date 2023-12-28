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
import 'package:my_laundry/config/failure.dart';
import 'package:my_laundry/data_source/user_source.dart';
import 'package:my_laundry/pages/widget/field_data_user_widget.dart';
import 'package:my_laundry/providers/register_providers.dart';

class RegisterPages extends ConsumerStatefulWidget {
  const RegisterPages({super.key});

  @override
  ConsumerState<RegisterPages> createState() => _RegisterPagesState();
}

class _RegisterPagesState extends ConsumerState<RegisterPages> {
  final edtUsername = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  execute() {
    bool validate = formKey.currentState!.validate();
    if (!validate) return;

    setRegisterStatus(ref, 'Loading');

    UserDataSource.register(
            userName: edtUsername.text,
            email: edtEmail.text,
            password: edtPassword.text)
        .then((value) {
      String newStatus = '';

      value.fold((failure) {
        //Failure
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
            newStatus = 'You Don\'t Have Access';
            DInfo.toastError(newStatus);
            break;
          case BadRequestFailure:
            newStatus = 'Bad Request';
            DInfo.toastError(newStatus);
            break;
          case InvalidInputFailure:
            newStatus = 'Invalid Input';
            AppResponse.invalidInput(context, failure.mesaage ?? '{}');
            break;
          case UnauthorisedFailure:
            newStatus = 'Unauthorised';
            DInfo.toastError(newStatus);
          default:
            newStatus = 'Request Error';
            DInfo.toastError(newStatus);
            newStatus = failure.mesaage ?? '-';
            break;
        }
        setRegisterStatus(ref, newStatus);
      }, (result) {
        DInfo.toastSuccess('Register Success');
        setRegisterStatus(ref, 'Success');
      });
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
                          controller: edtUsername,
                          hint: 'User Name',
                          icon: const Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                                      Navigator.pop(context);
                                    },
                                    mainColor: Colors.white70,
                                    radius: 10,
                                    padding: const EdgeInsets.all(0),
                                    child: const Text(
                                      'LOG',
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
                                    wiRef.watch(registerStatusProviders);

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
                                        'Register',
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
