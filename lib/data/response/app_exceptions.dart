
class AppExceptions implements Exception{
  final _massage;
  final _prefix;

  AppExceptions([this._massage, this._prefix]);
  String toString(){
    return '$_prefix$_massage';
  }
}

class InternetException extends AppExceptions {
  InternetException([String? massage]) : super(massage, 'No Internet');
}

class RequestTimeOut extends AppExceptions {
  RequestTimeOut([String? massage]) : super(massage, 'Request Time Out');
}

class ServerException extends AppExceptions {
  ServerException([String? massage]) : super(massage, 'internet server error');
}

class InvalidUrlException extends AppExceptions {
  InvalidUrlException([String? massage]) : super(massage, 'Invalid Url');
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? massage]) : super(massage, 'Error while communication');
}