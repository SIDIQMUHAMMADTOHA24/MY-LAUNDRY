import 'package:dartz/dartz.dart';
import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/config/app_request.dart';
import 'package:my_laundry/config/app_response.dart';
import 'package:my_laundry/config/app_session.dart';
import 'package:my_laundry/config/failure.dart';

import 'package:http/http.dart' as http;

class PromoDataSource {
  static Future<Either<Failure, Map>> readLimit() async {
    var uri = Uri.parse('${AppConstant.baseUrl}/promo/limit');
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
