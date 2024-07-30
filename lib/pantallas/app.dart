import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/cupertino.dart';

import 'home.dart';
=======
import 'home.dart';

>>>>>>> 84b620b (Inicializa el repositorio)
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return  MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blueAccent,
      ),


=======
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.purple),
      home: Home(),
>>>>>>> 84b620b (Inicializa el repositorio)
    );
  }
}
