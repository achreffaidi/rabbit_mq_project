// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

class UserList {
  List<UserListElement> userList;

  UserList({
    this.userList,
  });

  factory UserList.fromJson(String str) => UserList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserList.fromMap(Map<String, dynamic> json) => UserList(
    userList: json["userList"] == null ? null : List<UserListElement>.from(json["userList"].map((x) => UserListElement.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "userList": userList == null ? null : List<dynamic>.from(userList.map((x) => x.toMap())),
  };
}

class UserListElement {
  String id;
  String name;
  String username;
  int v;

  UserListElement({
    this.id,
    this.name,
    this.username,
    this.v,
  });

  factory UserListElement.fromJson(String str) => UserListElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserListElement.fromMap(Map<String, dynamic> json) => UserListElement(
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    username: json["username"] == null ? null : json["username"],
    v: json["__v"] == null ? null : json["__v"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "username": username == null ? null : username,
    "__v": v == null ? null : v,
  };
}
