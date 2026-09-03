import 'package:flutter/material.dart';
import 'package:flutter_project_1/Widgets/CustomElevatedButton.dart';
import 'package:flutter_project_1/Widgets/CustomTextFormField.dart';

// import 'form.dart';
class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 249),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,

          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                'SIGNUP',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
              ),
              SizedBox(height: 50),
              CustomTextFormField(
                labelText: 'Name',
                hintText: 'enter your name ',
                icon: Icons.person,
              ),
              CustomTextFormField(
                labelText: 'Email',
                hintText: 'enter your email ',
                icon: Icons.email,
              ),
              CustomTextFormField(
                labelText: 'Phone',
                hintText: 'enter your number ',
                icon: Icons.phone,
              ),
              CustomTextFormField(
                labelText: 'Password',
                hintText: 'enter your password ',
                icon: Icons.lock_open_outlined,
                hidePassword: true,
              ),
              CustomTextFormField(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password ',
                icon: Icons.lock_open_outlined,
                hidePassword: true,
              ),
              SizedBox(height: 30),
              CustomElevatedButton(formKey: _formKey,),
              SizedBox(height: 20),
              Text('Or SignUp with'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 10,
                ),
                child: Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.facebook)),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.alternate_email),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.apple)),
                ],
              ),
              SizedBox(height: 10),
              Text('Already have an account ? LOGIN'),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // body: TaskList(),
    );
  }
}
