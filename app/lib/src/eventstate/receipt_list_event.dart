import 'package:app/src/base/base_event.dart';

class ReceiptListEvent extends BaseEvent {
  int dataCustomer;
  int total;
  int limit;
  int offset;
  String customerPhone;
  String receiptBalance;
  String receiptCode;
  int receiptType;
  int status;
  String userId;
  String fromDate;
  String toDate;

  ReceiptListEvent({
    this.dataCustomer,
    this.total,
    this.limit,
    this.offset,
    this.customerPhone,
    this.receiptBalance,
    this.receiptCode,
    this.receiptType,
    this.status,
    this.userId,
    this.fromDate,
    this.toDate,
  });
}
