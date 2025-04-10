import 'package:flutter/material.dart';
import '../models/veg_requests.dart'; // <--- already added

class VegRequestScreen extends StatefulWidget {
  const VegRequestScreen({super.key});

  @override
  State<VegRequestScreen> createState() => _VegRequestScreenState();
}

class _VegRequestScreenState extends State<VegRequestScreen> {
  String requestType = 'Fresh Vegetables';
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController vegNameController = TextEditingController();
  String? selectedReason;

  final List<String> reasons = [
    'Organic Fertilizer / Composting',
    'Biogas Production',
    'Bioethanol / Biofuel Production',
    'Mushroom Cultivation Substrate',
    'Animal Feed',
    'Natural Dye or Cosmetic Ingredients',
    'Enzyme and Detergent Production',
    'Upcycled Food Products',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Vegetables'),
        backgroundColor: Colors.deepPurple.shade100,
        foregroundColor: Colors.deepPurple.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Request Type',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: requestType,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                  items: const [
                    DropdownMenuItem(
                        value: 'Fresh Vegetables', child: Text('Fresh Vegetables')),
                    DropdownMenuItem(
                        value: 'Waste Vegetables', child: Text('Waste Vegetables')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      requestType = value!;
                      selectedReason = null;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: vegNameController,
                  decoration: const InputDecoration(
                    labelText: 'Vegetable Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity (in kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                if (requestType == 'Waste Vegetables')
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Reason',
                      border: OutlineInputBorder(),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    value: selectedReason,
                    items: reasons.map((reason) {
                      return DropdownMenuItem(
                        value: reason,
                        child: Text(reason),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final name = vegNameController.text.trim();
                    final quantity = quantityController.text.trim();
                    final reason = selectedReason;

                    if (name.isEmpty || quantity.isEmpty || (requestType == 'Waste Vegetables' && reason == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all required fields."),
                        ),
                      );
                      return;
                    }

                    final newRequest = VegRequest(
                      name: name,
                      quantity: quantity,
                      reason: reason,
                      isWaste: requestType == 'Waste Vegetables',
                    );

                    if (newRequest.isWaste) {
                      VegRequestStore.wasteRequests.add(newRequest);
                    } else {
                      VegRequestStore.freshRequests.add(newRequest);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          requestType == 'Fresh Vegetables'
                              ? 'Requested $quantity kg of $name (Fresh)'
                              : 'Requested $quantity kg of $name (Waste) for "$reason"',
                        ),
                      ),
                    );

                    // Clear fields
                    vegNameController.clear();
                    quantityController.clear();
                    setState(() {
                      selectedReason = null;
                      requestType = 'Fresh Vegetables';
                    });
                  },
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
