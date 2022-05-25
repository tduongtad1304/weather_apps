import 'package:http/http.dart' as http;

String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  final String errMsg =
      'Requested failed\nStatus Code: $statusCode\nReason Phrase: $reasonPhrase';

  return errMsg;
}
