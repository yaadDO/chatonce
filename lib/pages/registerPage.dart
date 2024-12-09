import 'package:chatonce/auth/authService.dart';
import 'package:chatonce/templates/button1.dart';
import 'package:flutter/material.dart';

import '../templates/textfield.dart';

class registerPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  registerPage({super.key, required this.onTap});

  final void Function()? onTap;

  void register(BuildContext context) {
    final _auth = AuthService();
       if(_pwController.text == _confirmPwController.text) {
         try {
           _auth.signUpWithEmailPassword(
             _emailController.text,
             _pwController.text,
           );
         } catch (e) {
           showDialog(
             context: context,
             builder: (context) => AlertDialog(
               title: Text(e.toString()),
             ),
           );
         }
       }
       else {
         showDialog(
           context: context,
           builder: (context) => const  AlertDialog(
             title: Text('Password Does Not Match'),
           ),
         );
       }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              'Create Account?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            text1(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            text1(
              hintText: 'Password',
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(
              height: 10,
            ),
            text1(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(
              height: 20,
            ),
            button1(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    '  Login Now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );;
  }
}
