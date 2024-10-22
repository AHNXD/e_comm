import 'package:e_comm/Utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_comm/Utils/services/save.dart';
import 'package:flutter/material.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<ChangeLocaleState> {
  LocaleCubit() : super(ChangeLocaleState(locale: const Locale("en")));

  Future<void> getSaveLanguage() async {
    final String? cachedLanguageCode = await SaveService.retrieve("LOCALE");

    lang = cachedLanguageCode ?? "en";
    emit(ChangeLocaleState(locale: Locale(cachedLanguageCode ?? "en")));
  }

  Future<void> changeLanguage(String languageCode) async {
    await SaveService.save("LOCALE", languageCode);
    lang = languageCode;
    emit(ChangeLocaleState(locale: Locale(languageCode)));
  }
}
