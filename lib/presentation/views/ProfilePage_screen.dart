import 'package:flutter/material.dart';
import 'package:srsappmultiplatform/domain/entities/User.dart';
import 'package:srsappmultiplatform/presentation/widgets/CustomProfileRow.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final List<IconData> icons = [
    Icons.person,
    Icons.email,
    Icons.phone,
    Icons.percent,
    Icons.monitor_weight,
  ];

  final List<IconData> iconsExercise = [
    Icons.person,
    Icons.email,
    Icons.phone,
    Icons.percent,
    Icons.monitor_weight,
  ];

  List<String> initialValues = [];
  List<String> initialExerciseValue = [];
  List<String> ExerciseValuesTitles = [
    "Max Reps PullUps",
    "Max Reps PushUps",
    "Max DeadLift Weight",
    "Max Squat Weight",
    "Max BenchPress Weight"
  ];
  List<String> initialValuesTitles = [
    "Max Reps PullUps",
    "Max Reps PushUps",
    "Max DeadLift Weight",
    "Max Squat Weight",
    "Max BenchPress Weight"
  ];

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        title: Text("ProfilePage"),
        actions: [
          Center(
         child: Padding(padding:EdgeInsets.fromLTRB(0, 0, 10, 0),
         child: Text("Edit" ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)
          ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                              image: AssetImage(
                                  "assets/page-1/images/ellipse-1-bg.png"),fit: BoxFit.cover,),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.shade200
                        ),
                        child: Icon(Icons.camera_alt,size: 20.0,color: Colors.black,),
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.user.username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blueGrey.withOpacity(0.1)),
                    child: TabBar(
                      controller: tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      labelPadding: EdgeInsets.symmetric(horizontal: 30),
                      tabs: [
                        Tab(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              "Personal detail",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Tab(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 100),
                            child: Text(
                              "Exercise",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 50),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return CustomRow(
                              icon: icons[index],
                              title: initialValuesTitles[index],
                              value: initialValues[index],
                            );
                          },
                        ),
                        ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return CustomRow(
                              icon: iconsExercise[index],
                              title: ExerciseValuesTitles[index],
                              value: initialExerciseValue[index],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    initialValues = [
      widget.user.username,
      widget.user.email,
      widget.user.phone,
      widget.user.bodyFatPercentage.toString(),
      widget.user.height.toString()
    ];

    initialExerciseValue = [
      widget.user.exerciseLevel.pullUpReps.toString(),
      widget.user.exerciseLevel.pushUpReps.toString(),
      widget.user.exerciseLevel.deadLift.toString(),
      widget.user.exerciseLevel.squat.toString(),
      widget.user.exerciseLevel.benchPress.toString()
    ];
  }
}
