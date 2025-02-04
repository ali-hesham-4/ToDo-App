import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/firebase_utils.dart';
import 'package:to_do_application/model/task.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:to_do_application/providers/list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskbottomsheet extends StatefulWidget {
  @override
  State<AddTaskbottomsheet> createState() => _AddTaskbottomsheetState();
}

class _AddTaskbottomsheetState extends State<AddTaskbottomsheet> {
  var formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);

    return Container(
      decoration: BoxDecoration(
          color: provider.isDark()
              ? AppColors.backgroundDarkColor
              : AppColors.whiteColor),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.add_new_task,
              style: provider.isDark()
                  ? Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.whiteColor)
                  : Theme.of(context).textTheme.titleMedium,
            ),
            Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.enter_task_title,
                        hintStyle: provider.isDark()
                            ? Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.grayColor)
                            : Theme.of(context).textTheme.titleMedium,
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Please Enter Task Title";
                        }
                      },
                      onChanged: (Text) {
                        title = Text;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enter_task_desc,
                        hintStyle: provider.isDark()
                            ? Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.grayColor)
                            : Theme.of(context).textTheme.titleMedium,
                      ),
                      maxLines: 4,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Please Enter Task Description";
                        }
                      },
                      onChanged: (Text) {
                        description = Text;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.select_date,
                        textAlign: TextAlign.start,
                        style: provider.isDark()
                            ? Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppColors.grayColor)
                            : Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showCalender();
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
                    ),
                    ElevatedButton(
                        onPressed: () {
                          addTask();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.add_button,
                          style: provider.isDark()
                              ? Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: AppColors.whiteColor)
                              : Theme.of(context).textTheme.titleLarge,
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      Task task = Task(
        title: title,
        description: description,
        dateTime: selectedDate,
      );
      var authUserProvider =
          Provider.of<AuthUserProvider>(context, listen: false);
      FirebaseUtils.addTaskToFireStore(task, authUserProvider.currentUser!.id!)
          .then((value) {
        print("Task Added Succssfully");
        listProvider
            .getAllTasksFromFireStore(authUserProvider.currentUser!.id!);
        Navigator.pop(context);
      });
    }
  }

  void showCalender() async {
    var choosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    selectedDate = choosenDate ?? selectedDate;
    setState(() {});
  }
}
