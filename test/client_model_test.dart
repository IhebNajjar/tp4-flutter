import 'package:flutter_test/flutter_test.dart';
import 'package:waiting_room_app/models/client.dart';

void main() {
  group('Client Model Tests', () {
    test('Client.fromMap should correctly deserialize map data', () {
      final now = DateTime.now().toUtc();
      final map = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'name': 'Alice Smith',
        'created_at': now.toIso8601String(),
      };

      final client = Client.fromMap(map);

      expect(client.id, '123e4567-e89b-12d3-a456-426614174000');
      expect(client.name, 'Alice Smith');
      expect(client.createdAt.toIso8601String(), now.toIso8601String());
    });

    test('Client.toMap should correctly serialize client data', () {
      final now = DateTime.now().toUtc();
      final client = Client(
        id: '987-xyz',
        name: 'Bob Jones',
        createdAt: now,
      );

      final map = client.toMap();

      expect(map['id'], '987-xyz');
      expect(map['name'], 'Bob Jones');
      expect(map['created_at'], now.toIso8601String());
    });

    test('toString returns formatted string representation', () {
      final now = DateTime.parse('2026-10-13T09:00:00Z');
      final client = Client(id: '1', name: 'John', createdAt: now);

      expect(
        client.toString(),
        'Client(id: 1, name: John, created_at: 2026-10-13 09:00:00.000Z)',
      );
    });
  });
}
