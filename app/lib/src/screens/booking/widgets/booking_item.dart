import 'package:app/src/models/get_list_booking_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

class BookingItem extends StatefulWidget {
  List<Booking> bookings;
  GetListBookingResponse bookingResponse;
  int index;

  BookingItem({this.bookings, this.index, this.bookingResponse});

  @override
  _BookingItemState createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
  List<Booking> bookings;
  GetListBookingResponse bookingResponse;
  int index;

  @override
  void initState() {
    bookings = widget.bookings;
    index = widget.index;
    bookingResponse = widget.bookingResponse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var confirmAt = bookings[index]?.confirmedAt;
    var updateAt = bookings[index]?.updatedAt;
    var createdBy = bookings[index]?.user?.name;
    var bookingId = bookings[index]?.bookingId;
    var bookingNote = bookings[index]?.bookingDesc;
    var serviceName;
    var storeName;
    bookingResponse.data.serviceGroups.forEach((key, value) {
      if (bookings[index].bookingServiceId == value.serviceGroupId) {
        serviceName = value?.serviceGroupName;
      }
    });
    bookingResponse.data.stores.forEach((key, value) {
      if (bookings[index].storeId == value.storeId) {
        storeName = value?.storeName;
      }
    });
    return Column(
      children: [
        _buildItemRow("Loại dịch vụ: ", serviceName.toString().trim() != "null" ? serviceName.toString().trim() : "N/A"),
        SizedBox(height: 10),
        _buildItemRow("Note: ", bookingNote.toString().trim() != "null" ? bookingNote.toString().trim() : "N/A"),
        SizedBox(height: 10),
        _buildItemRow("Confirm At: ", confirmAt.toString().trim() != "null" ? confirmAt.toString().trim() : "N/A"),
        SizedBox(height: 10),
        _buildItemRow("Cửa hàng: ", storeName.toString().trim() != "null" ? storeName.toString().trim() : "N/A"),
        SizedBox(height: 10),
        _buildItemRow("Người tạo: ", createdBy.toString().trim() != "null" ? createdBy.toString().trim() : "N/A"),
        SizedBox(height: 10),
        _buildItemRow("Updated Date: ", updateAt.toString().trim() != "null" ? updateAt.toString().trim() : "N/A"),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildItemRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16, fontFamily: FontsName.textHelveticaNeueRegular),
        ),
        Padding(
          padding: EdgeInsets.only(right: 40),
          child: Text(
            value,
            style: TextStyle(
                fontSize: 16,
                color: ColorData.colorsBlack,
                fontWeight: FontWeight.bold,
                fontFamily: FontsName.textHelveticaNeueBold),
          ),
        ),
      ],
    );
  }
}
