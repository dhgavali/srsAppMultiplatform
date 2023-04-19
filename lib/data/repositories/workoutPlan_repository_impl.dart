import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/data/datasources/remote/remote_data_source.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/domain/repositories/WorkoutPlanRepository.dart';

class WorkoutPlanRepositoryImpl implements WorkoutPlanRepository {
  final RemoteDataSource _remoteDataSource;

  WorkoutPlanRepositoryImpl({required RemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<WorkoutPlan>>> fetchWorkoutPlansByUserId(String userId) async {
    try {
      final workoutPlans = await _remoteDataSource.fetchWorkoutPlansByUserId(userId);
      return workoutPlans;
    } catch (e) {
      return Result.failure("Error fetching workout plans: ${e.toString()}");
    }
  }

  @override
  Future<Result<List<WorkoutPlan>>> fetchCompletedWorkoutPlans(String userId) async {
    try {
      final completedWorkoutPlans = await _remoteDataSource.fetchCompletedWorkoutPlans(userId);
      return completedWorkoutPlans;
    } catch (e) {
      return Result.failure("Error fetching completed workout plans: ${e.toString()}");
    }
  }
}
