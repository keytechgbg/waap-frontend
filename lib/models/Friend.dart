class Friend {
  Friend({this.username, this.status});

  String username;
  int status;
  int from_user;
  int id;

  static int WAITING = 1;
  static int ACCEPTED = 2;
  static int REJECTED = 3;
  static Map STATUSES = {
    "WAITING": WAITING,
    "ACCEPTED": ACCEPTED,
    "REJECTED": REJECTED,
    WAITING: "WAITING",
    ACCEPTED: "ACCEPTED",
    REJECTED: "REJECTED",

  };

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'username': username, 'status': status, 'from_user': from_user};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Friend.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    status = map["status"];
    username = map["username"];
    from_user=map["from_user"];
  }
}

