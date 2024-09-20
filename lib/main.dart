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



// import 'dart:ui';
//
// import 'package:flutter/material.dart';
//
// import 'examples/adapter_view.dart';
// import 'examples/everything_view.dart';
// import 'examples/info_view.dart';
// import 'examples/playground_view.dart';
// import 'examples/visual_view.dart';
//
// void main() {
//   runApp(const MyApp());
//   _loadShader(); // this is a touch hacky, but works for now.
// }
//
// Future<void> _loadShader() async {
//   return FragmentProgram.fromAsset('assets/shaders/shader.frag').then(
//           (FragmentProgram prgm) {
//         EverythingView.shader = prgm.fragmentShader();
//       }, onError: (Object error, StackTrace stackTrace) {
//     FlutterError.reportError(
//         FlutterErrorDetails(exception: error, stack: stackTrace));
//   });
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Animate Demo',
//       debugShowCheckedModeBanner: false,
//       home: FlutterAnimateExample(),
//     );
//   }
// }
//
// // this is a very quick and dirty example.
