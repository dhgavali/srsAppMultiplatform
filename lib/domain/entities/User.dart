class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String phone;
  final String? role;
  final String dateOfBirth;
  final ExerciseLevel exerciseLevel;
  final int height;
  final int weight;
  final int muscleMass;
  final int bodyFatPercentage;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
    this.role,
    required this.dateOfBirth,
    required this.phone,
    required this.exerciseLevel,
    required this.height,
    required this.weight,
    required this.muscleMass,
    required this.bodyFatPercentage,
  });
  factory User.fromJson(Map<String, dynamic> jsonMap) {
    return User(
      id: jsonMap['id'] ?? '',
      username: jsonMap['fullName'] ?? '',
      email: jsonMap['email'] ?? '',
      token: jsonMap['token'] ?? '',
      role: jsonMap['role'] as String?,
      dateOfBirth: jsonMap['dateOfBirth'] ?? '',
      phone: jsonMap['phone'] ?? '',
      exerciseLevel: ExerciseLevel.fromJson(jsonMap['exerciseLevel'] ?? {}),
      height: jsonMap['height'] ?? 0,
      weight: jsonMap['weight'] ?? 0,
      muscleMass: jsonMap['muscleMass'] ?? 0,
      bodyFatPercentage: jsonMap['bodyFatPercentage'] ?? 0,
    );
  }


  User copyWith({
    String? token,
    String? role,
    ExerciseLevel? exerciseLevel,
    int? height,
    int? weight,
    int? muscleMass,
    int? bodyFatPercentage,
  }) {
    return User(
      id: this.id,
      username: this.username,
      email: this.email,
      token: token ?? this.token,
      role: role ?? this.role,
      dateOfBirth: this.dateOfBirth,
      phone: this.phone,
      exerciseLevel: exerciseLevel ?? this.exerciseLevel,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      muscleMass: muscleMass ?? this.muscleMass,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
    );
  }

// Other methods or properties as needed
}
class ExerciseLevel {
  final int squat;
  final int benchPress;
  final int pullUpReps;
  final int pushUpReps;
  final int deadLift;

  ExerciseLevel({
    required this.squat,
    required this.benchPress,
    required this.pullUpReps,
    required this.pushUpReps,
    required this.deadLift,
  });

  factory ExerciseLevel.fromJson(Map<String, dynamic> json) {
    return ExerciseLevel(
      squat: json['squat'],
      benchPress: json['benchPress'],
      pullUpReps: json['pullUpReps'],
      pushUpReps: json['pushUpReps'],
      deadLift: json['deadLift'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'squat': squat,
      'benchPress': benchPress,
      'pullUpReps': pullUpReps,
      'pushUpReps': pushUpReps,
      'deadLift': deadLift,
    };
  }
}
