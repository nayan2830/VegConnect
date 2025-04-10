import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'veg_request_screen.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> roles = ['Veg Vendor', 'Waste Handler', 'Veg Consumer'];
  String selectedRole = 'Veg Vendor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.deepPurple.shade100,
        foregroundColor: Colors.deepPurple.shade900,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Welcome to VegConnect",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text("Select your role"),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: selectedRole,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Widget nextScreen;

                    if (selectedRole == 'Veg Consumer') {
                      nextScreen = const VegRequestScreen();
                    } else {
                      final roleIndex = selectedRole == 'Veg Vendor'
                          ? UserRole.Vendor
                          : UserRole.Handler; // covers 'Waste Handler'

                      nextScreen = DashboardScreen(
                        user: AppUser(name: "User", role: roleIndex),
                      );
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => nextScreen),
                    );
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
