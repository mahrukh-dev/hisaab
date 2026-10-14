/// Enum representing the types of accounts.
enum AccountType {
  /// Bank account (e.g. Meezan, HBL).
  bank,

  /// Cash in hand.
  cash,

  /// Mobile wallet (e.g. JazzCash, Easypaisa).
  wallet,

  /// Credit card account.
  creditCard,
}

/// Domain model representing an Account.
class Account {
  /// Creates an [Account].
  const Account({
    required this.id,
    required this.name,
    required this.type,
    this.currency = 'PKR',
    this.openingBalanceMinor = 0,
    this.colorValue,
    this.iconName,
    this.isArchived = false,
  });

  /// Creates an [Account] from JSON.
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AccountType.values.firstWhere(
        (value) => value.name == (json['type'] as String? ?? 'bank'),
        orElse: () => AccountType.bank,
      ),
      currency: json['currency'] as String? ?? 'PKR',
      openingBalanceMinor: json['openingBalanceMinor'] as int? ?? 0,
      colorValue: json['colorValue'] as int?,
      iconName: json['iconName'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  /// Unique account id.
  final String id;

  /// User-facing account name.
  final String name;

  /// Account type.
  final AccountType type;

  /// ISO currency code.
  final String currency;

  /// Opening balance in minor units.
  final int openingBalanceMinor;

  /// Optional brand color.
  final int? colorValue;

  /// Optional icon key.
  final String? iconName;

  /// Whether the account is archived.
  final bool isArchived;

  /// Serializes the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'currency': currency,
      'openingBalanceMinor': openingBalanceMinor,
      'colorValue': colorValue,
      'iconName': iconName,
      'isArchived': isArchived,
    };
  }

  /// Creates a copy of this account with selected fields replaced.
  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    String? currency,
    int? openingBalanceMinor,
    int? colorValue,
    String? iconName,
    bool? isArchived,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Account &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            type == other.type &&
            currency == other.currency &&
            openingBalanceMinor == other.openingBalanceMinor &&
            colorValue == other.colorValue &&
            iconName == other.iconName &&
            isArchived == other.isArchived;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      type,
      currency,
      openingBalanceMinor,
      colorValue,
      iconName,
      isArchived,
    );
  }
}
