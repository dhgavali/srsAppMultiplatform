import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMaxExerciseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  CustomMaxExerciseCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.cyan.shade50,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100)),
              child: Icon(icon),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
