<<<<<<< HEAD
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
=======
// home.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rtdata/pantallas/GHume.dart';
import 'package:rtdata/pantallas/GTemp.dart';
>>>>>>> 84b620b (Inicializa el repositorio)

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

<<<<<<< HEAD
class _HomeState extends State<Home> {
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool BTstate = false;
  bool BTconected = false;
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? device;
  String contenido = "";

  @override
  void initState() {
    super.initState();
    permisos();
    estadoBT();
  }

  void permisos() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetooth.request();
    await Permission.location.request();
  }

  void estadoBT() {
    _bluetooth.state.then((value) {
      setState(() {
        BTstate = value.isEnabled;
      });
    });
    _bluetooth.onStateChanged().listen((event) {
      switch (event) {
        case BluetoothState.STATE_ON:
          BTstate = true;
          break;
        case BluetoothState.STATE_OFF:
          BTstate = false;
          break;
        default:
          break;
      }
      setState(() {});
    });
  }

  void encenderBT() async {
    await _bluetooth.requestEnable();
  }

  void apagarBT() async {
    await _bluetooth.requestDisable();
  }

  Widget switchBT() {
    return SwitchListTile(
        title: BTstate
            ? const Text('Bluetooth Encendido')
            : const Text('Bluetooth Apagado'),
        activeColor: BTstate ? Colors.purpleAccent : Colors.orangeAccent,
        tileColor: BTstate ? Colors.purple : Colors.orange,
        value: BTstate,
        onChanged: (bool value) {
          if (value) {
            encenderBT();
          } else {
            apagarBT();
          }
        },
        secondary: BTstate
            ? const Icon(Icons.bluetooth)
            : const Icon(Icons.bluetooth_disabled));
  }

  Widget indoDisp() {
    return ListTile(
      title: device == null ? Text("Sin Dispositivo") : Text("${device?.name}"),
      subtitle:
      device == null ? Text("Sin Dispositivo") : Text("${device?.address}"),
      trailing: BTconected
          ? IconButton(
          onPressed: () async {
            await connection?.finish();
            BTconected = false;
            devices = [];
            device = null;
            setState(() {});
          },
          icon: Icon(Icons.delivery_dining_sharp))
          : IconButton(
          onPressed: () {
            ListDisp();
          },
          icon: Icon(Icons.search_rounded)),
    );
  }

  void ListDisp() async {
    devices = await _bluetooth.getBondedDevices();
    setState(() {});
  }

  void recibirDatos() {
    connection?.input?.listen((event) {
      contenido += String.fromCharCodes(event);
      setState(() {});
    });
  }

  void conectarDispositivo(BluetoothDevice selectedDevice) async {
    connection = await BluetoothConnection.toAddress(selectedDevice.address);
    device = selectedDevice;
    BTconected = true;
    recibirDatos();
    setState(() {});
  }

  Widget lista() {
    if (BTconected) {
      return SingleChildScrollView(
        child: Text(
          contenido,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 10.0,
          ),
        ),
      );
    } else {
      return devices.isEmpty
          ? Text("No hay dispositivos")
          : ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("${devices[index].name}"),
            subtitle: Text("${devices[index].address}"),
            trailing: IconButton(
              icon: Icon(Icons.bluetooth_connected),
              onPressed: () => conectarDispositivo(devices[index]),
            ),
          );
        },
      );
    }
  }

  void enviarDatos(String msg) {
    if (connection!.isConnected) {
      connection?.output.add(ascii.encode('$msg\n'));
    }
  }

  Widget botonera() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
              child: const Icon(Icons.lightbulb),
              onPressed: () {
                enviarDatos("led_on");
              }),
          CupertinoButton(
              child: const Icon(Icons.lightbulb_outline),
              onPressed: () {
                enviarDatos("led_off");
              }),
          CupertinoButton(
              child: const Icon(Icons.waving_hand),
              onPressed: () {
                enviarDatos("hello");
              }),
        ]);
  }
=======
class _HomeState extends State<Home> with AfterLayoutMixin<Home> {
  double humidity = 0, temperature = 0;
  bool isLoading = false;
>>>>>>> 84b620b (Inicializa el repositorio)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text("Flutter Bluetooth"),
      ),
      body: Column(
        children: <Widget>[
          switchBT(),
          const Divider(
            height: 5,
          ),
          indoDisp(),
          const Divider(
            height: 5,
          ),
          Expanded(child: lista()),
          const Divider(
            height: 5,
          ),
          botonera()
=======
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
>>>>>>> 84b620b (Inicializa el repositorio)
        ],
      ),
    );
  }
<<<<<<< HEAD
=======

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
>>>>>>> 84b620b (Inicializa el repositorio)
}
