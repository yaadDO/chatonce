import 'package:chatonce/pages/settings.dart';
import 'package:chatonce/templates/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Text(
                  'MOLO',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'outofafrica',
                    fontSize: 75,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const textStyle(text: 'H O M E',),
                  leading: const Icon(Icons.home, color: Colors.white,),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title:  const textStyle(text: 'S E T T I N G S',),
                  leading: const Icon(Icons.settings, color: Colors.white),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const textStyle(text: 'S H A R E  A P P',),
                  leading: const Icon(Icons.share, color: Colors.white,),
                  onTap: () {
                    Share.share('com.once.molo');
                  }
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.white),
                    title: const textStyle(text: 'A B O U T',),
                    onTap: () {
                      info(context);
                    },
                  ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 15),
            child: ListTile(
              title: const textStyle(text: 'L O G O U T',),
              leading: const Icon(Icons.logout_sharp, color: Colors.white),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }

  Future info(dynamic context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: const Text('Info:', style: TextStyle(color: Colors.white,fontSize: 40)),
      content: const Text(
        'Published by : once software\nRelease Date: TBD\nVersion: Beta',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    ),
  );
}
