import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/firebase_utils.dart';
import 'package:todo_app_project/home/task_list/task_list_item.dart';
import 'package:todo_app_project/model/task.dart';
import 'package:todo_app_project/providers/list_provider.dart';
import 'package:todo_app_project/providers/user_provider.dart';

class TaskListTab extends StatefulWidget {
  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    if(listProvider.taskList.isEmpty){
      listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
    }
    return Container(
      child: Column(
        children: [
          EasyDateTimeLine(
            initialDate: DateTime.now(),
            onDateChange: (selectedDate) {
              listProvider.changeSelectDate(selectedDate,userProvider.currentUser!.id);
            },
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),
            dayProps: const EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              activeDayStyle: DayStyle(
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
            ),
          ),
          Expanded(
            child:listProvider.taskList.isEmpty?
            Center(child: Text('No tasks Added'))
                :
            ListView.builder(
              itemBuilder: (context, index) {
                return TaskListItem(
                  task:listProvider.taskList[index],

                );
              },
              itemCount: listProvider.taskList.length,
            ),
          )
        ],
      ),
    );
  }


}