import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> post(
      /*what is before post => is return type */
      {required body,
      required String url,
      required String token,
      Map<String, String>? headers,
      String? contentType}) async {
    /*url is the only one required*/
    var response = await dio.post(url,
        data: body,
        options: Options(
            contentType: contentType ?? "application/x-www-form-urlencoded",
            /*not to force it with certain contentType*/
            headers: headers ?? {'Authorization': "Bearer $token"}));
    /*we need somtimes to edit headers to add another field , not Auth field only*/
    return response;
  }
}
