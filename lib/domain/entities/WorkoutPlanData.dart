import 'dart:convert';
class Exercise {
  String id;
  String name;
  int sets;
  int reps;
  int weight;
  String photo;
  String notes;
  String video;
  bool completed;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.notes,
    required this.photo,
    required this.video,
    required this.completed,
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
      completed: json['completed'],
      notes: json['notes'],
    );
  }
}

class WorkoutPlan {
  String id;
  String userId;
  int week;
  int day;
  List<Exercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.userId,
    required this.week,
    required this.day,
    required this.exercises,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['_id'],
      userId: json['userId'],
      week: json['week'],
      day: json['day'],
      exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}



class ApiResponse {
  String status;
  int results;
  Data data;

  ApiResponse({
    required this.status,
    required this.results,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      results: json['results'],
      data: Data.fromJson(json['data']),
    );
  }
}


class Data {
  List<WorkoutPlan> workoutplans;

  Data({required this.workoutplans});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      workoutplans: (json['workoutplans'] as List)
          .map((e) => WorkoutPlan.fromJson(e))
          .toList(),
    );
  }
}
