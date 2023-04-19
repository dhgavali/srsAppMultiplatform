import 'package:flutter/material.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
class CustomRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  CustomRow({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[Row(
      children: [

        Icon(icon,size: 35,),
        Padding(padding: EdgeInsets.fromLTRB(15.0,0,0,0),
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 5),
            Text(value),

          ],
        ),
          ),
      ],
    ),
        SizedBox(height: 40),
    ],
    );
  }
}
