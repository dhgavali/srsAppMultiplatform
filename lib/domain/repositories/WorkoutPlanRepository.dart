// domain/repositories/workout_plan_repository.dart
import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';

abstract class WorkoutPlanRepository {
  Future<Result<List<WorkoutPlan>>> fetchWorkoutPlansByUserId(String userId);
  Future<Result<List<WorkoutPlan>>> fetchCompletedWorkoutPlans(String userId);
}
