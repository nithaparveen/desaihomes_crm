import 'dart:convert';
import 'dart:developer';
import 'package:desaihomes_crm_application/presentations/new_whatsapp_screen/controller/new_whatsapp_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  Function(dynamic)? onMessageReceived;
  String? currentId;
  bool isInitialized = false;
  bool isSubscribed = false;

  Future<void> initializePusher() async {
    if (isInitialized) return;

    try {
      await pusher.init(
        apiKey: "e9821283ae4e0a5b1271",
        cluster: "ap2",
      );

      await pusher.connect();
      isInitialized = true;

      log("Pusher initialized and connected");
    } catch (e) {
      log("Error initializing Pusher: $e");
    }
  }

  Future<void> subscribeToChannelWithId(String id, Function(dynamic) callback, BuildContext context) async {
    if (!isInitialized) {
      await initializePusher();
    }
    
    // If already subscribed, unsubscribe first
    if (isSubscribed) {
      await unsubscribe();
    }

    currentId = id;
    onMessageReceived = callback;

    try {
      await pusher.subscribe(
        channelName: "desai-channel",
        onEvent: (dynamic event) {
          log("Received Event: ${event.data}");

          if (event.data != null) {
            final Map<String, dynamic> data = jsonDecode(event.data);
            
            // If id is "all", process all messages
            // Otherwise, only process messages for the specific lead
            if (id == "all" || (data.containsKey('lead_id') && data['lead_id'].toString() == id)) {
              onMessageReceived?.call(data);
              
              // Only fetch chats for the specific lead (skip if we're listening to "all")
              if (id != "all" && context.mounted) {
                Provider.of<WhatsappControllerCopy>(context, listen: false)
                    .fetchChats(id, context);
              }
            }
          }
        },
      );
      isSubscribed = true;
      log("Subscribed to desai-channel for ID: $id");
    } catch (e) {
      log("Error subscribing to channel: $e");
    }
  }

  Future<void> unsubscribe() async {
    try {
      if (isSubscribed) {
        await pusher.unsubscribe(channelName: "desai-channel");
        isSubscribed = false;
        log("Unsubscribed from desai-channel");
      }
    } catch (e) {
      log("Error unsubscribing: $e");
    }
  }

  Future<void> disconnectPusher() async {
    try {
      await unsubscribe();
      await pusher.disconnect();
      isInitialized = false;
      log("Disconnected from Pusher");
    } catch (e) {
      log("Error disconnecting Pusher: $e");
    }
  }
}