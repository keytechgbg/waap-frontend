class Photo {
  Photo({this.url, this.owner});

  String url;
  int likes;
  int liked;
  String owner;
  int id;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'url': url, 'likes': likes, 'liked': liked, 'owner': owner};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    likes = map["likes"];
    url = map["url"];
    liked=map["liked"];
    owner=map["owner"];
  }
}

