import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:srsappmultiplatform/presentation/viewmodels/UserViewModel.dart';

class TraineeDashboardScreen extends StatefulWidget {
  @override
  _TraineeDashboardScreenState createState() => _TraineeDashboardScreenState();
}

class _TraineeDashboardScreenState extends State<TraineeDashboardScreen> {
  List<charts.Series<TrainingVolume, String>> seriesList = [];

  @override
  void initState() {
    super.initState();
    seriesList = _createSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainee Dashboard'),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, _) {
          final user = userViewModel.user;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (user != null)
                    Text(
                      'Welcome, ${user.username}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 32.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Working Plan',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 8.0),
                          ListTile(
                            leading: Icon(Icons.fitness_center, color: Colors.white),
                            title: Text('Strength Training', style: TextStyle(color: Colors.white)),
                          ),
                          ListTile(
                            leading: Icon(Icons.timelapse, color: Colors.white),
                            title: Text('4 weeks', style: TextStyle(color: Colors.white)),
                          ),
                          ListTile(
                            leading: Icon(Icons.calendar_today, color: Colors.white),
                            title: Text('3 sessions per week', style: TextStyle(color: Colors.white)),
                          ),
                          ListTile(
                            leading: Icon(Icons.flag, color: Colors.white),
                            title: Text('Increase muscle strength', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Text(
                    'Training Progress',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8.0),
                  Container(
                    height: 250,
                    child: charts.BarChart(
                      seriesList,
                      animate: true,
                      domainAxis: charts.OrdinalAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 14,
                            color: charts.MaterialPalette.blue.shadeDefault,
                          ),
                        ),
                      ),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                            fontSize: 14,
                            color: charts.MaterialPalette.blue.shadeDefault,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Create sample data for the chart
  List<charts.Series<TrainingVolume, String>> _createSampleData() {
    final data = [
      TrainingVolume('Week 1', 100),
      TrainingVolume('Week 2', 80),
      TrainingVolume('Week 3', 200),
      TrainingVolume('Week 4', 150),
    ];

    return [
      charts.Series<TrainingVolume, String>(
        id: 'TrainingVolume',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TrainingVolume trainingVolume, _) => trainingVolume.week,
        measureFn: (TrainingVolume trainingVolume, _) => trainingVolume.volume,
        data: data,
      )
    ];
  }
}

class TrainingVolume {
  final String week;
  final int volume;

  TrainingVolume(this.week, this.volume);
}

