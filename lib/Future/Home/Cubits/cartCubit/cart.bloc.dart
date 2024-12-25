import 'package:dio/dio.dart';
import 'package:zein_store/Apis/Network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zein_store/Future/Home/models/product_model.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Urls.dart';

part 'cart.state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(EmptyCartState());
  List<MainProduct> pcw = <MainProduct>[];

  void addToCart({
    required MainProduct p,
    required String screen,
    bool size = false,
  }) async {
    if (pcw.any((element) => size
        ? (element.id == p.id && element.selectedSize == p.selectedSize)
        : element.id == p.id)) {
      switch (screen) {
        case "home":
          emit(AlreadyInCartFromHomeState());
          break;
        case "product":
          emit(AlreadyInCartState());
          break;
        case "fav":
          emit(AlreadyInCartFromFavState());
          break;
        case "cat":
          emit(AlreadyInCartFromHomeState());
          break;
        case "search":
          emit(AlreadyInCartFromSearchState());
          break;
        default:
          emit(AlreadyInCartState());
      }
    } else {
      try {
        await Network.postData(url: Urls.addToCart, data: {
          "id": p.id,
          "quantity": p.userQuantity,
          "size": p.selectedSize
        }).then((value) {
          if (value.statusCode == 200 || value.statusCode == 201) {
            if (value.data["status"]) {
              switch (screen) {
                case "home":
                  emit(AddedTocartFromHomeScreen());
                  break;
                case "product":
                  emit(AddToCartState());
                  break;
                case "fav":
                  emit(AddToCartFromFavState());
                  break;
                case "cat":
                  emit(AddedTocartFromHomeScreen());
                  break;
                case "search":
                  emit(AddToCartFromSearchState());
                  break;
                default:
                  emit(AddToCartState());
              }
              refreshCartOnLanguageChange();
            } else {
              emit(CartErrorState(errorMessage: value.data["msg"]));
            }
          }
        });
      } catch (error) {
        if (error is DioException) {
          emit(
            CartErrorState(
              errorMessage: exceptionsHandle(error: error),
            ),
          );
        } else {
          emit(CartErrorState(errorMessage: error.toString()));
        }
      }
    }
  }

  Future<void> refreshCartOnLanguageChange() async {
    emit(CartLoadingState());
    try {
      await Network.getData(url: Urls.getCart).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          if (value.data["status"]) {
            pcw.clear();
            for (var data in value.data["data"]) {
              MainProduct p = MainProduct.fromJson(data["product"]);
              p.userQuantity = data["quantity"];
              p.selectedSize = data["size"];
              pcw.add(p);
            }
            emit(GetCartSuccessfulState());
          } else {
            emit(CartErrorState(errorMessage: value.data["msg"]));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          CartErrorState(
            errorMessage: exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(CartErrorState(errorMessage: error.toString()));
      }
    }
  }

  void increaseQuantity(MainProduct product) async {
    product.userQuantity++;
    try {
      await Network.postData(url: Urls.updateCart, data: {
        "id": product.id,
        "quantity": product.userQuantity,
        "size": product.selectedSize
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          if (value.data["status"]) {
            emit(AddToCartState());
          } else {
            product.userQuantity--;
            emit(CartErrorState(errorMessage: value.data["msg"]));
          }
        }
      });
    } catch (error) {
      product.userQuantity--;
      if (error is DioException) {
        emit(
          CartErrorState(
            errorMessage: exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(CartErrorState(errorMessage: error.toString()));
      }
    }
  }

  void decreaseQuantity(MainProduct product) async {
    product.userQuantity--;
    try {
      await Network.postData(url: Urls.updateCart, data: {
        "id": product.id,
        "quantity": product.userQuantity,
        "size": product.selectedSize
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          if (value.data["status"]) {
            emit(AddToCartState());
          } else {
            product.userQuantity++;
            emit(CartErrorState(errorMessage: value.data["msg"]));
          }
        }
      });
    } catch (error) {
      product.userQuantity++;
      if (error is DioException) {
        emit(
          CartErrorState(
            errorMessage: exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(CartErrorState(errorMessage: error.toString()));
      }
    }
  }

  void removeformTheCart(MainProduct p) async {
    try {
      await Network.postData(url: Urls.addToCart, data: {
        "id": p.id,
        "quantity": p.userQuantity,
        "size": p.selectedSize
      }).then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          if (value.data["status"]) {
            refreshCartOnLanguageChange();
          } else {
            emit(CartErrorState(errorMessage: value.data["msg"]));
          }
        }
      });
    } catch (error) {
      if (error is DioException) {
        emit(
          CartErrorState(
            errorMessage: exceptionsHandle(error: error),
          ),
        );
      } else {
        emit(CartErrorState(errorMessage: error.toString()));
      }
    }
  }
}
