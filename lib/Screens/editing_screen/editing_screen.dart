import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/auth/register/customTextFormField.dart';
import 'package:to_do_application/firebase_utils.dart';
import 'package:to_do_application/model/task.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:to_do_application/providers/list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditingScreen extends StatefulWidget {
  const EditingScreen({super.key});
  static const String routeName = "editing_screen";

  @override
  State<EditingScreen> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  var selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var authUserProvider = Provider.of<AuthUserProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    Task task = ModalRoute.of(context)!.settings.arguments as Task;
    TextEditingController editingTitleController =
        TextEditingController(text: task.title);
    TextEditingController editingDecController =
        TextEditingController(text: task.description);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)!.to_do_list +
                " {${authUserProvider.currentUser!.name}}",
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.10,
          color: AppColors.primaryColor,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: provider.isDark()
                    ? AppColors.blackDarkColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.edit_task,
                  style: provider.isDark()
                      ? Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.whiteColor)
                      : Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                CustomTextFormField(
                  controller: editingTitleController,
                  onChanged: (value) {
                    task.title = value;
                  },
                  validator: (text) {},
                  label: AppLocalizations.of(context)!.title,
                ),
                Spacer(),
                CustomTextFormField(
                  controller: editingDecController,
                  onChanged: (value) {
                    task.description = value;
                  },
                  validator: (text) {},
                  label: AppLocalizations.of(context)!.description,
                ),
                Spacer(),
                Text(
                  AppLocalizations.of(context)!.select_date,
                  textAlign: TextAlign.center,
                  style: provider.isDark()
                      ? Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.whiteColor)
                      : Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    var choosenDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    ).then((value) => task.dateTime = value!);
                    selectedDate = choosenDate ?? selectedDate;
                    setState(() {});
                  },
                  child: Text(
                    '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                    textAlign: TextAlign.center,
                    style: provider.isDark()
                        ? Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.whiteColor)
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      FirebaseUtils.editTask(
                              task, authUserProvider.currentUser!.id!)
                          .then((value) {
                        print("Task is edited Successfully");
                        Navigator.pop(context);
                        listProvider.getAllTasksFromFireStore(
                            authUserProvider.currentUser!.id!);
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.save_cahnges,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: AppColors.whiteColor))),
                Spacer(),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
