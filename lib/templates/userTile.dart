import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {

  final String text;
  final void Function()? onTap;

  const UserTile({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 7,horizontal: 25),
        padding: EdgeInsets.all(22),
        child: Row(
          children: [
            const SizedBox(width: 25),
            Text(text,style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
          ],
        ),
      ),
    );
  }
}
