import 'package:flutter_app/core/constants/constants.dart';
import 'package:flutter_app/core/error/exceptions.dart';
import 'package:flutter_app/core/error/failures.dart';
import 'package:flutter_app/core/network/connection_checker.dart';
import 'package:flutter_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_app/core/common/entities/user.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return Right(true);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if(!await connectionChecker.isConnected) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return Left(Failure('User not logged in'));
        }

        return Right(UserModel(id: session.user.id, email: session.user.email ?? '', name: ''));
      }
      final user = await fn();
      return Right(user);
    } on sb.AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if(!await connectionChecker.isConnected) {
        return Left(Failure(Constants.noConnectionMessage));
      }
      final user = await remoteDataSource.getCurrentUserData();
      return user != null ? Right(user) : Left(Failure('User not login'));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
