import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/app_colors.dart';
import 'package:todo_app_project/home/auth/login/login_screen.dart';
import 'package:todo_app_project/home/settings/settings_tab.dart';
import 'package:todo_app_project/home/task_list/add_task_bottom_sheet.dart';
import 'package:todo_app_project/home/task_list/task_list_tab.dart';
import 'package:todo_app_project/providers/list_provider.dart';
import 'package:todo_app_project/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        title: Text(selectedIndex==0?
          "${AppLocalizations.of(context)!.app_title}{${userProvider.currentUser!.name}}"
            :AppLocalizations.of(context)!.settings ,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(onPressed: (){
            listProvider.taskList = [];
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          },
              icon: Icon(Icons.logout),)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icon_list.png')),
                label: AppLocalizations.of(context)!.task_list),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/icon_settings.png')),
              label: AppLocalizations.of(context)!.settings,
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: AppColors.whiteColor,
            width: 4,
          ),
        ),
        onPressed: () {
          addTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: selectedIndex == 0 ? TaskListTab() : SettingsTab(),
    );
  }

  void addTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }
}
