import 'package:dartz/dartz.dart';
import '../../core/network/failure/failure.dart';

abstract class MenuRepo {
  Future<Either<void, Failure>> deleteUserAccount();
}
