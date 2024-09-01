import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/home/auth/login/login_screen.dart';
import 'package:todo_app_project/home/auth/register/register_screen.dart';
import 'package:todo_app_project/home/home_screen.dart';
import 'package:todo_app_project/my_theme_data.dart';
import 'package:todo_app_project/providers/app_config_provider.dart';
import 'package:todo_app_project/providers/list_provider.dart';
import 'package:todo_app_project/providers/user_provider.dart';
import 'package:todo_app_project/setting_services.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final settingsServices = settingService();
  final isDarkMode = await settingsServices.getDarkMode();
  final languageCode = await settingsServices.getLanguage();
  //await FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (context) => AppConfigProvider(
          initialTheme:isDarkMode ? ThemeMode.dark:ThemeMode.light,
          initialLanguage:languageCode,
      )),
  ChangeNotifierProvider(
    create: (context)=>ListProvider(),
  ),
    ChangeNotifierProvider(
        create:(context)=>UserProvider()),
  ]
  , child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName:(context)=>RegisterScreen(),
        LoginScreen.routeName:(context)=>LoginScreen(),
      },
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
      themeMode: provider.appTheme,
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
