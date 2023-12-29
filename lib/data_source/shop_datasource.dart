import 'package:dartz/dartz.dart';
import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/config/app_request.dart';
import 'package:my_laundry/config/app_response.dart';
import 'package:my_laundry/config/app_session.dart';
import 'package:my_laundry/config/failure.dart';

import 'package:http/http.dart' as http;

class ShopDataSource {
  static Future<Either<Failure, Map>> readRecommendationLimit() async {
    var uri = Uri.parse('${AppConstant.baseUrl}/shop/recommendation/limit');
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(uri, headers: AppRequest.header(token));
      final data = AppResponse.data(response);
      return Right(data);
    } on Exception catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetechFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> searchByCity(
      {required String name}) async {
    var uri = Uri.parse('${AppConstant.baseUrl}/shop/search/city/$name');
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(uri, headers: AppRequest.header(token));
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
