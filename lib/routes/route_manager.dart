import 'package:flutter/material.dart';
import 'package:interior_design/auth/login/login_form.dart';
import 'package:interior_design/auth/register/register.dart';
import 'package:interior_design/screens/splash/splash_screen.dart';
import 'package:interior_design/screens/user_uploads/user_uploads_screen.dart';
import 'package:interior_design/wrapper/auth_wrapper.dart';

import '../arguments/image_preview_args.dart';
import '../arguments/item_preview_args.dart';
import '../arguments/save_image_args.dart';
import '../screens/save_image/save_image_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/image_preview/image_preview_screen.dart';
import '../screens/item_preview/preview_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String wrapper = '/wrapper';
  static const String home = '/home';
  static const String upload = '/upload';
  static const String imagePreview = '/imagePreview';
  static const String itemPreview = '/itemPreview';
  static const String saveImage = '/saveImage';
  // static const String display = '/displayPicture';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        case login:
        return MaterialPageRoute(builder: (_) => const LoginForm());
        case register:
        return MaterialPageRoute(builder: (_) => const SignUpForm());
      case wrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case upload:
        return MaterialPageRoute(builder: (_) => const UserUploadsScreen());
      case imagePreview:
        final args = settings.arguments as ImagePreviewArguments;
        return MaterialPageRoute(
          builder: (_) => ImagePreviewPage(open: args.open),
        );
        case itemPreview:
        final args = settings.arguments as ItemPreviewArgs;
        return MaterialPageRoute(
          builder: (_) => PreviewScreen(name: args.name, itemImages: args.itemImages),
        );
        case saveImage:
        final args = settings.arguments as SaveImageArguments;
        return MaterialPageRoute(
          builder: (_) => SaveImagePage(imagePath: args.imagePath, uploadedImage: args.uploadedImage),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
