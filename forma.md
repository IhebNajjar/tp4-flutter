# AI Assistance Note

**Project:** Workshop 4 — Real-Time Waiting Room with Flutter & Supabase  
**Student:** Iheb Najjar  
**Class:** DSI 31  
**AI Assistant:** Antigravity (Google DeepMind)  

---

### Description of AI Usage:
During this workshop, an AI coding assistant was used for standard pair-programming guidance, troubleshooting specific syntax errors, and resolving package configuration issues. The core logic, database setup, and feature implementations were guided by the workshop requirements.

### Tasks the AI Assisted With:
- **Dependency Troubleshooting:** Helping resolve package version conflicts in `pubspec.yaml` when adding `supabase_flutter` and `flutter_dotenv`.
- **Asset Configuration:** Explaining how to register the `.env` file under the `assets:` section of `pubspec.yaml` so environment variables load properly.
- **SQL / RLS Policy Syntax:** Providing standard PostgreSQL syntax for Row Level Security policies (`SELECT`, `INSERT`, `DELETE`) on the `clients` table.
- **Defensive Parsing:** Assisting with handling null values safely inside `DateTime.parse()` in the `Client.fromMap()` model.
- **Documentation Formatting:** Helping organize the project README and function explanations into clean Markdown.

---

### 5 Prompts Used During the Workshop:

1. *"How do I fix missing packages in pubspec.yaml when adding supabase_flutter and flutter_dotenv?"*
2. *"Why does flutter_dotenv throw an asset error, and how do I declare the .env file in pubspec.yaml assets?"*
3. *"What is the SQL syntax for Supabase RLS policies to allow anonymous users to insert and delete tickets?"*
4. *"How can I safely parse created_at in Client.fromMap so it doesn't crash if the value is null?"*
5. *"Help me organize and format the project README documentation for my TP4 submission."*
