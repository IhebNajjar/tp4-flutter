import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waiting_room_app/models/client.dart';

class QueueProvider extends ChangeNotifier {
  final List<Client> _clients = [];
  List<Client> get clients => List.unmodifiable(_clients);

  final SupabaseClient? _supabase;
  RealtimeChannel? _channel;

  QueueProvider({SupabaseClient? client})
      : _supabase = client ?? _getSupabaseClientSafely() {
    if (_supabase != null) {
      _fetchInitialClients();
      _setupRealtimeSubscription();
    }
  }

  @visibleForTesting
  QueueProvider.forTesting(SupabaseClient supabase)
      : _supabase = supabase,
        super();

  static SupabaseClient? _getSupabaseClientSafely() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Future<void> _fetchInitialClients() async {
    final client = _supabase;
    if (client == null) return;
    try {
      List<dynamic> data;
      try {
        data = await client
            .from('clients')
            .select()
            .order('created_at', ascending: true);
      } catch (_) {
        data = await client.from('clients').select();
      }
      _clients.clear();
      _clients.addAll(
        data.map((item) => Client.fromMap(item as Map<String, dynamic>)),
      );
      _clients.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching clients: $e');
    }
  }

  void _setupRealtimeSubscription() {
    final client = _supabase;
    if (client == null) return;
    _channel = client
        .channel('public:clients')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'clients',
          callback: (payload) {
            if (payload.eventType == PostgresChangeEvent.insert) {
              final newClient = Client.fromMap(payload.newRecord);
              _clients.removeWhere((c) => c.id == newClient.id);
              _clients.add(newClient);
              _clients.sort((a, b) => a.createdAt.compareTo(b.createdAt));
              notifyListeners();
            } else if (payload.eventType == PostgresChangeEvent.delete) {
              final deletedId = payload.oldRecord['id'];
              if (deletedId != null) {
                _clients.removeWhere((client) => client.id == deletedId);
                notifyListeners();
              }
            }
          },
        )
        .subscribe();
  }

  static int _localCounter = 0;

  Future<void> addClient(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      debugPrint('Cannot add empty client name');
      return;
    }

    final client = _supabase;
    if (client == null) {
      // Local fallback for offline mode or widget tests
      _localCounter++;
      final uniqueId = '${DateTime.now().microsecondsSinceEpoch}_$_localCounter';
      _clients.add(
        Client(
          id: uniqueId,
          name: trimmedName,
          createdAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return;
    }

    try {
      await client.from('clients').insert({'name': trimmedName});
      debugPrint('Client added: $trimmedName');
    } catch (e) {
      debugPrint('Failed to add client: $e');
    }
  }

  Future<void> removeClient(String id) async {
    final client = _supabase;
    if (client == null) {
      _clients.removeWhere((c) => c.id == id);
      notifyListeners();
      return;
    }

    try {
      await client.from('clients').delete().eq('id', id);
      debugPrint('Client removed: $id');
    } catch (e) {
      debugPrint('Failed to remove client: $e');
    }
  }

  Future<void> nextClient() async {
    if (_clients.isEmpty) {
      debugPrint('Queue is empty!');
      return;
    }
    final firstClient = _clients.first;
    await removeClient(firstClient.id);
    debugPrint('Next client: ${firstClient.name}');
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
}
