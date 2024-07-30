// home.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rtdata/pantallas/GHume.dart';
import 'package:rtdata/pantallas/GTemp.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin<Home> {
  double humidity = 0, temperature = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gauge"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: GTemp(temperature: temperature)),
              const Divider(height: 5),
              Expanded(child: GHume(humidity: humidity)),
              const Divider(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Temperatura: $temperature"),
                  Text("Humedad: $humidity"),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  _getTemperatureMessage(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getTemperatureColor(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  _getHumidityMessage(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getHumidityColor(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (isLoading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Cargando datos...',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getTemperatureMessage() {
    if (temperature < 0) {
      return 'Hace frío';
    } else if (temperature <= 30) {
      return 'Temperatura agradable';
    } else {
      return 'Temperatura muy alta';
    }
  }

  Color _getTemperatureColor() {
    if (temperature < 0) {
      return Colors.blue;
    } else if (temperature <= 30) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  String _getHumidityMessage() {
    if (humidity < 0) {
      return 'Tiempo seco';
    } else if (humidity < 50) {
      return 'Humedad media';
    } else {
      return 'Humedad alta';
    }
  }

  Color _getHumidityColor() {
    if (humidity < 0) {
      return Colors.brown;
    } else if (humidity < 50) {
      return Colors.yellow;
    } else {
      return Colors.purple;
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    Timer.periodic(
      const Duration(seconds: 30),
          (timer) async {
        await _refreshData();
      },
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final ref = FirebaseDatabase.instance.ref();
    final temp = await ref.child("Living Room/temperature/value").get();
    final humi = await ref.child("Living Room/humidity/value").get();
    if (temp.exists && humi.exists) {
      setState(() {
        temperature = double.parse(temp.value.toString());
        humidity = double.parse(humi.value.toString());
      });
    } else {
      setState(() {
        temperature = -1;
        humidity = -1;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
