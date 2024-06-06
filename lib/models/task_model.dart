class Task {
  String? id;
  String? title;
  String? status;
  int? priority;
  String? priorityColorHex;
  DateTime? timestamp;
  String? description;

  Task({
    this.id,
    this.title,
    this.status,
    this.priority,
    this.priorityColorHex,
    this.timestamp,
    this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        priority: json["priority"],
        priorityColorHex: json["priority_color_hex"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "priority": priority,
        "priority_color_hex": priorityColorHex,
        "timestamp": timestamp?.toIso8601String(),
        "description": description,
      };
}
