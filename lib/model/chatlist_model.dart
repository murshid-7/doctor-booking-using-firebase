class ChatListModel {
  String? senderId;
  String? recieverId;
  String? chatRoomId;
  DateTime? timestamp;
  ChatListModel(
      {this.senderId, this.recieverId, this.chatRoomId, this.timestamp});

  factory ChatListModel.fromJson(json) {
    return ChatListModel(
      recieverId: json['recieverId'],
      senderId: json['senderId'],
      chatRoomId: json['chatRoomId'],
      timestamp:
          json['timestamp'] != null ? (json['timestamp']).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recieverId': recieverId,
      'senderId': senderId,
      'chatRoomId': chatRoomId,
      'timestamp': timestamp
    };
  }
}
