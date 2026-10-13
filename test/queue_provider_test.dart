import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waiting_room_app/queue_provider.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class FakePostgrestFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  @override
  Future<R> then<R>(FutureOr<R> Function(dynamic value) onValue,
      {Function? onError}) {
    return Future.value([]).then(onValue, onError: onError);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  test('addClient calls insert with client name', () async {
    final mockClient = MockSupabaseClient();
    final mockQueryBuilder = MockSupabaseQueryBuilder();
    final fakeFilterBuilder = FakePostgrestFilterBuilder();

    when(() => mockClient.from('clients')).thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.insert(any())).thenAnswer((_) => fakeFilterBuilder);

    final provider = QueueProvider.forTesting(mockClient);

    await provider.addClient('Alice');

    verify(() => mockClient.from('clients')).called(1);
    verify(() => mockQueryBuilder.insert({'name': 'Alice'})).called(1);
  });
}
