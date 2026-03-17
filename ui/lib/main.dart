import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MaterialApp(home: JarvisHUD(), theme: ThemeData.dark()));

class JarvisHUD extends StatefulWidget {
  @override
  _JarvisHUDState createState() => _JarvisHUDState();
}

class _JarvisHUDState extends State<JarvisHUD> {
  WebSocketChannel? channel;
  String battery = "0.0";
  String gyro = "0.0";
  bool isConnected = false;

  // 1. REPLACE WITH YOUR PI'S IP
  final String piIp = "192.168.1.101";

  void toggleConnection() {
    if (isConnected) {
      channel?.sink.close();
      setState(() => isConnected = false);
    } else {
      try {
        channel = WebSocketChannel.connect(Uri.parse('ws://$piIp:9090'));

        // 2. Subscribe to the ROS2 Topic
        final subscribeMsg = {
          "op": "subscribe",
          "topic": "/robot_status",
          "type": "std_msgs/String",
        };
        channel!.sink.add(jsonEncode(subscribeMsg));

        // 3. Listen for incoming data
        channel!.stream.listen((message) {
          final decoded = jsonDecode(message);
          if (decoded['topic'] == '/robot_status') {
            final data = jsonDecode(decoded['msg']['data']);
            setState(() {
              battery = data['battery_voltage'].toString();
              gyro = data['gyro_pitch'].toString();
              isConnected = true;
            });
          }
        });
      } catch (e) {
        print("Connection Error: $e");
      }
    }
  }

  void sendCommand(String action) {
    if (!isConnected) return;
    final commandMsg = {
      "op": "publish",
      "topic": "/robot_command",
      "msg": {
        "data": jsonEncode({"action": action}),
      },
    };
    channel!.sink.add(jsonEncode(commandMsg));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "J.A.R.V.I.S. HUD",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 24,
                  letterSpacing: 2,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _statusTile("BATTERY", "$battery V", Colors.green),
                  _statusTile("GYRO", "$gyro°", Colors.orange),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => sendCommand("stand"),
                    child: Text("STAND"),
                  ),
                  IconButton(
                    icon: Icon(Icons.power_settings_new, size: 40),
                    color: isConnected ? Colors.cyan : Colors.red,
                    onPressed: toggleConnection,
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand("sit"),
                    child: Text("SIT"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusTile(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: color, fontSize: 12)),
            Text(
              value,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
