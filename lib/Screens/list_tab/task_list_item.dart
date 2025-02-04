import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/Screens/editing_screen/editing_screen.dart';
import 'package:to_do_application/firebase_utils.dart';
import 'package:to_do_application/model/task.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:to_do_application/providers/list_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskListItem extends StatefulWidget {
  Task task;
  TaskListItem({required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  Widget build(BuildContext context) {
    var authUserProvider = Provider.of<AuthUserProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var listProvider = Provider.of<ListProvider>(context);
    return Padding(
      padding: EdgeInsets.all(12),
      child: Slidable(
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
            extentRatio: 0.50,
            // A motion is a widget used to control how the pane animates.
            motion: const DrawerMotion(),

            // A pane can dismiss the Slidable.
            dismissible: DismissiblePane(onDismissed: () {}),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                borderRadius: BorderRadius.circular(15),
                onPressed: (context) {
                  FirebaseUtils.deleteTaskFromFireStore(
                          widget.task, authUserProvider.currentUser!.id!)
                      .then((value) {
                    print("Task Deletd Successfully");
                    listProvider.getAllTasksFromFireStore(
                        authUserProvider.currentUser!.id!);
                  });
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: AppLocalizations.of(context)!.delete,
              ),
              SlidableAction(
                borderRadius: BorderRadius.circular(15),
                onPressed: (context) {
                  Navigator.pushNamed(context, EditingScreen.routeName,
                      arguments: widget.task);
                },
                backgroundColor: Color.fromARGB(255, 0, 157, 171),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: "Edit",
              ),
            ]),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: provider.isDark()
                  ? AppColors.blackDarkColor
                  : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(22)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(12),
                color: widget.task.isDone
                    ? AppColors.greenColor
                    : AppColors.primaryColor,
                height: height * 0.09,
                width: 4,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: widget.task.isDone
                            ? AppColors.greenColor
                            : AppColors.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(widget.task.description,
                      style: provider.isDark()
                          ? Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.whiteColor)
                          : Theme.of(context).textTheme.titleMedium),
                ],
              )),
              Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.01,
                    horizontal: width * 0.05,
                  ),
                  decoration: widget.task.isDone
                      ? null
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.primaryColor),
                  child: InkWell(
                      onTap: () async {
                        await FirebaseUtils.changeTaskStateFromFireStore(
                                widget.task, authUserProvider.currentUser!.id!)
                            .timeout(Duration(seconds: 1), onTimeout: () {
                          print("Task State is changed Successfully");
                        });
                        if (!widget.task.isDone) {
                          setState(() {
                            widget.task.isDone = true;
                          });

                          listProvider.getAllTasksFromFireStore(
                              authUserProvider.currentUser!.id!);
                        }
                      },
                      child: widget.task.isDone
                          ? Text(AppLocalizations.of(context)!.done,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: AppColors.greenColor))
                          : Icon(Icons.check,
                              size: 35, color: AppColors.whiteColor)))
            ],
          ),
        ),
      ),
    );
  }
}
