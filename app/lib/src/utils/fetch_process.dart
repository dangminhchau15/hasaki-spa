
import 'package:app/src/dataresources/network_service_response.dart';

class FetchProcess<T> {
  bool loading;
  NetworkServiceResponse<T> response;

  FetchProcess({this.loading, this.response});
}
