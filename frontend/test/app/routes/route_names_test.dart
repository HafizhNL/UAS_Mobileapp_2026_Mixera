import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/routes/route_names.dart';

void main() {
  test('RouteNames paths are unique', () {
    final routes = <String, String>{
      'splash': RouteNames.splash,
      'mainShell': RouteNames.mainShell,
      'authGate': RouteNames.authGate,
      'home': RouteNames.home,
      'login': RouteNames.login,
      'register': RouteNames.register,
      'otp': RouteNames.otp,
      'forgotPassword': RouteNames.forgotPassword,
      'resetPassword': RouteNames.resetPassword,
      'editProfile': RouteNames.editProfile,
      'profile': RouteNames.profile,
      'savedAddresses': RouteNames.savedAddresses,
      'addNewAddress': RouteNames.addNewAddress,
      'editAddress': RouteNames.editAddress,
      'changePassword': RouteNames.changePassword,
      'security': RouteNames.security,
      'notificationSettings': RouteNames.notificationSettings,
      'wallet': RouteNames.wallet,
      'addMoney': RouteNames.addMoney,
      'snapWebView': RouteNames.snapWebView,
      'shopSearch': RouteNames.shopSearch,
      'productDetail': RouteNames.productDetail,
      'cart': RouteNames.cart,
      'checkout': RouteNames.checkout,
      'purchaseComplete': RouteNames.purchaseComplete,
      'orders': RouteNames.orders,
      'orderDetail': RouteNames.orderDetail,
      'cardTokenize': RouteNames.cardTokenize,
      'card3DS': RouteNames.card3DS,
      'wardrobe': RouteNames.wardrobe,
      'sellerShell': RouteNames.sellerShell,
      'mixMatch': RouteNames.mixMatch,
      'wishlist': RouteNames.wishlist,
      'savedOutfits': RouteNames.savedOutfits,
      'savedTryOnPhotos': RouteNames.savedTryOnPhotos,
      'personPhotosTryOn': RouteNames.personPhotosTryOn,
    };

    expect(routes.values.toSet().length, routes.length);
    expect(routes.values.every((p) => p.startsWith('/')), isTrue);
  });

  test('root and auth entry routes', () {
    expect(RouteNames.splash, '/');
    expect(RouteNames.authGate, '/auth-gate');
    expect(RouteNames.mainShell, '/main-shell');
  });
}
