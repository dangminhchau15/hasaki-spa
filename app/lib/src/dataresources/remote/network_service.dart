import 'package:app/src/dataresources/restclient.dart';

abstract class NetworkService {
  RestClient rest;
  NetworkService(this.rest);
}
