class ServicesUrl {
  // static const String baseUrl = "localhost:8080";
  static const String baseUrl = "http://10.0.2.2:8080";
  static const String postLogin = "$baseUrl/api/v1/auth/login";
  static const String postRegister = "$baseUrl/api/v1/auth/register";
  static const String listProduct = "$baseUrl/products/listProducts";
  static const String listProductSearch = "$baseUrl/products/listProductSearch";
  static const String addProduct = "$baseUrl/products/addProduct";
  static const String addCart = "$baseUrl/api/cart/add";
  static const String addAddress = "$baseUrl/api/addresses/add";
  static const String addOrder = "$baseUrl/api/orders/create";
  static const String getListOrder = "$baseUrl/api/orders/all";




}