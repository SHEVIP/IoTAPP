class Order {
  final int id;
  final String order_date;
  final String order_number;
  final String order_type;
  final int item_number;
  final String item_type;
  final int quantity_number;
  final String delivery_date;
  final bool warning;
  final bool over_due;
  final bool order_status;
  final int time_used;
  final String procedure_name;
  final int sequence;
  final int line_id;
  final int done_num;

  Order({
    required this.id,
    required this.order_date,
    required this.order_number,
    required this.order_type,
    required this.item_number,
    required this.item_type,
    required this.quantity_number,
    required this.delivery_date,
    required this.warning,
    required this.over_due,
    required this.order_status,
    required this.time_used,
    required this.procedure_name,
    required this.sequence,
    required this.line_id,
    required this.done_num,
  });

  // 工厂构造函数，用于从 JSON 创建 Order 实例
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      order_date: json['order_date'],
      order_number: json['order_number'],
      order_type: json['order_type'],
      item_number: int.parse(json['item_number']),
      item_type: json['item_type'],
      quantity_number: int.parse(json['quantity_number']),
      delivery_date: json['delivery_date'],
      warning: json['warning'],
      over_due: json['over_due'],
      order_status: json['order_status'],
      time_used: json['time_used'],
      procedure_name: json['procedure_name'],
      sequence: json['sequence'],
      line_id: json['line_id'],
      done_num: json['done_num'],
    );
  }
}
