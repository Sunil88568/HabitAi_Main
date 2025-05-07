const String baseUrl = 'http://85.31.234.205:5414';



class _UrlsCollections{
  static const String api = '$baseUrl';
  static const String user = '/users';
}


class Urls{
  static const api = _UrlsCollections.api;


  /////////////////////////////  Auth     //////////////////////////////////
  static const login = '${_UrlsCollections.user}/login';
  static const uploadPhoto = '${_UrlsCollections.user}/upload-file';
  static const register = '${_UrlsCollections.user}/register';
  static const checkEmailAndMobile = '${_UrlsCollections.user}/check-email-mobile-exist';
  static const forgotPassword = '${_UrlsCollections.user}/forgot-password';
  static const getUserProfile = '${_UrlsCollections.user}/profile';
  static const logOut = '${_UrlsCollections.user}/logout';
  static const changePassword = '${_UrlsCollections.user}/change-password';
  static const editProfile = '${_UrlsCollections.user}/edit-profile';
  static const contactUs = '/contact-us';



/////////////////////////////  Questions     //////////////////////////////////


  static const getQuestions = '/questions';
  static const submitQuestions = '/user-question-answer';
}

