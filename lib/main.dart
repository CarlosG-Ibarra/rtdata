<<<<<<< HEAD
import 'package:btserial/pantallas/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

=======
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:rtdata/pantallas/app.dart';
import 'firebase_options.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    statusBarIconBrightness: Brightness.dark, // color icons
  ));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
>>>>>>> 84b620b (Inicializa el repositorio)
