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
    return 'Photo{id: $id, name: $name, urlRemote: $urlRemote, urlLocal: $urlLocal}';
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

  Photo copyWith({
    String? id,
    String? name,
    String? urlRemote,
    String? urlLocal,
  }) {
    return Photo(
      id: id ?? this.id,
      name: name ?? this.name,
      urlRemote: urlRemote ?? this.urlRemote,
      urlLocal: urlLocal ?? this.urlLocal,
    );
  }
}
