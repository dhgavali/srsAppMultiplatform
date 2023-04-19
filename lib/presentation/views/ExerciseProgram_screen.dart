import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';
class ExerciseProgram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Program'),
      ),
      body: Center(
        child: Text('Exercise Program Page'),
      ),
    );
  }
}