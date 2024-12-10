class ChatModel {
    List<String> connections;
    List<Chat> chat;

    ChatModel({
        required this.connections,
        required this.chat,
    });

    factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        connections: List<String>.from(json["connections"].map((x) => x)),
        chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connections.map((x) => x)),
        "chat": List<dynamic>.from(chat.map((x) => x.toJson())),
    };
}

class Chat {
    String pengirim;
    String penerima;
    String pesan;
    String time;
    bool isRead;

    Chat({
        required this.pengirim,
        required this.penerima,
        required this.pesan,
        required this.time,
        required this.isRead,
    });

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        pengirim: json["pengirim"],
        penerima: json["penerima"],
        pesan: json["pesan"],
        time: json["time"],
        isRead: json["isRead"],
    );

    Map<String, dynamic> toJson() => {
        "pengirim": pengirim,
        "penerima": penerima,
        "pesan": pesan,
        "time": time,
        "isRead": isRead,
    };
}
