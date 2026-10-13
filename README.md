# Real-Time Waiting Room with Flutter & Supabase (TP4)

A distributed, real-time waiting room application built with **Flutter**, **Provider**, and **Supabase (PostgreSQL)**. 

Changes made on one device (adding or serving clients) are instantly reflected across all connected devices in real time with zero manual refreshing.

---

## 📌 Features

- **Real-Time Synchronization:** Instant updates across multiple devices using Supabase WebSocket channels (`supabase_realtime`).
- **Distributed State Management:** Managed via `Provider` and `ChangeNotifier`, keeping UI decoupled from database interactions.
- **FIFO Queue Processing:** "Next Client" button dequeues the earliest ticket in line according to timestamp.
- **Type-Safe Data Model:** Dedicated `Client` model with robust JSON serialization (`fromMap` / `toMap`).
- **Database Security:** Protected by PostgreSQL Row Level Security (RLS) with dedicated policies for anonymous queue access.
- **100% Test Coverage:** Verified with unit tests, mocked Supabase integration tests, and interactive widget tests.

---

## 🏗️ Project Architecture

```
lib/
├── models/
│   └── client.dart        # Strongly typed Client data model (id, name, createdAt)
├── queue_provider.dart    # ChangeNotifier managing queue logic & Supabase Realtime
└── main.dart              # App entry point, Supabase initialization, & WaitingRoomScreen UI

test/
├── client_model_test.dart        # Unit tests for JSON mapping & serialization
├── queue_provider_test.dart      # Unit test with mocked Supabase client (mocktail)
├── waiting_room_manager_test.dart# State logic tests (FIFO, add, delete)
└── waiting_room_widget_test.dart # Widget interaction tests
```

---

## ⚙️ Core Functions & Classes

### 1. `Client` Model (`lib/models/client.dart`)
- **`Client({required id, required name, required createdAt})`**: Immutable representation of a queue ticket.
- **`Client.fromMap(map)`**: Deserializes database records with null-safe handling of timestamps.
- **`toMap()`**: Serializes client data into JSON maps.

### 2. `QueueProvider` (`lib/queue_provider.dart`)
- **`clients`**: Unmodifiable getter providing read access to the waiting list.
- **`_fetchInitialClients()`**: Retrieves existing tickets from Supabase ordered by `created_at ASC`.
- **`_setupRealtimeSubscription()`**: Listens to PostgreSQL `INSERT` and `DELETE` events over WebSockets and updates local state.
- **`addClient(String name)`**: Inserts a new client ticket into the Supabase database.
- **`removeClient(String id)`**: Deletes a specific client ticket by UUID.
- **`nextClient()`**: Dequeues the client at the front of the line (index 0).
- **`dispose()`**: Closes active WebSocket subscriptions to prevent memory leaks.

### 3. `WaitingRoomScreen` (`lib/main.dart`)
- **Input Row**: Text field and "Add" button to add new clients.
- **Queue List (`Consumer<QueueProvider>`)**: Displays waiting clients in cards showing name, date, and individual delete buttons.
- **"Next Client" Button**: Green action button that serves the next client in line.

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or higher)
- A free [Supabase](https://supabase.com) account

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Environment Configuration
Create a `.env` file in the project root:
```properties
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
```
> *(Note: A `.env.example` template is provided. `.env` is ignored by Git to protect secrets).*

### 4. Supabase Database Setup
In your Supabase **SQL Editor**, execute:
```sql
-- Create table
CREATE TABLE IF NOT EXISTS public.clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- Add RLS Policies
CREATE POLICY "Allow public select" ON public.clients FOR SELECT TO anon USING (true);
CREATE POLICY "Allow public insert" ON public.clients FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public delete" ON public.clients FOR DELETE TO anon USING (true);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.clients;
```

---

## 🧪 Testing

Run the full automated test suite:
```bash
flutter test
```
All **10 tests** (model, mock client, business logic, and widget UI) should pass with 100% success.

---

## 📱 How to Test Multi-Device Real-Time Sync

To verify live real-time synchronization between two devices:

1. **Open two separate terminal windows:**
   ```bash
   # Window 1 (Chrome):
   flutter run -d chrome

   # Window 2 (Edge / Emulator):
   flutter run -d edge
   ```
2. On **Window 1**, enter `"Alice"` and click **Add**.
3. **Observe Window 2**: Alice appears **instantly** without reloading.
4. On **Window 2**, click **Next Client**.
5. **Observe both windows**: Alice is dequeued from both screens simultaneously in real time!
