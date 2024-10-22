import 'package:e_comm/Future/Home/models/contactUs_model.dart';
import 'package:e_comm/Utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:e_comm/Apis/ExceptionsHandle.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:e_comm/Apis/Urls.dart';
import 'package:meta/meta.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsInitial());
  void contactUsMessageSend(ContactusModel order) async {
    emit(ContactUsLoadingState());
    try {
      final formData = await order.toFormData();
      final response =
          await Network.postData(url: Urls.contactUs, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ContactUsSuccessfulState(msg: response.data['msg']));
      } else {
        emit(ContactUsErrorState(
            error: lang == 'en'
                ? 'There was an error, please try again.'
                : 'حدث خطأ ما, الرجاء اعادة المحاولة.'));
      }
    } catch (error) {
      if (error is DioException) {
        emit(
          ContactUsErrorState(
            error: exceptionsHandle(error: error),
          ),
        );
      } else {
        ContactUsErrorState(error: error.toString());
      }
    }
  }

  void productComplaiment(int id, String text) async {
    emit(ContactUsLoadingState());
    try {
      await Network.postData(
          url: Urls.productComplaiment,
          data: {"product_id": id, "complaint_text": text}).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          emit(ContactUsSuccessfulState(msg: value.data["msg"]));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          ContactUsErrorState(
            error: exceptionsHandle(error: error),
          ),
        );
      } else {
        ContactUsErrorState(error: error.toString());
      }
    }
  }

//status = 0 employee
//status = 1 public
  void employeeComplaiment(
      String causeProblem, String employeeName, int status) async {
    emit(ContactUsLoadingState());
    try {
      await Network.postData(url: Urls.employeeComplaiment, data: {
        "cause_problem": causeProblem,
        "employee_name": employeeName,
        "status": status,
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          emit(ContactUsSuccessfulState(msg: value.data["msg"]));
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          ContactUsErrorState(
            error: exceptionsHandle(error: error),
          ),
        );
      } else {
        ContactUsErrorState(error: error.toString());
      }
    }
  }
}
