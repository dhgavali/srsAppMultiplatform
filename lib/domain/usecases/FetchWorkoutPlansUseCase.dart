import 'package:srsappmultiplatform/core/result.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:srsappmultiplatform/domain/repositories/UserRepository.dart';
import 'usecase.dart';

class FetchWorkoutPlans extends UseCase<List<WorkoutPlan>, NoParams> {
  final UserRepository _userRepository;

  FetchWorkoutPlans(this._userRepository);

  @override
  Future<Result<List<WorkoutPlan>>> call(NoParams params) async {
    return await _userRepository.fetchWorkoutPlans();
  }
}

class NoParams {}
