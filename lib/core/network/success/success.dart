class Success {
  String? message;

  Success({
    this.message,
  });
  Success.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
