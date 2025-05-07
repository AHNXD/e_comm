// ignore_for_file: file_names

class Urls {
  // static const String ip = "192.168.43.3:8000";
  // static const String ip = "192.168.1.12:8000";
  // static const String ip = "192.168.1.129:8000";
  // static const String ip = "192.168.7.120:8000";
  static const String ip = "abdalzein.tawwasyshop.store";

  // static const String baseUrl = "http://$ip/api/";
  // static const String storageProducts = "http://$ip/uploads/products/";
  // static const String storageCategories = "http://$ip/uploads/categories/";
  static const String baseUrl = "https://$ip/api/";
  static const String storageProducts = "https://$ip/uploads/products/";
  static const String storageCategories = "https://$ip/uploads/categories/";
  static const String logInApi = "${baseUrl}login";
  static const String registerApi = "${baseUrl}register";
  static const String verificationCode = "${baseUrl}verify_email";
  static const String forgetPassword = "${baseUrl}forget-password";
  static const String resetPassword = "${baseUrl}reset-password";
  static const String getCatigories = "${baseUrl}categories";
  static const String getProducts = "${baseUrl}products";
  static const String getabout = "${baseUrl}about";
  static const String getLastestProducts = "${baseUrl}latest/products";
  static const String getOffersProducts = "${baseUrl}products/offers";
  static const String getOffersCatigories = "${baseUrl}categories/offers";
  static const String ordersNumbers = "${baseUrl}orders/numbers";
  static const String filterProducts = "${baseUrl}filter_products";
  static const String storeOrder = "${baseUrl}product/order";
  static const String cancelOrder = "${baseUrl}cancelOrder/2";
  static const String comment = "${baseUrl}comment";
  static const String getProductsFavorite = "${baseUrl}get/fav";
  static const String addAndDelProductsFavorite = "${baseUrl}store/fav";
  static const String review = "${baseUrl}review";
  static const String employeeComplaiment =
      "${baseUrl}api/public/employee/complaiment";
  static const String productComplaiment = "${baseUrl}product/complaiment";
  static const String contactUs = "${baseUrl}store/contact";
  static const String logout = "${baseUrl}logout";
  static const String minMax = "${baseUrl}min_max";
  static const String getMyOrders = "${baseUrl}my_orders";
  static const String changePassword = "${baseUrl}change-password";
  static const String getProduct = "${baseUrl}product";
  static const String getProductsByGategoryId =
      "${baseUrl}products/by/categoryId";
  static const String sellProduct = "${baseUrl}Sell_Order";
  static const String printImage = "${baseUrl}Print";
  static const String maintenance = "${baseUrl}Maintenance";
  static const String getPrintSizes = "${baseUrl}PrintSizes";
  static const String getLinks = "${baseUrl}links";
  static const String getMinMax = "${baseUrl}min_max";
  static const String checkToken = "${baseUrl}check-token";
  static const String getUser = "${baseUrl}get/profile";
  static const String editProfile = "${baseUrl}update/profile";
  static const String deleteProfile = "${baseUrl}delete/profile";
  static const String updateCart = "${baseUrl}update/cart";
  static const String getCart = "${baseUrl}get/cart";
  static const String addToCart = "${baseUrl}store/cart";
  static const String orderProduct = "${baseUrl}custom-orders";
}
