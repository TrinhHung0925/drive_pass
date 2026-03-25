import 'package:get/get.dart';
import 'local_service.dart';

class ApiService extends GetConnect implements GetxService {
  late LocalService _localService;

  Future<ApiService> init() async {
    _localService = Get.find<LocalService>();
    
    // Base URL configuration
    httpClient.baseUrl = 'https://api.yourbackend.com/v1';
    httpClient.timeout = const Duration(seconds: 30);

    // Request Interceptor: Attach Token automatically if exists
    httpClient.addRequestModifier<dynamic>((request) {
      if (_localService.hasToken) {
        request.headers['Authorization'] = 'Bearer ${_localService.token}';
      }
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // Response Interceptor: Global Error & Auth Handling
    httpClient.addResponseModifier((request, response) {
      if (response.status.code == 401) {
        // Auto-logout when token expires
        _localService.removeToken();
        Get.offAllNamed('/login'); // We handle this route later if needed
      }
      return response;
    });

    return this;
  }
}
