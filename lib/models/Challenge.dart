class Challenge {
  Challenge(
      {this.theme,
      this.reward,
      this.image_count,
      this.voting,
      this.expire,
      this.status,
      this.id,
      this.users});

  String theme;
  String reward;
  int status;
  int image_count;
  DateTime expire, voting;
  int id;
  String users;

  static int STARTED = 1;
  static int VOTING = 2;
  static int FINISHED = 3;
  static Map STATUSES = {
    STARTED: "STARTED",
    VOTING: "VOTING",
    FINISHED: "FINISHED"
  };

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'theme': theme,
      'reward': reward,
      'image_count': image_count,
      'users': users,
      'expire': expire.toString(),
      'voting': voting.toString(),
      'status': status
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}