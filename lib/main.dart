import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interior_design/routes/route_manager.dart';
import 'package:interior_design/screens/home/home_screen.dart';
import 'package:interior_design/screens/splash/splash_screen.dart';
import 'package:interior_design/screens/user_uploads/user_uploads_screen.dart';
import 'package:interior_design/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

import 'navigator/navigator_services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // routes: Routes.generateRoute(settings),
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigator.navigationKey,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.splash,
    ));
  }
}

