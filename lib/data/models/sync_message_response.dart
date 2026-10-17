class SyncMessageResponse {
  int? receivedCount;
  int? failedCount;
  String? message;

  SyncMessageResponse({this.receivedCount, this.failedCount, this.message});
}
