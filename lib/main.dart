import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/HomeScreen.dart';
import 'package:to_do_application/Screens/editing_screen/editing_screen.dart';
import 'package:to_do_application/auth/login/login_screen.dart';
import 'package:to_do_application/auth/register/register_screen.dart';
import 'package:to_do_application/my_theme_data.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:to_do_application/providers/list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCmiMITsWPlLL96Lve1iAwo9qBzlMTf25k",
          appId: "com.example.to_do_application",
          messagingSenderId: "764887140070",
          projectId: "todo-app-afc13"));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ListProvider()),
    ChangeNotifierProvider(create: (context) => AuthUserProvider()),
    ChangeNotifierProvider(create: (context) => AppConfigProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        Homescreen.routeName: (context) => Homescreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        EditingScreen.routeName: (context) => EditingScreen(),
      },
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      themeMode: provider.appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
    );
  }
}
