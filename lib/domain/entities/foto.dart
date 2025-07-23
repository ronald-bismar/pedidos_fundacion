class Photo {
  String id;
  String name;
  String url;

  Photo({required this.id, this.name = '', this.url = ''});

  @override
  String toString() {
    return 'PhotoUser{id: $id, name: $name, email: $url}';
  }
}
