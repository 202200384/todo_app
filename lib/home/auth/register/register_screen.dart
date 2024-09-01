import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/app_colors.dart';
import 'package:todo_app_project/firebase_utils.dart';
import 'package:todo_app_project/gialog_utils.dart';
import 'package:todo_app_project/home/auth/custom_text_form_field.dart';
import 'package:todo_app_project/home/home_screen.dart';
import 'package:todo_app_project/model/my_user.dart';
import 'package:todo_app_project/providers/user_provider.dart';

class RegisterScreen extends StatelessWidget {
static const String routeName = 'register_screen';
TextEditingController nameController = TextEditingController(text: 'Nehal');
TextEditingController emailController = TextEditingController(text: 'nehal@pharos.com');
TextEditingController passwordController = TextEditingController(text: '123456');
TextEditingController confirmPasswordController = TextEditingController(text: '123456');
var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
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
              CustomTextFormField(label:'User Name',
             controller: nameController,validator: (text){
                if(text == null || text.trim().isEmpty){
                  return 'please enter user name';
                }
                return null;
                }, ),
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
              CustomTextFormField(label:'Confirm Password',
                controller: confirmPasswordController,validator: (text) {
                    if (text == null || text
                        .trim()
                        .isEmpty) {
                      return 'please enter confirm password';
                    }
                    if(text.length<6){
                      return 'password must be at least 6 chars.';
                    }
                    if(text != passwordController.text){
                      return 'confirm password does not  match password';
                    }
                    return null;
                  },
              keyBoardType: TextInputType.phone,
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(onPressed: (){
                  register(context);
                },
                    child:Text('create Account',
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              )
            ],))
          ],
        ),
      ),
    );
  }

  void register(BuildContext context) async{
    if(formKey.currentState?.validate() == true){
      DialogUtils.showLoading(context:context,loadingLabel:  'loading...',
      barrierDismissible: false);
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(id:credential.user?.uid??'',
            name: nameController.text,
            email:emailController.text);
       await FirebaseUtils.addUserToFireStore(myUser);
        var userProvider = Provider.of<UserProvider>(context,listen: false);
        userProvider.updateUser(myUser);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, content: 'Register Successfully',
        title: 'Success',posActionName: 'Ok',posAction: (){
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });

        print(credential.user?.uid??"");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context: context, content: 'The password provided is too weak',
          title: 'Error',posActionName: 'Ok');

        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context: context, content: 'The account already exists for that email.',
              title: 'Error',posActionName: 'Ok');

        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context: context, content:e.toString(),
            title: 'Error',posActionName: 'Ok');


      }
    }
  }
}
