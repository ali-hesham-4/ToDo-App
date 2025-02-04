import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/Screens/HomeScreen.dart';
import 'package:to_do_application/auth/register/customTextFormField.dart';
import 'package:to_do_application/auth/register/register_screen.dart';
import 'package:to_do_application/dialog_utils.dart';
import 'package:to_do_application/firebase_utils.dart';
import 'package:to_do_application/model/myUser.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "LoginScreen_Screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

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
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        AppLocalizations.of(context)!.welcome_back,
                        style: provider.isDark()
                            ? Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.whiteColor)
                            : Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    CustomTextFormField(
                      label: AppLocalizations.of(context)!.email,
                      controller: emailcontroller,
                      validator: (text) {
                        if (text == null || text == text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_email;
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
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColors.whiteColor),
                          )),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegisterScreen.routeName);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.or_create_my_account,
                            style: TextStyle(
                                color: AppColors.primaryColor, fontSize: 20)))
                  ],
                ),
              )),
        ),
      ],
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(
          context: context, message: AppLocalizations.of(context)!.loading);
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailcontroller.text, password: passwordcontroller.text);
        var user =
            await FirebaseUtils.readFromFireStore(credential.user?.uid ?? "");
        if (user == null) {
          return;
        }
        var authUserProvider =
            Provider.of<AuthUserProvider>(context, listen: false);
        authUserProvider.updateUser(user);
        DialogUtils.hideLoading(context: context);
        DialogUtils.showMessage(
            context: context,
            posActionName: AppLocalizations.of(context)!.ok,
            message: AppLocalizations.of(context)!.login_succssfully,
            title: AppLocalizations.of(context)!.success,
            posAction: () {
              Navigator.pop(context); // Close the dialog
              Future.delayed(Duration(milliseconds: 300), () {
                // After closing the dialog, navigate to Homescreen
                Navigator.of(context).pushNamed(Homescreen.routeName);
              });
            });
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: AppLocalizations.of(context)!.no_user_found_for_that_email,
            title: AppLocalizations.of(context)!.error,
            posActionName: AppLocalizations.of(context)!.ok,
          );
        } else if (e.code == 'wrong-password') {
          DialogUtils.hideLoading(context: context);
          DialogUtils.showMessage(
            context: context,
            message: AppLocalizations.of(context)!
                .wrong_password_provided_for_that_user,
            title: AppLocalizations.of(context)!.error,
            posActionName: AppLocalizations.of(context)!.ok,
          );
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
