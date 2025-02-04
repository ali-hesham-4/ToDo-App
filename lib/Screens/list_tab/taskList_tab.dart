import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/Screens/list_tab/task_list_item.dart';
import 'package:to_do_application/firebase_utils.dart';
import 'package:to_do_application/model/task.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:to_do_application/providers/auth_user_provider.dart';
import 'package:to_do_application/providers/list_provider.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<Task> tasksList = [];

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authUserProvider = Provider.of<AuthUserProvider>(context);
    var provider = Provider.of<AppConfigProvider>(context);

    if (listProvider.tasKList.isEmpty) {
      listProvider.getAllTasksFromFireStore(authUserProvider.currentUser!.id!);
    }
    return Column(
      children: [
        EasyDateTimeLine(
          initialDate: listProvider.selectedDate,
          onDateChange: (selectedDate) {
            listProvider.changeSelectDate(
                selectedDate, authUserProvider.currentUser!.id!);
            //`selectedDate` the new date selected.
          },
          headerProps: EasyHeaderProps(
            monthStyle: TextStyle(
              color: provider.isDark()
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
            ),
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: EasyDayProps(
            dayStructure: DayStructure.dayStrDayNumMonth,
            todayStyle: DayStyle(
                dayNumStyle: TextStyle(
                  color: provider.isDark()
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
                dayStrStyle: TextStyle(
                    color: provider.isDark()
                        ? AppColors.whiteColor
                        : AppColors.blackColor,
                    fontSize: 12),
                monthStrStyle: TextStyle(
                    color: provider.isDark()
                        ? AppColors.whiteColor
                        : AppColors.blackColor,
                    fontSize: 12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: provider.isDark()
                      ? AppColors.blackColor
                      : AppColors.whiteColor,
                )),
            activeDayStyle: const DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff3371FF),
                    Color(0xff8426D6),
                  ],
                ),
              ),
            ),
            inactiveDayStyle: DayStyle(
              dayNumStyle: TextStyle(
                color: provider.isDark()
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
              ),
              dayStrStyle: TextStyle(
                  color: provider.isDark()
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fontSize: 12),
              monthStrStyle: TextStyle(
                  color: provider.isDark()
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fontSize: 12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: provider.isDark()
                    ? AppColors.blackColor
                    : AppColors.whiteColor,
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     Color(0xff3371FF),
                //     Color(0xff8426D6),
                //   ],
                // ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskListItem(
                task: listProvider.tasKList[index],
              );
            },
            itemCount: listProvider.tasKList.length,
          ),
        ),
      ],
    );
  }
}
