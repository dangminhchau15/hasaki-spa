import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:flutter/material.dart';
import 'fetch_process.dart';

apiSubscription(
    Stream<FetchProcess> apiResult, BuildContext context, OnClickOK onClickOK) {
  apiResult.listen((FetchProcess p) {
    if (p.loading) {
      print('showProgress');
      showProgress(context);
    } else {
      hideProgress(context);
      if (p.response.isSuccess == false) {
        if (p.response.statusCode == 401) {
          showDialogUnauth(context, p.response, () async {
            await PreferenceProvider.load();
            await PreferenceProvider.logOut();
            await Future.delayed(Duration(milliseconds: 300));
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => SignInScreen()),
            //   (Route<dynamic> route) => false,
            // );
          });
        } else {
          fetchApiResult(context, p.response, null);
        }
      } else {
        if (onClickOK != null) {
          onClickOK();
        }

        // switch (p.type) {
        //   case ApiType.performLogin:
        //     showSuccess(context, UIData.success, Icons.ac_unit);
        //     break;
        //   default:
        //     break;
        // }
      }
    }
  });
}