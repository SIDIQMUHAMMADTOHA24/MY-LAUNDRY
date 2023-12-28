import 'package:dartz/dartz.dart';
import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/config/app_request.dart';
import 'package:my_laundry/config/app_response.dart';
import 'package:my_laundry/config/failure.dart';
import 'package:http/http.dart' as http;

class UserDataSource {
  static Future<Either<Failure, Map>> register(
      {required String userName,
      required String email,
      required String password}) async {
    var uri = Uri.parse('${AppConstant.baseUrl}/register');
    try {
      final response = await http.post(uri,
          headers: AppRequest.header(),
          body: {'user_name': userName, 'email': email, 'password': password});
      final data = AppResponse.data(response);
      return Right(data);
    } on Exception catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetechFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> login(
      {required String email, required String password}) async {
    var uri = Uri.parse('${AppConstant.baseUrl}/login');
    try {
      final response = await http.post(uri,
          headers: AppRequest.header(),
          body: {'email': email, 'password': password});
      final data = AppResponse.data(response);
      return Right(data);
    } on Exception catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetechFailure(e.toString()));
    }
  }
}
