class Exercise {
  String id;
  String name;
  int sets;
  int reps;
  int weight;
  String photo;
  String video;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.photo,
    required this.video,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'],
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight'],
      photo: json['photo'],
      video: json['video'],
    );
  }
}

class WorkoutPlan {
  String id;
  String userId;
  int week;
  int day;
  bool completed;
  List<Exercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.userId,
    required this.week,
    required this.day,
    required this.completed,
    required this.exercises,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['_id'],
      userId: json['userId'],
      week: json['week'],
      day: json['day'],
      completed: json['completed'],
      exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}
