import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:flutter/material.dart';
typedef ChangeValue(String itemValue);

Widget combobox<T>(List<T> data, Size size, double width, T itemValue,
    BuildContext context, ChangeValue changeValue) {
  return Container(
      decoration: BoxDecoration(
        color: ColorData.colorsWhite,
        border: Border.all(
          color: ColorData.colorsBorderOutline,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(Dimen.border),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: Dimen.kDefaultPadding - 8, bottom: Dimen.kDefaultPadding - 8),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              decoration: InputDecoration.collapsed(hintText: ''),
              value: itemValue,
              items: data.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(
                    "$value",
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                changeValue(value);
              },
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ),
      ));
}
