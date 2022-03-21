// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/coustom_route_transation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './provider/auth_provider.dart';
import './provider/cart_provider.dart';
import './provider/order_provider.dart';
import './provider/product_provider.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/user_products_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await SharedPreferences.getInstance();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          // create: (context) => AuthProvider(),
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider?>(
          create: (context) => ProductProvider("", '', []),
          update: (context, auth, previousProducts) {
            return ProductProvider(
              auth.token.toString(),
              auth.userId.toString(),
              previousProducts == null ? [] : previousProducts.item,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider?>(
          create: (_) => null,
          update: (context, auth, previousOrders) {
            return OrderProvider(
              auth.token.toString(),
              auth.userId.toString(),
              previousOrders == null ? [] : previousOrders.orders,
            );
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Shop App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // primarySwatch: Colors.lightGreen,
            // accentColor: Colors.deepOrangeAccent,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.lightGreen,
              accentColor: Colors.deepOrangeAccent,
            ),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (context, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          // initialRoute: auth.isAuth
          //     ? ProductOverviewScreen.routeName
          //     : AuthScreen.routeName,
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            ProductOverviewScreen.routeName: (context) =>
                ProductOverviewScreen(),
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
