import 'package:dio/dio.dart';
import '../../constants.dart';
import '../models.dart';

final host = Constants.DEFAULT_SERVER_HOST;
final ePoint = 'packs';

Future getPacks({
  final String hostApi,
}) async {
  String uri = '$host/$ePoint';

  BaseOptions options = new BaseOptions(
      contentType: 'application/json',
      method: "GET",
      responseType: ResponseType.json);
  Dio dio = new Dio(options);

  Response response = await dio.request(uri);

  if (response.statusCode == 200 && response.data != null) {
    List<Pack> packs = List<Pack>.generate(response.data.length, (index) {
      return Pack(response.data[index]);
    });

    return packs;
  } else {
    throw Exception('Failed to load post');
  }
}
