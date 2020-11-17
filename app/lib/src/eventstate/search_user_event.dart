import 'package:app/src/base/base_event.dart';

class SearchUserEvent extends BaseEvent {
  String sortId;
  int offset;
  int limit;
  String keyword;

  SearchUserEvent({this.sortId, this.offset, this.limit, this.keyword});
}
