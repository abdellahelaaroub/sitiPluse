import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager with ChangeNotifier {
  dynamic payload = "00";
  MqttServerClient client = MqttServerClient.withPort('144.91.113.92', 'flutter_client', 1883);
  void initialize() async{
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

  }


  final connMess = MqttConnectMessage()
      .withClientIdentifier("siti")
      .authenticateAs("siti", "siti@2021")
      .keepAliveFor(21600)
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  void connect() async {
    client.connectionMessage = connMess;
    try {
      await client.connect();
      print('connected :)');
    } catch (e) {
      print('Exception: $e');
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('Client connected.*************************************.');
      onSubscribed("F01/R01/M01/flow");
      client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload;
        payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        updateState();
        print("===================>  in mqtt manager  :      $payload");

      });

    } else {
      print(
          'Connection failed - disconnecting, status is ${client.connectionStatus}');
      //client.disconnect();

    }
  }

  void onSubscribed(String topic) {
    client.unsubscribe(topic);
  }
  void onConnected(){
    client.onConnected();
    onSubscribed("F01/R01/M01/flow");
    updateState();
  }
  void updateState() {
    notifyListeners();
  }
}