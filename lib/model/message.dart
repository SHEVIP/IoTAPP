class Message {
  final int messageId;
  final int machineId;
  bool isRead;
  final String sentDate;
  final String title;
  final String content;
  final String type;

  Message({
    required this.messageId,
    required this.machineId,
    required this.isRead,
    required this.sentDate,
    required this.title,
    required this.content,
    required this.type,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'],
      machineId: json['machine_id'],
      isRead: json['is_read'],
      sentDate: json['sent_date'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
    );
  }
}