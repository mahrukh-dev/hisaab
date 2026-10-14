import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqlite3/sqlite3.dart';

final Map<String, String> _secureStorageFallback = <String, String>{};

/// Minimal SQLite-backed database layer for Hisaab.
///
/// This keeps the schema and queries close to the Drift design from the Phase 2
/// specification while avoiding the broken code generator in this environment.
class AppDatabase {
  AppDatabase._(this._db);

  final Database _db;

  static Future<String> _readOrCreateKey() async {
    const secureStorage = FlutterSecureStorage();

    try {
      final existing = await secureStorage.read(key: 'hisaab_sqlite_key');
      if (existing != null && existing.isNotEmpty) {
        return existing;
      }

      final generated = DateTime.now().microsecondsSinceEpoch.toString();
      await secureStorage.write(
        key: 'hisaab_sqlite_key',
        value: generated,
      );
      return generated;
    } on Exception {
      final fallback = _secureStorageFallback['hisaab_sqlite_key'] ??
          DateTime.now().microsecondsSinceEpoch.toString();
      _secureStorageFallback['hisaab_sqlite_key'] = fallback;
      return fallback;
    }
  }

  static Future<AppDatabase> open({String? filePath}) async {
    final encryptionKey = await _readOrCreateKey();

    final resolvedPath = filePath ??
        '${Directory.systemTemp.path}/hisaab_${DateTime.now().microsecondsSinceEpoch}.db';
    final db = sqlite3.open(resolvedPath);
    db.execute('PRAGMA foreign_keys = ON;');
    db.execute('PRAGMA journal_mode = WAL;');
    // SQLCipher is planned for production; the core schema is initialized here.

    final database = AppDatabase._(db);
    await database._initializeSchema();
    return database;
  }

