import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app_project/app_colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  static final formKey = GlobalKey<FormState>();

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  String title = '';

  String description = '';
  var selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.add_new_task,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
            Form(
                key: AddTaskBottomSheet.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Enter task title',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        onChanged: (text) {
                          description = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'please enter task title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Enter task description',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14)),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        onChanged: (text) {
                          title = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'please enter task description';
                          }
                          return null;
                        },
                        maxLines: 4,
                      ),
                    ),
                    Text(
                      'select Date',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    InkWell(
                      onTap: () {
                        showCalender();
                      },
                      child: Text(
                          '${selectDate.day}/${selectDate.month}/${selectDate.year}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text('Add',
                          style: Theme.of(context).textTheme.bodyLarge),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void addTask() {
    if (AddTaskBottomSheet.formKey.currentState?.validate() == true) {}
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (chosenDate != null) {
      selectDate = chosenDate;
    }
    selectDate = chosenDate ?? selectDate;
    setState(() {});
  }
}