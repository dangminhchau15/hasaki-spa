class NetworkServiceResponse<T> {
  int statusCode;
  T bodyResponse;
  bool isSuccess;
  String message;

  NetworkServiceResponse({this.statusCode,this.bodyResponse, this.isSuccess, this.message});
}

class MappedNetworkServiceResponse<T> {
  var mappedResult;
  NetworkServiceResponse<T> networkServiceResponse;
  MappedNetworkServiceResponse(
      {this.mappedResult, this.networkServiceResponse});
}
