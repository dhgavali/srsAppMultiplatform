import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/domain/repositories/WorkoutPlanRepository.dart';
import 'package:srsappmultiplatform/domain/usecases/UseCase.dart';

class FetchCompletedWorkoutPlansUseCase implements UseCase<List<WorkoutPlan>, String> {
  final WorkoutPlanRepository workoutPlanRepository;

  FetchCompletedWorkoutPlansUseCase({required this.workoutPlanRepository});

  @override
  Future<Result<List<WorkoutPlan>>> call(String userId) async {
    return await workoutPlanRepository.fetchCompletedWorkoutPlans(userId);
  }
}