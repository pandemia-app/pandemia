class Favorite {
  final String id;
  final String name;
  final String address;
  final Map<int, int> attendance;
  bool isExpanded;

  Favorite ({this.id, this.name, this.address, this.attendance, this.isExpanded = true});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address
    };
  }

  @override
  String toString() {
    return 'Favorite{name: $name, address: $address}';
  }

  String getIdentifier() {
    return '$name $address';
  }
}