  Future<void> _initializeSchema() async {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS accounts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        currency TEXT NOT NULL DEFAULT 'PKR',
        opening_balance_minor INTEGER NOT NULL DEFAULT 0,
        color_value INTEGER,
        icon_name TEXT,
        is_archived INTEGER NOT NULL DEFAULT 0
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        kind TEXT NOT NULL,
        parent_id TEXT,
        icon_name TEXT,
        color_value INTEGER,
        is_system INTEGER NOT NULL DEFAULT 0
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS transactions (
        id TEXT PRIMARY KEY,
        kind TEXT NOT NULL,
        amount_minor INTEGER NOT NULL,
        currency TEXT NOT NULL DEFAULT 'PKR',
        category_id TEXT,
        merchant TEXT,
        note TEXT,
        occurred_at TEXT NOT NULL,
        created_at TEXT NOT NULL,
        deleted_at TEXT,
        source TEXT NOT NULL DEFAULT 'manual'
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS transaction_splits (
        id TEXT PRIMARY KEY,
        transaction_id TEXT NOT NULL,
        account_id TEXT NOT NULL,
        amount_minor INTEGER NOT NULL,
        direction TEXT NOT NULL,
        FOREIGN KEY (transaction_id) REFERENCES transactions(id)
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS budgets (
        id TEXT PRIMARY KEY,
        category_id TEXT NOT NULL,
        period TEXT NOT NULL DEFAULT 'monthly',
        amount_minor INTEGER NOT NULL,
        currency TEXT NOT NULL DEFAULT 'PKR',
        has_rollover INTEGER NOT NULL DEFAULT 0
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS recurring_rules (
        id TEXT PRIMARY KEY,
        template_json TEXT NOT NULL,
        rrule TEXT NOT NULL,
        next_run_at TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS tags (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        color_value INTEGER
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS transaction_tags (
        transaction_id TEXT NOT NULL,
        tag_id TEXT NOT NULL,
        PRIMARY KEY (transaction_id, tag_id)
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS attachments (
        id TEXT PRIMARY KEY,
        transaction_id TEXT NOT NULL,
        path TEXT NOT NULL,
        mime_type TEXT,
        ocr_text TEXT
      );
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS ai_cache (
        key_hash TEXT PRIMARY KEY,
        response TEXT NOT NULL,
        created_at TEXT NOT NULL
      );
    ''');

    _db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transactions_occurred_at
      ON transactions(occurred_at);
    ''');

    _db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transaction_splits_account_id
      ON transaction_splits(account_id);
    ''');

    _db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transactions_category_id
      ON transactions(category_id);
    ''');

    _db.execute('''
      CREATE INDEX IF NOT EXISTS idx_transactions_deleted_at
      ON transactions(deleted_at);
    ''');

    await _ensureSeedCategories();
  }

  Future<void> _ensureSeedCategories() async {
    final existing = _db.select(
      'SELECT COUNT(*) as count FROM categories WHERE is_system = 1;',
    );
    if (((existing.first['count'] as int?) ?? 0) > 0) {
      return;
    }

    final rows = <Map<String, Object?>>[
      {
        'id': 'food',
        'name': 'Food & Dining',
        'kind': 'expense',
        'parent_id': null,
        'icon_name': 'restaurant',
        'color_value': 0xFF8E24AA,
        'is_system': 1,
      },
      {
        'id': 'transport',
        'name': 'Transport',
        'kind': 'expense',
        'parent_id': null,
        'icon_name': 'directions_car',
        'color_value': 0xFF1565C0,
        'is_system': 1,
      },
      {
        'id': 'salary',
        'name': 'Salary',
        'kind': 'income',
        'parent_id': null,
        'icon_name': 'payments',
        'color_value': 0xFF2E7D32,
        'is_system': 1,
      },
    ];

    for (final row in rows) {
      _db.execute(
        '''
        INSERT INTO categories (id, name, kind, parent_id, icon_name, color_value, is_system)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        ''',
        [
          row['id'],
          row['name'],
          row['kind'],
          row['parent_id'],
          row['icon_name'],
          row['color_value'],
          row['is_system'],
        ],
      );
    }
  }

  Future<List<Map<String, Object?>>> getCategories() async {
    final rows = _db.select('SELECT * FROM categories ORDER BY name;');
    return rows.toList();
  }

  Future<List<Map<String, Object?>>> getAccounts() async {
    final rows = _db.select('SELECT * FROM accounts ORDER BY name;');
    return rows.toList();
  }

  Future<Map<String, Object?>?> getTransactionByIdRaw(String id) async {
    final rows = _db.select('SELECT * FROM transactions WHERE id = ? LIMIT 1;', [id]);
    if (rows.isEmpty) {
      return null;
    }
    return rows.first;
  }

  Future<List<Map<String, Object?>>> getTransactions({
    DateTime? from,
    DateTime? to,
    String? accountId,
    String? categoryId,
    String? text,
  }) async {
    var sql = 'SELECT * FROM transactions WHERE deleted_at IS NULL';
    final params = <Object?>[];

    if (from != null) {
      sql += ' AND occurred_at >= ?';
      params.add(from.toUtc().toIso8601String());
    }

    if (to != null) {
      sql += ' AND occurred_at <= ?';
      params.add(to.toUtc().toIso8601String());
    }

    if (categoryId != null) {
      sql += ' AND category_id = ?';
      params.add(categoryId);
    }

    if (text != null && text.isNotEmpty) {
      sql += ' AND (merchant LIKE ? OR note LIKE ?)';
      params.add('%$text%');
      params.add('%$text%');
    }

    if (accountId != null) {
      sql += ' AND id IN (SELECT transaction_id FROM transaction_splits WHERE account_id = ?)';
      params.add(accountId);
    }

    sql += ' ORDER BY occurred_at DESC';
    final result = _db.select(sql, params);
    return result.toList();
  }

  Future<List<Map<String, Object?>>> monthlyTotalsByCategory({
    required DateTime from,
    required DateTime to,
  }) async {
    final result = _db.select(
      '''
      SELECT category_id, SUM(amount_minor) as total_amount
      FROM transactions
      WHERE deleted_at IS NULL
        AND occurred_at >= ?
        AND occurred_at <= ?
      GROUP BY category_id
      ORDER BY total_amount DESC;
      ''',
      [from.toUtc().toIso8601String(), to.toUtc().toIso8601String()],
    );
    return result.toList();
  }

  Future<List<Map<String, Object?>>> balanceHistory({
    required String accountId,
    DateTime? from,
    DateTime? to,
  }) async {
    var sql = '''
      SELECT
        t.occurred_at,
        SUM(CASE WHEN ts.direction = 'debit' THEN ts.amount_minor ELSE -ts.amount_minor END) AS running_balance
      FROM transaction_splits ts
      INNER JOIN transactions t ON t.id = ts.transaction_id
      WHERE ts.account_id = ?
        AND t.deleted_at IS NULL
    ''';
    final params = <Object?>[accountId];

    if (from != null) {
      sql += ' AND t.occurred_at >= ?';
      params.add(from.toUtc().toIso8601String());
    }
    if (to != null) {
      sql += ' AND t.occurred_at <= ?';
      params.add(to.toUtc().toIso8601String());
    }

    sql += ' GROUP BY t.occurred_at ORDER BY t.occurred_at ASC';
    final result = _db.select(sql, params);
    return result.toList();
  }

  Future<void> upsertAccount({
    required String id,
    required String name,
    required String type,
    String currency = 'PKR',
    int openingBalanceMinor = 0,
    int? colorValue,
    String? iconName,
    bool isArchived = false,
  }) async {
    _db.execute(
      '''
      INSERT INTO accounts (
        id, name, type, currency, opening_balance_minor, color_value, icon_name, is_archived
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        name = excluded.name,
        type = excluded.type,
        currency = excluded.currency,
        opening_balance_minor = excluded.opening_balance_minor,
        color_value = excluded.color_value,
        icon_name = excluded.icon_name,
        is_archived = excluded.is_archived;
      ''',
      [
        id,
        name,
        type,
        currency,
        openingBalanceMinor,
        colorValue,
        iconName,
        isArchived ? 1 : 0,
      ],
    );
  }

  Future<void> insertAccount({
    required String id,
    required String name,
    required String type,
    String currency = 'PKR',
    int openingBalanceMinor = 0,
  }) async {
    await upsertAccount(
      id: id,
      name: name,
      type: type,
      currency: currency,
      openingBalanceMinor: openingBalanceMinor,
    );
  }

  Future<void> upsertTransaction({
    required String id,
    required String kind,
    required int amountMinor,
    required DateTime occurredAt,
    required DateTime createdAt,
    String currency = 'PKR',
    String? categoryId,
    String? merchant,
    String? note,
    String? source,
    List<Map<String, Object?>>? splits,
  }) async {
    _db.execute(
      '''
      INSERT INTO transactions (
        id, kind, amount_minor, currency, category_id, merchant, note,
        occurred_at, created_at, source
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET
        kind = excluded.kind,
        amount_minor = excluded.amount_minor,
        currency = excluded.currency,
        category_id = excluded.category_id,
        merchant = excluded.merchant,
        note = excluded.note,
        occurred_at = excluded.occurred_at,
        created_at = excluded.created_at,
        source = excluded.source;
      ''',
      [
        id,
        kind,
        amountMinor,
        currency,
        categoryId,
        merchant,
        note,
        occurredAt.toUtc().toIso8601String(),
        createdAt.toUtc().toIso8601String(),
        source ?? 'manual',
      ],
    );

    await deleteTransactionSplits(id);
    for (final split in splits ?? const <Map<String, Object?>>[]) {
      _db.execute(
        '''
        INSERT INTO transaction_splits (id, transaction_id, account_id, amount_minor, direction)
        VALUES (?, ?, ?, ?, ?);
        ''',
        [
          split['id'],
          id,
          split['account_id'],
          split['amount_minor'],
          split['direction'],
        ],
      );
    }
  }

  Future<void> insertTransaction({
    required String id,
    required String kind,
    required int amountMinor,
    required DateTime occurredAt,
    required DateTime createdAt,
    String currency = 'PKR',
    String? categoryId,
    String? merchant,
    String? note,
    String? source,
    List<Map<String, Object?>>? splits,
  }) async {
    await upsertTransaction(
      id: id,
      kind: kind,
      amountMinor: amountMinor,
      occurredAt: occurredAt,
      createdAt: createdAt,
      currency: currency,
      categoryId: categoryId,
      merchant: merchant,
      note: note,
      source: source,
      splits: splits,
    );
  }

  Future<List<Map<String, Object?>>> getTransactionSplits(String transactionId) async {
    final rows = _db.select(
      'SELECT * FROM transaction_splits WHERE transaction_id = ? ORDER BY id;',
      [transactionId],
    );
    return rows.toList();
  }

  Future<int> getAccountBalanceMinor(String accountId) async {
    final accountRow = _db.select(
      'SELECT opening_balance_minor FROM accounts WHERE id = ? LIMIT 1;',
      [accountId],
    );

    final openingBalance = accountRow.isEmpty
        ? 0
        : (accountRow.first['opening_balance_minor'] as int? ?? 0);

    final netRow = _db.select(
      '''
      SELECT COALESCE(SUM(CASE WHEN ts.direction = 'debit' THEN ts.amount_minor ELSE -ts.amount_minor END), 0) AS net
      FROM transaction_splits ts
      INNER JOIN transactions t ON ts.transaction_id = t.id
      WHERE ts.account_id = ? AND t.deleted_at IS NULL;
      ''',
      [accountId],
    );

    final net = netRow.isEmpty ? 0 : (netRow.first['net'] as int? ?? 0);
    return openingBalance + net;
  }

  Future<void> softDeleteTransaction(String id) async {
    _db.execute(
      'UPDATE transactions SET deleted_at = ? WHERE id = ?;',
      [DateTime.now().toUtc().toIso8601String(), id],
    );
  }

  Future<void> restoreTransaction(String id) async {
    _db.execute(
      'UPDATE transactions SET deleted_at = NULL WHERE id = ?;',
      [id],
    );
  }

  Future<void> deleteTransactionSplits(String transactionId) async {
    _db.execute(
      'DELETE FROM transaction_splits WHERE transaction_id = ?;',
      [transactionId],
    );
  }

  Future<T> transaction<T>(Future<T> Function() action) async {
    _db.execute('BEGIN IMMEDIATE;');
    try {
      final result = await action();
      _db.execute('COMMIT;');
      return result;
    } catch (_) {
      _db.execute('ROLLBACK;');
      rethrow;
    }
  }

  void close() {
    _db.dispose();
  }
}
