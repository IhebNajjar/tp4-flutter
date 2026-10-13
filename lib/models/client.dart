class Client {
  final String id;
  final String name;
  final DateTime createdAt;

  Client({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    final rawDate = map['created_at'] ?? map['crea'];
    if (rawDate != null) {
      try {
        parsedDate = DateTime.parse(rawDate.toString());
      } catch (_) {
        parsedDate = DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }

    return Client(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? 'Unnamed').toString(),
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'Client(id: $id, name: $name, created_at: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Client &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
