class UserModel {
    String? uid;
    String? name;
    String? keyName;
    String? email;
    String? creationTime;
    String? lastSignInTime;
    String? photoUrl;
    String? status;
    String? updatedTime;
    List<ChatUser>? chats;

    UserModel({
        this.uid,
        this.name,
        this.keyName,
        this.email,
        this.creationTime,
        this.lastSignInTime,
        this.photoUrl,
        this.status,
        this.updatedTime,
        this.chats,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        keyName: json["keyName"],
        email: json["email"],
        creationTime: json["creationTime"],
        lastSignInTime: json["lastSignInTime"],
        photoUrl: json["photoUrl"],
        status: json["status"],
        updatedTime: json["updatedTime"],
        chats: List<ChatUser>.from(json["chats"].map((x) => ChatUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "keyName": keyName,
        "email": email,
        "creationTime": creationTime,
        "lastSignInTime": lastSignInTime,
        "photoUrl": photoUrl,
        "status": status,
        "updatedTime": updatedTime,
        "chats": List<dynamic>.from(chats!.map((x) => x.toJson())),
    };
}

class ChatUser {
    String connection;
    String chatId;
    String lastTime;
    int totalUnread;

    ChatUser({
        required this.connection,
        required this.chatId,
        required this.lastTime,
        required this.totalUnread,
    });

    factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        connection: json["connection"],
        chatId: json["chat_id"],
        lastTime: json["last_time"],
        totalUnread: json["total_unread"],
    );

    Map<String, dynamic> toJson() => {
        "connection": connection,
        "chat_id": chatId,
        "last_time": lastTime,
        "total_unread": totalUnread,
    };
}
