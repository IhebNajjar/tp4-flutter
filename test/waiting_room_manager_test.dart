import 'package:flutter_test/flutter_test.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  test('should add a client to the waiting list', () async {
    final manager = QueueProvider();

    await manager.addClient('John Doe');

    expect(manager.clients.length, 1);
    expect(manager.clients.first.name, 'John Doe');
  });

  test('should remove a client from the waiting list', () async {
    final manager = QueueProvider();
    await manager.addClient('John Doe');
    await manager.addClient('Jane Doe');

    final firstId = manager.clients.first.id;
    await manager.removeClient(firstId);

    expect(manager.clients.length, 1);
    expect(manager.clients.first.name, 'Jane Doe');
  });

  test('should remove the first client when nextClient() is called', () async {
    final manager = QueueProvider();
    await manager.addClient('Client A');
    await manager.addClient('Client B');

    await manager.nextClient();

    expect(manager.clients.length, 1);
    expect(manager.clients.first.name, 'Client B');
  });
}
