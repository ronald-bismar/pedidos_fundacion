class Photo {
  String id;
  String name;
  String urlRemote;
  String urlLocal;

  Photo({required this.id, this.name = '', this.urlRemote = '', this.urlLocal = ''});

  @override
  String toString() {
    return 'PhotoUser{id: $id, name: $name, email: $urlRemote, location: $urlLocal}';
  }
}
