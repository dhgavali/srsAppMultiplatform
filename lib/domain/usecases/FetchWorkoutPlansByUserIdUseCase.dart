import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/domain/repositories/WorkoutPlanRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/usecase.dart';

class FetchWorkoutPlansByUserIdUseCase implements UseCase<List<WorkoutPlan>, String> {
  final WorkoutPlanRepository workoutPlanRepository;

  FetchWorkoutPlansByUserIdUseCase({required this.workoutPlanRepository});

  @override
  Future<Result<List<WorkoutPlan>>> call(String userId) async {
    return await workoutPlanRepository.fetchWorkoutPlansByUserId(userId);
  }
}
