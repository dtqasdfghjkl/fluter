import 'package:flutter_app/core/error/failures.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogout implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;
  const UserLogout(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}