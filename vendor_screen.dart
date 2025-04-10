import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/waste_requests.dart';
import '../models/veg_requests.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _handleUpload(String type) {
    final desc = _descriptionController.text.trim();
    if (_image != null && desc.isNotEmpty) {
      if (type == "Waste") {
        WasteRequestStore.pendingRequests.add(
          WasteRequest(imagePath: _image!.path, description: desc),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Marked as $type")),
      );
      setState(() {
        _descriptionController.clear();
        _image = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add image and description")),
      );
    }
  }

  void _acceptConsumerRequest(VegRequest request) {
    setState(() {
      VegRequestStore.freshRequests.remove(request);
      VegRequestStore.acceptedFreshRequests ??= [];
      VegRequestStore.acceptedFreshRequests.add(request);
    });
  }

  void _declineConsumerRequest(VegRequest request) {
    setState(() {
      VegRequestStore.freshRequests.remove(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text("Add Vegetable Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _image == null
                          ? const Center(child: Text("Tap to add image"))
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Vegetable Description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _handleUpload("Fresh"),
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Mark Fresh"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _handleUpload("Waste"),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Mark Waste"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
          const Text(
            "Consumer Fresh Vegetable Requests",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...VegRequestStore.freshRequests.map((request) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${request.name} (${request.quantity} kg)',
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
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Decline"),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
