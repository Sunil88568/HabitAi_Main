const String baseUrl = 'https://owc.hostg.in:6060/backend';



class _UrlsCollections{
  static const String api = '$baseUrl/api';
  static const String v1 = '/mobile/v1';
  static const String auth = '$v1/auth';
  static const String adminProfile = '$v1/admin/profile';
  static const String authAdmin = '$v1/auth/admin';
}


class Urls{
  static const api = _UrlsCollections.api;
  static const login = '${_UrlsCollections.authAdmin}/login';
  static const verifyUser = '${_UrlsCollections.auth}/forgot-password';
  static const verifyOtp = '${_UrlsCollections.auth}/forgot-password';
  static const changePassword = '${_UrlsCollections.auth}/forgot-password';
  static const profileChangePassword = '${_UrlsCollections.adminProfile}/password';
}

