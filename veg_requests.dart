class VegRequest {
  final String name;
  final String quantity;
  final String? reason;
  final bool isWaste;

  VegRequest({
    required this.name,
    required this.quantity,
    this.reason,
    required this.isWaste,
  });
}

class VegRequestStore {
  static List<VegRequest> freshRequests = [];
  static List<VegRequest> wasteRequests = [];

  static List<VegRequest> acceptedRequests = [];
  static List<VegRequest> acceptedFreshRequests = [];
}
