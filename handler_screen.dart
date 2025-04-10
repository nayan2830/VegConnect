import 'package:flutter/material.dart';
import '../models/waste_requests.dart';
import '../models/veg_requests.dart'; // ✅ Added to access consumer requests
import 'dart:io';

class HandlerScreen extends StatefulWidget {
  const HandlerScreen({super.key});

  @override
  State<HandlerScreen> createState() => _HandlerScreenState();
}

class _HandlerScreenState extends State<HandlerScreen> {
  void _acceptRequest(WasteRequest request) {
    setState(() {
      WasteRequestStore.pendingRequests.remove(request);
      WasteRequestStore.acceptedRequests.add(request);
    });
  }

  void _declineRequest(WasteRequest request) {
    setState(() {
      WasteRequestStore.pendingRequests.remove(request);
    });
  }

  void _resell(WasteRequest request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Marked for Resell: ${request.description}")),
    );
  }

  void _acceptConsumerRequest(VegRequest request) {
    setState(() {
      VegRequestStore.wasteRequests.remove(request);
      VegRequestStore.acceptedRequests ??= [];
      VegRequestStore.acceptedRequests.add(request);
    });
  }

  void _declineConsumerRequest(VegRequest request) {
    setState(() {
      VegRequestStore.wasteRequests.remove(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Pending Requests (from Vendors)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...WasteRequestStore.pendingRequests.map((request) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Image.file(File(request.imagePath),
                  height: 150, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(request.description),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () => _acceptRequest(request),
                      child: const Text("Accept")),
                  ElevatedButton(
                      onPressed: () => _declineRequest(request),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      child: const Text("Decline")),
                ],
              )
            ],
          ),
        )),

        // ✅ New Section: Requests from Consumers
        const SizedBox(height: 30),
        const Text(
          "Consumer Waste Vegetable Requests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...VegRequestStore.wasteRequests.map((request) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${request.name} (${request.quantity} kg)\nReason: ${request.reason}',
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _acceptConsumerRequest(request),
                    child: const Text("Accept"),
                  ),
                  ElevatedButton(
                    onPressed: () => _declineConsumerRequest(request),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    child: const Text("Decline"),
                  ),
                ],
              ),
            ],
          ),
        )),

        const SizedBox(height: 30),
        const Text(
          "Accepted Requests (from Vendors)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...WasteRequestStore.acceptedRequests.map((request) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Image.file(File(request.imagePath),
                  height: 150, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(request.description),
              ),
              ElevatedButton(
                onPressed: () => _resell(request),
                child: const Text("Resell"),
              )
            ],
          ),
        )),
      ],
    );
  }
}
