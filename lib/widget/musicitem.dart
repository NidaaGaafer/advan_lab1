import 'package:flutter/material.dart';

class MusicCard extends StatelessWidget {
  final void Function()? onPressed;
  final Color color;
  final IconData icon;
  final String label;
  const MusicCard(
      {required this.color,
      required this.icon,
      required this.label,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
