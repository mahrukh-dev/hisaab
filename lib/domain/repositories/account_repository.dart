import 'package:hisaab/domain/models/account.dart';

abstract class AccountRepository {
  Future<List<Account>> getAccounts();

  Future<Account?> getAccountById(String id);

  Future<Account> saveAccount(Account account);

  Future<int> getBalanceMinor(String accountId);
}
