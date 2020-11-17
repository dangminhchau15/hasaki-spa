import 'package:app/src/base/base_event.dart';

class SearchSKUEvent extends BaseEvent {
  int limit;
  String sort;
  String keyword;

  SearchSKUEvent({this.limit, this.sort, this.keyword});
}