import 'package:chatbot/login/data/models/auth_success_model.dart';
import 'package:dartz/dartz.dart';
import '../../../core/network/failure/failure.dart';

abstract class AuthRepo {
  Future<Either<AuthSuccessModel, Failure>> requestForAccessToken();
}
