import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/app_colors.dart';
import 'package:todo_app_project/model/task.dart';
import 'package:todo_app_project/providers/list_provider.dart';
import 'package:todo_app_project/providers/user_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;  // Add this line to accept the task object
  static final formKey = GlobalKey<FormState>();

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    selectedDate = widget.task.dateTime;  // Ensure the date is initialized correctly
  }

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.edit_task,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: EditTaskScreen.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter task title',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please enter task title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Enter task description',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please enter task description';
                          }
                          return null;
                        },
                        maxLines: 4,
                      ),
                    ),
                    Text(
                      'Select Date',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    InkWell(
                      onTap: _selectDate,
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (EditTaskScreen.formKey.currentState?.validate() == true) {
                          saveChanges(listProvider);
                        }
                      },
                      child: Text(
                        'Save Changes',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void saveChanges(ListProvider listProvider) {
    var userProvider = Provider.of<UserProvider>(context,listen: false);
    final updatedTask = Task(
      id: widget.task.id, // Ensure you maintain the same ID
      title: titleController.text,
      description: descriptionController.text,
      dateTime: selectedDate,
    );

    listProvider.updateTaskInFireStore(updatedTask,userProvider.currentUser!.id); // Update the task in Firebase
    Navigator.of(context).pop(); // Close the screen
  }
}
