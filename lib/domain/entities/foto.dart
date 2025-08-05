class Photo {
  String id;
  String name;
  String urlRemote;
  String urlLocal;

  Photo({
    required this.id,
    this.name = '',
    this.urlRemote = '',
    this.urlLocal = '',
  });

  @override
  String toString() {
    return 'PhotoUser{id: $id, name: $name, email: $urlRemote, location: $urlLocal}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'urlRemote': urlRemote,
      'urlLocal': urlLocal,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      name: map['name'] ?? '',
      urlRemote: map['urlRemote'] ?? '',
      urlLocal: map['urlLocal'] ?? '',
    );
  }
}
