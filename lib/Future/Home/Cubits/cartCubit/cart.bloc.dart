import 'package:dio/dio.dart';
import 'package:e_comm/Apis/Network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:meta/meta.dart';

import '../../../../Apis/ExceptionsHandle.dart';
import '../../../../Apis/Urls.dart';

part 'cart.state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(EmptyCartState());
  List<MainProduct> pcw = <MainProduct>[];
  void addToCart(MainProduct p, bool isHomeScreen, String screen) {
    if (pcw.any((element) => element.id == p.id)) {
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
      pcw.add(p);
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
    }
  }

  void addToCartWithSize(MainProduct p, String size) {
    bool productWithSameSize = false;
    for (var product in pcw) {
      if (product.id == p.id && product.selectedSize == size) {
        productWithSameSize = true;
        emit(AlreadyInCartState());
        break;
      }
    }
    if (!productWithSameSize) {
      MainProduct newProduct = MainProduct(
          id: p.id,
          name: p.name,
          categoryId: p.categoryId,
          descrption: p.descrption,
          files: p.files,
          sellingPrice: p.sellingPrice,
          sizes: p.sizes,
          selectedSize: size,
          isOffer: p.isOffer,
          offers: p.offers);

      pcw.add(newProduct);
      emit(AddToCartState());
    }
  }

  Future<void> refreshCartOnLanguageChange() async {
    emit(CartLoadingState());
    try {
      List<int> productIds = pcw.map((product) => product.id!).toList();
      List<int> quantities =
          pcw.map((product) => product.userQuantity).toList();
      List<String?> selectedSizs =
          pcw.map((product) => product.selectedSize).toList();
      List<MainProduct> updatedProducts = await Future.wait(
        productIds.map((id) => getProductById(id)).toList(),
      );

      for (int i = 0; i < updatedProducts.length; i++) {
        updatedProducts[i].userQuantity = quantities[i];
        updatedProducts[i].selectedSize = selectedSizs[i];
      }
      pcw = updatedProducts;

      emit(CartRefreshState(loadedporduct: updatedProducts));
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

  Future<MainProduct> getProductById(int id) async {
    final response =
        await Network.getData(url: "${Urls.getProduct}/${id.toString()}");
    return MainProduct.fromJson(response.data['data']);
  }

  void increaseQuantity(MainProduct product) {
    product.userQuantity++;
    emit(AddToCartState());
  }

  void decreaseQuantity(MainProduct product) {
    product.userQuantity--;
    emit(AddToCartState());
  }

  void removeformTheCart(MainProduct p) {
    pcw.remove(p);
    emit(RemvoeFromCartState(porducts: pcw));
  }
}
