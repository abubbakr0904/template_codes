class NetworkResponse {
  String errorText;
  String errorCode;
  dynamic data;

  NetworkResponse({
    this.errorText = "",
    this.errorCode = "",
    this.data,
  });
}