const String baseUrl = 'http://85.31.234.205:5414';



class _UrlsCollections{
  static const String api = '$baseUrl';
  static const String user = '/users';
}


class Urls{
  static const api = _UrlsCollections.api;
  static const login = '${_UrlsCollections.user}/login';
  static const uploadPhoto = '${_UrlsCollections.user}/upload-file';
  static const register = '${_UrlsCollections.user}/register';
  static const checkEmailAndMobile = '${_UrlsCollections.user}/check-email-mobile-exist';




  static const verifyUser = '${api}/forgot-password';
  static const verifyOtp = '${api}/forgot-password';
  static const changePassword = '${api}/forgot-password';
  static const profileChangePassword = '${api}/password';

}

