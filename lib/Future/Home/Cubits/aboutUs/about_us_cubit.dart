import 'package:dio/dio.dart';
import 'package:zein_store/Apis/ExceptionsHandle.dart';
import 'package:zein_store/Apis/Network.dart';
import 'package:zein_store/Apis/Urls.dart';
import 'package:zein_store/Future/Home/models/links_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zein_store/Future/Home/models/aboutUs_model.dart';
import 'package:meta/meta.dart';

part 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit() : super(AboutUsInitial());

  void getAboutUsInfo() async {
    emit(GetAboutUsLoadingState());
    try {
      await Network.getData(url: Urls.getabout).then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          AboutUsModel aboutUs = AboutUsModel.fromJson(response.data["data"]);

          await Network.getData(url: Urls.getLinks).then((response) {
            if (response.statusCode == 200 || response.statusCode == 201) {
              Links links = Links.fromJson(response.data);
              emit(GetAboutUsSuccessfulState(aboutUs: aboutUs, links: links));
            }
          });
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          GetAboutUsErrorState(
            exceptionsHandle(error: error),
          ),
        );
      } else {
        GetAboutUsErrorState(error.toString());
      }
    }
  }
}
