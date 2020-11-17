import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum StatePage { INIT, SIGIN, MAIN }

class CheckScreenBloc {
  final inputCodeSubject = BehaviorSubject<StatePage>();
  CheckScreenBloc();
  void checkScreen() async {
    ///check intro
    await PreferenceProvider.load();
    bool isFirstIntro = PreferenceProvider.getBool(SharePrefNames.FIRST_INTRO);
    print('splash$isFirstIntro');
    String isToken =
        PreferenceProvider.getString(SharePrefNames.TOKEN, def: "");
    await new Future.delayed(const Duration(seconds: 2));
    if (isToken.length > 0) {
      //có token
      inputCodeSubject.sink.add(StatePage.MAIN);
    } else {
      inputCodeSubject.sink.add(StatePage.SIGIN);
    }
  }

  dipose() {
    inputCodeSubject.close();
  }
}
