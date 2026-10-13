import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:waiting_room_app/main.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  testWidgets('should add a new client to the list on button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => QueueProvider(),
        child: const WaitingRoomApp(),
      ),
    );

    // Initial empty state
    expect(find.text('No one in queue yet...'), findsOneWidget);

    // Add a client
    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();

    // Verify Alice is in the list
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('No one in queue yet...'), findsNothing);
  });

  testWidgets(
      'should remove a client from the list when the delete button is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => QueueProvider(),
        child: const WaitingRoomApp(),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Bob');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();

    expect(find.text('Bob'), findsOneWidget);

    // Tap delete button
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Bob'), findsNothing);
    expect(find.text('No one in queue yet...'), findsOneWidget);
  });

  testWidgets(
      'should remove the first client from the list when "Next Client" is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => QueueProvider(),
        child: const WaitingRoomApp(),
      ),
    );

    // Add two clients
    await tester.enterText(find.byType(TextField), 'Client A');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Client B');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pump();

    expect(find.text('Client A'), findsOneWidget);
    expect(find.text('Client B'), findsOneWidget);

    // Tap Next Client
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next Client'));
    await tester.pump();

    // Client A is dequeued, Client B remains
    expect(find.text('Client A'), findsNothing);
    expect(find.text('Client B'), findsOneWidget);
  });
}
