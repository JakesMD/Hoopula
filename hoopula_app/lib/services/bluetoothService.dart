import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

/// The service that controls the bluetooth connection and state.
class BluetoothService extends ChangeNotifier {
  BluetoothConnection connection;
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Returns true is the bluetooth is connected.
  bool get isConnected => connection != null && connection.isConnected;

  BluetoothService() {
    // Start connecting when this is initialized.
    restart();
  }

  /// Called when a new message is received.
  Function(String) onData = (data) {};

  /// Connects to Hoopula ESP32 and listens for incomming messages.
  Future<bool> restart() async {
    notifyListeners();
    if (await connect()) {
      if (startListener()) {
        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  /// Connects to the Hoopula ESP32
  Future<bool> connect() async {
    final String name = "Hoopula";
    String address;

    // Looks for "Hoopula" in paired devices and gets its address.
    try {
      print("Getting the device address from name $name...");
      final List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      address = devices.firstWhere((d) => d.name == name).address;
      print("Successfully got the device address.");
    } catch (e) {
      print("Failed to get the device address with error: " + e.toString());
    }

    if (address != null) {
      // Repeat until connected
      while (
          (connection == null || !connection.isConnected) && address != null) {
        try {
          print("Connecting to the device $address...");
          connection = await BluetoothConnection.toAddress(address)
              .timeout(Duration(seconds: 30));
        } catch (e) {
          print("Failed to connect to the device with error: " + e.toString());
        }
      }
      print("Successfully connected to the device.");
      return true;
    }
    return false;
  }

  /// Starts listener that listens to incomming messages.
  bool startListener() {
    try {
      connection.input.listen((Uint8List data) {
        final String decodedMessage = ascii.decode(data);
        print('Incoming data: $data - $decodedMessage');
        onData(decodedMessage);
      }).onDone(() {
        print('Disconnected by remote request');
        restart();
      });
      return true;
    } catch (e) {
      print("Failed to start the listener with error: " + e.toString());
      return false;
    }
  }

  /// Closes the bluetooth connection.
  void close() {
    try {
      connection.close();
      connection.dispose();
    } catch (e) {
      print("Failed to close the connection with error: " + toString());
    }
    notifyListeners();
  }
}
