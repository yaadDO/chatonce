import 'package:chatonce/pages/settings.dart';
import 'package:flutter/material.dart';

import 'auth/authService.dart';

class myDrawer extends StatelessWidget {
  const myDrawer({super.key});

  void logout() {
    final auth = AuthService();
    auth.SignOut();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('S E T T I N G S'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                    ),
                    );
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0,bottom: 15),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout_sharp),
              onTap: logout,

            ),
          ),
        ],
      ),
    );
  }
}
