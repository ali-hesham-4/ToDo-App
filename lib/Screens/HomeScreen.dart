import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/Screens/list_tab/addTaskBottomSheet.dart';
import 'package:to_do_application/Screens/list_tab/taskList_tab.dart';
import 'package:to_do_application/Screens/settings_tab/settings_tab.dart';
import 'package:to_do_application/auth/login/login_screen.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:to_do_application/providers/list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Homescreen extends StatefulWidget {
  static const String routeName = "home_Screen";

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authUserProvider = Provider.of<AuthUserProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)!.to_do_list +
                  " {${authUserProvider.currentUser!.name}}",
              style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
                onPressed: () {
                  listProvider.tasKList = [];
                  authUserProvider.currentUser = null;
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: provider.isDark()
              ? AppColors.blackDarkColor
              : AppColors.whiteColor,
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          child: SingleChildScrollView(
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.list,
                      size: 30,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      size: 30,
                    ),
                    label: "")
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          width: 70,
          height: 70,
          child: FloatingActionButton(
              onPressed: () {
                addTaskBottomSheet();
              },
              child: Icon(
                Icons.add,
                size: 35,
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: selectedIndex == 1
            ? Column(children: [
                Container(
                  color: AppColors.primaryColor,
                  width: double.infinity,
                  height: 110,
                ),
                Expanded(
                    child: selectedIndex == 0 ? TaskListTab() : SettingsTab())
              ])
            : Stack(
                children: [
                  Container(
                    color: AppColors.primaryColor,
                    width: double.infinity,
                    height: 110,
                  ),
                  selectedIndex == 0 ? TaskListTab() : SettingsTab(),
                ],
              ));
  }

  List<Widget> tab = [SettingsTab(), TaskListTab()];
  void addTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskbottomsheet());
  }
}
