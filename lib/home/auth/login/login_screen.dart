import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/app_colors.dart';
import 'package:todo_app_project/firebase_utils.dart';
import 'package:todo_app_project/gialog_utils.dart';
import 'package:todo_app_project/home/auth/custom_text_form_field.dart';
import 'package:todo_app_project/home/auth/register/register_screen.dart';
import 'package:todo_app_project/home/home_screen.dart';
import 'package:todo_app_project/providers/user_provider.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login_screen';

  TextEditingController emailController = TextEditingController(text: 'nehal@pharos.com');
  TextEditingController passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Login',
          style: TextStyle(color: Colors.white,fontSize: 20),
        ),
        centerTitle: true,

      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('Welcome back!',style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,),
                    ),
                    CustomTextFormField(label:'Email',
                      controller: emailController,validator: (text){
                        if(text == null || text.trim().isEmpty){
                          return 'please enter Email';
                        }
                        final bool emailValid =
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if(!emailValid){
                          return 'please enter valid Email';
                        }
                        return null;
                      },
                      keyBoardType: TextInputType.emailAddress,
                    ),
                    CustomTextFormField(label:'Password',
                      controller: passwordController,validator: (text){
                        if(text == null || text.trim().isEmpty){
                          return 'please enter password';
                        }
                        if(text.length<6){
                          return 'password must be at least 6 chars.';
                        }
                        return null;
                      },
                      keyBoardType: TextInputType.phone,
                      obscureText: true,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(onPressed: (){
                        login(context);
                      },
                        child:Text('Login',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(onPressed: (){
                        Navigator.of(context).pushNamed(RegisterScreen.routeName);
                      },
                        child:Text('Or Create Account',
                          style:Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 20
                          )
                          ,
                        ),

                      ),
                    ),

                  ],))
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) async{
    if(formKey.currentState?.validate() == true){
      try {
        DialogUtils.showLoading(context: context, loadingLabel: 'Waiting...',barrierDismissible: false);
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
       var user=await FirebaseUtils.readUserFromFireStore(credential.user?.uid??'');
       if(user == null){
         return;
       }
        var userProvider = Provider.of<UserProvider>(context,listen: false);
        userProvider.updateUser(user);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, content: 'Login Successfully',
        title: 'Success',posActionName: 'Ok',posAction: (){
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });

        print(credential.user?.uid??"");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid_credential') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context: context, content: 'The supplied auth credential is incorrect, malformed or has expired5',
          title: 'Error',posActionName: 'Ok');

        }
      }
    catch(e){
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, content:e.toString(),title: 'Error',posActionName: 'Ok');

      }
    }
  }
}
