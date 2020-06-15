import 'package:dio/dio.dart';
import '../../constants.dart';

final host = Constants.DEFAULT_SERVER_HOST;
final ePoint = 'packs';

Future getPacks({
  final String hostApi,
}) async {
  String uri = '$host/$ePoint';
  print('URL $uri:::');

  BaseOptions options = new BaseOptions(
      contentType: 'application/json',
      method: "GET",
      responseType: ResponseType.json);
  Dio dio = new Dio(options);
  print('START /packs:::');

  Response<List> response = await dio.request(uri);

  if (response.statusCode == 200 && response.data != null) {
    final Iterable<String> RESP = response.data.map((pack) {
      final packId = pack['id'];
      final packName = pack['name'];
      final logo = pack['logo'];

      print('Текущий пак: $packName : $packId : $logo');

      return pack['logo'].toString();
    });

    print('RESPONSE: $RESP');

    return RESP.toList();
  } else {
    throw Exception('Failed to load post');
  }
}
