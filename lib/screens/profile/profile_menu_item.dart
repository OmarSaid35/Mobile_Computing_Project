import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
    final Color textColor;

  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
       this.textColor = Colors.black,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,color: textColor,),
      title: Text(title, style: TextStyle(
        color: textColor
      ),),
      trailing: Icon(Icons.chevron_right,color: textColor),
      onTap: onTap,
    );
  }
}