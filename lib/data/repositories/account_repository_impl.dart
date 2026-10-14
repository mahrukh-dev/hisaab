import 'package:hisaab/data/db/app_database.dart';
import 'package:hisaab/domain/models/account.dart';
import 'package:hisaab/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Account>> getAccounts() async {
    final rows = await _db.getAccounts();
    return rows.map(_accountFromRow).toList();
  }

  @override
  Future<Account?> getAccountById(String id) async {
    final rows = await _db.getAccounts();
    for (final row in rows) {
      if ((row['id'] as String?) == id) {
        return _accountFromRow(row);
      }
    }
    return null;
  }

  @override
  Future<Account> saveAccount(Account account) async {
    await _db.upsertAccount(
      id: account.id,
      name: account.name,
      type: account.type.name,
      currency: account.currency,
      openingBalanceMinor: account.openingBalanceMinor,
      colorValue: account.colorValue,
      iconName: account.iconName,
      isArchived: account.isArchived,
    );
    final stored = await getAccountById(account.id);
    if (stored == null) {
      throw StateError('Account ${account.id} could not be saved.');
    }
    return stored;
  }

  @override
  Future<int> getBalanceMinor(String accountId) async {
    return _db.getAccountBalanceMinor(accountId);
  }

  Account _accountFromRow(Map<String, Object?> row) {
    return Account(
      id: row['id'] as String,
      name: row['name'] as String,
      type: AccountType.values.firstWhere(
        (value) => value.name == (row['type'] as String? ?? 'bank'),
        orElse: () => AccountType.bank,
      ),
      currency: row['currency'] as String? ?? 'PKR',
      openingBalanceMinor: (row['opening_balance_minor'] as int?) ?? 0,
      colorValue: row['color_value'] as int?,
      iconName: row['icon_name'] as String?,
      isArchived: (row['is_archived'] as int? ?? 0) == 1,
    );
  }
}
