class WasteRequest {
  final String imagePath;
  final String description;

  WasteRequest({required this.imagePath, required this.description});
}

class WasteRequestStore {
  static List<WasteRequest> pendingRequests = [];
  static List<WasteRequest> acceptedRequests = [];
}
