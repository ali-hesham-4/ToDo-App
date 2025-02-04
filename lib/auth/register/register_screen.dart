import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/Screens/HomeScreen.dart';
import 'package:to_do_application/auth/login/login_screen.dart';
import 'package:to_do_application/auth/register/customTextFormField.dart';
import 'package:to_do_application/dialog_utils.dart';
import 'package:to_do_application/firebase_utils.dart';
import 'package:to_do_application/model/myUser.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "Register_Screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController namecontroller = TextEditingController();

  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  TextEditingController confirmPasswordcontroller = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Stack(
      children: [
        Container(
          color: provider.isDark()
              ? AppColors.backgroundDarkColor
              : AppColors.backgroundLightColor,
          child: Image.asset(
            "assets/images/background.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            foregroundColor: AppColors.whiteColor,
            backgroundColor: Colors.transparent,
            title: Text(
              AppLocalizations.of(context)!.create_account,
              style: TextStyle(color: AppColors.whiteColor),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    CustomTextFormField(
                      label: AppLocalizations.of(context)!.user_name,
                      controller: namecontroller,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_user_name;
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: AppLocalizations.of(context)!.email,
                      controller: emailcontroller,
                      validator: (text) {
                        if (text == null || text == text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.email;
                        }
                        final bool emailValide = RegExp(
                                r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                            .hasMatch(text);
                        if (!emailValide) {
                          return AppLocalizations.of(context)!
                              .please_enter_valid_email;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextFormField(
                      label: AppLocalizations.of(context)!.password,
                      controller: passwordcontroller,
                      validator: (text) {
                        if (text == null || text == text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_password;
                        }
                        if (text.length < 6) {
                          return AppLocalizations.of(context)!
                              .password_should_be_at_least_6_chars;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                    CustomTextFormField(
                      label: AppLocalizations.of(context)!.confirm_password,
                      controller: confirmPasswordcontroller,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.confirm_password;
                        }
                        if (text != passwordcontroller.text) {
                          return AppLocalizations.of(context)!
                              .confirm_password_doesnt_match_password;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () {
                            register();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.create_account,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.whiteColor),
                          )),
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(
          context: context, message: AppLocalizations.of(context)!.loading);
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailcontroller.text, password: passwordcontroller.text);
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? "",
            name: namecontroller.text,
            email: emailcontroller.text);
        var authUserProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authUserProvider.updateUser(myUser);
        await FirebaseUtils.addUserToFireStore(myUser);

        print(credential.user?.uid ?? "");
        DialogUtils.hideLoading(context: context);
        DialogUtils.showMessage(
            context: context,
            message: AppLocalizations.of(context)!.register_Succssfully,
            title: AppLocalizations.of(context)!.success,
            posActionName: AppLocalizations.of(context)!.ok,
            posAction: () {
              Navigator.pop(context); // Close the dialog
              Future.delayed(Duration(milliseconds: 300), () {
                // After closing the dialog, navigate to Homescreen
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              });
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message:
                AppLocalizations.of(context)!.the_password_provided_is_too_weak,
            title: AppLocalizations.of(context)!.error,
            posActionName: AppLocalizations.of(context)!.ok,
          );
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: AppLocalizations.of(context)!
                .the_account_already_exists_for_that_email,
            title: AppLocalizations.of(context)!.error,
            posActionName: AppLocalizations.of(context)!.ok,
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
