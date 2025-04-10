enum UserRole { Vendor, Handler, VegConsumer }

class AppUser {
  final String name;
  final UserRole role;

  AppUser({required this.name, required this.role});
}
