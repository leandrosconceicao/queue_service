import 'dart:convert';
import 'dart:typed_data';

abstract class ApiResponse {
  bool result;
  String message;
  ApiResponse({required this.result, required this.message});

  @override
  String toString() => 'NewApiResponse(result: $result, message: $message)';
}

class ApiRes<T> extends ApiResponse {
  T? data;
  ApiRes({this.data, required bool result, required String message})
      : super(result: result, message: message);

  ApiRes.fromJson(json) : super(message: json['message'], result: json['statusProcess']);

  ApiRes.success({String? message, T? data}) : super(message: message ?? 'Success', result: true);

  ApiRes.unknow({Object? err}) : super(message: 'Ocorreu um erro desconhecido ${err.runtimeType}', result: false);

  ApiRes.timeout() : super(message: 'Tempo de requisição excedido', result: false);

  ApiRes.connError() : super(message: 'Ocorreu um problema de conexão', result: false);

  ApiRes.socketError() : super(message: 'Não foi possível se conectar com o servidor', result: false);

  ApiRes.noDataReturned({String? message}) : super(message: message ?? 'Nenhum dado retornado', result: false);

  static String decodeReturn(json) {
    return json['message'];
  }
  @override
  String toString() => 'ApiRes(data: $data, result: $result, message: $message)';

  static ApiRes<T> parseData<T>(Uint8List body, {Function? parser}) {
    try {
      dynamic js = json.decode(utf8.decode(body));
    return ApiRes<T>(result: js['statusProcess'], message: js['message'],  data: js["statusProcess"] == true ? (parser != null && js['dados'] != null) ? parser(js['dados']) : null : null);
    } catch (e) {
      return ApiRes(result: false, message: 'Ocorreu um problema na conversão dos dados, $e');
    }
  }
}