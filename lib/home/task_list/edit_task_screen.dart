import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app_project/app_colors.dart';

class EditTaskScreen extends StatefulWidget {
  final String currentTitle;
  final String currentDescription;
  final DateTime currentDate;

  static final formKey = GlobalKey<FormState>();

  EditTaskScreen({
    required this.currentTitle,
    required this.currentDescription,
    required this.currentDate,
  });

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
    titleController = TextEditingController(text: widget.currentTitle);
    descriptionController =
        TextEditingController(text: widget.currentDescription);
    selectedDate = widget.currentDate;
  }

  @override
  Widget build(BuildContext context) {
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
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16),
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
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 16),
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
                        if (EditTaskScreen.formKey.currentState?.validate() ==
                            true) {
                          saveChanges(titleController.text,
                              descriptionController.text, selectedDate);
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

  void saveChanges(String title, String description, DateTime date) {
    print('Title: $title, Description: $description, Date: $date');

    Navigator.of(context).pop();
  }
}
