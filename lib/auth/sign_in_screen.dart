// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:student_handbook/auth/sign_up_screen.dart';
import 'package:student_handbook/models/auth_methods.dart';
import 'package:student_handbook/shared/validators.dart';
import 'package:student_handbook/utils.dart';
import 'package:student_handbook/widgets/navigation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = true;

  @override
  void dispose() {
    super.dispose();
    emailField.dispose();
    passwordField.dispose();
  }

  void _showerrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'An Error Occurs',
          style: TextStyle(color: Colors.blue),
        ),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
              child: const Text('Okay'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop())
        ],
      ),
    );
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    // sign up using auth methods
    String res = await AuthMethods().loginUser(
      email: emailField.text,
      password: passwordField.text,
    );
    // if string returned is success, user has been created
    if (res == 'success') {
      //navigate to the homescreen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavigationForScreen()),
          (route) => false);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.asset('assets/images/CMDI-LOGO-1.png'),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        return !Validators.isValidEmail(value!)
                            ? 'Enter a valid email.'
                            : null;
                      },
                      onSaved: (value) {
                        emailField = value! as TextEditingController;
                      },
                      controller: emailField,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: 'email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        return value!.length < 6 ? 'Enter 6 characters' : null;
                      },
                      onSaved: (value) {
                        passwordField = value! as TextEditingController;
                      },
                      obscureText: isPasswordVisible,
                      controller: passwordField,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: isPasswordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        hintText: 'password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        color: Colors.green,
                      ),
                      child: !isLoading
                          ? const Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text('Not a member? '),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
