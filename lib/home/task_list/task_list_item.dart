import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/app_colors.dart';
import 'package:todo_app_project/firebase_utils.dart';
import 'package:todo_app_project/home/task_list/edit_task_screen.dart';
import 'package:todo_app_project/model/task.dart';
import 'package:todo_app_project/providers/list_provider.dart';
import 'package:todo_app_project/providers/user_provider.dart';

import 'edit_task_screen.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                var userProvider = Provider.of<UserProvider>(context,listen: false);
                FirebaseUtils.deleteTaskFromFireStore(task,userProvider.currentUser!.id)
                   .then((value){
                  print('Task deleted successfully');
                  listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
                })
                    .timeout(
                  Duration(seconds: 1),
                  onTimeout: () {
                    print('Task deleted successfully');
                    listProvider.getAllTasksFromFireStore(userProvider.currentUser!.id);
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(task: task),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: AppColors.primaryColor,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: 4,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.primaryColor),
                        ),
                        Text(
                          task.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 35,
                    color: AppColors.whiteColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}