class TrainerRequest {
  final String id;
  final String trainerId;
  final String traineeId;
  final String trainerPackageId;
  final String status;

  TrainerRequest({
    required this.id,
    required this.trainerId,
    required this.traineeId,
    required this.trainerPackageId,
    required this.status,
  });

  factory TrainerRequest.fromJson(Map<String, dynamic> json) {
    return TrainerRequest(
      id: json['_id'],
      trainerId: json['trainer'],
      traineeId: json['trainee'],
      trainerPackageId: json['trainerPackage'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainer': trainerId,
      'trainee': traineeId,
      'trainerPackage': trainerPackageId,
      'status': status,
    };
  }
}