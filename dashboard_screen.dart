import 'package:flutter/material.dart';
import '../models/user.dart';
import 'vendor_screen.dart';
import 'handler_screen.dart';
import 'veg_request_screen.dart';

class DashboardScreen extends StatelessWidget {
  final AppUser user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Widget screen;

    switch (user.role) {
      case UserRole.Vendor:
        screen = const VendorScreen();
        break;
      case UserRole.Handler:
        screen = const HandlerScreen();
        break;
      case UserRole.VegConsumer:
        screen = const VegRequestScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard - ${user.role.name}"),
        backgroundColor: Colors.deepPurple.shade100,
        foregroundColor: Colors.deepPurple.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: screen,
      ),
    );
  }
}
