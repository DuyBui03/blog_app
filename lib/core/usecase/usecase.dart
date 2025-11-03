import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class Usecase<SuccessType, Params> {
  Future<Either<Failure,SuccessType>> call(Params params);
}