import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<SuccessT, Params> {
  Future<Either<Failure, SuccessT>> call(Params params);
}
class NoParams {}