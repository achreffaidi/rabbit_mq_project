import 'dart:convert';

class MyMessage {
  String text;
  String name;
  String sender;
  int change;

  MyMessage({
    this.text,
    this.name,
    this.sender,
    this.change,
  });

  factory MyMessage.fromJson(String str) => MyMessage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyMessage.fromMap(Map<String, dynamic> json) => MyMessage(
    text: json["text"] == null ? null : json["text"],
    name: json["name"] == null ? null : json["name"],
    sender: json["sender"] == null ? null : json["sender"],
    change: json["change"] == null ? null : json["change"],
  );

  Map<String, dynamic> toMap() => {
    "text": text == null ? null : text,
    "name": name == null ? null : name,
    "sender": sender == null ? null : sender,
    "change": change == null ? null : change,
  };
}
