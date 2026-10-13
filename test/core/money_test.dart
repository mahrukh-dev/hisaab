import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/core/money.dart';

void main() {
  group('Money Value Object', () {
    test('creates Money instance with default PKR currency', () {
      const money = Money(1500);
      expect(money.minorUnits, equals(1500));
      expect(money.currency, equals('PKR'));
    });

    test('addition adds minor units for same currency', () {
      const m1 = Money(1200);
      const m2 = Money(800);
      final result = m1 + m2;

      expect(result.minorUnits, equals(2000));
      expect(result.currency, equals('PKR'));
    });

    test('subtraction subtracts minor units for same currency', () {
      const m1 = Money(5000);
      const m2 = Money(3000);
      final result = m1 - m2;

      expect(result.minorUnits, equals(2000));
    });

    test('negation negates minor units', () {
      const m = Money(1500);
      expect((-m).minorUnits, equals(-1500));
    });

    test('throws ArgumentError on currency mismatch', () {
      const pkr = Money(1000);
      const usd = Money(1000, currency: 'USD');

      expect(() => pkr + usd, throwsArgumentError);
      expect(() => pkr - usd, throwsArgumentError);
      expect(() => pkr < usd, throwsArgumentError);
    });

    test('comparison operators work correctly', () {
      const m1 = Money(1000);
      const m2 = Money(2000);

      expect(m1 < m2, isTrue);
      expect(m1 <= m2, isTrue);
      expect(m2 > m1, isTrue);
      expect(m2 >= m1, isTrue);
      expect(m1 == const Money(1000), isTrue);
    });

    test('scalar multiplication rounds correctly', () {
      const m = Money(1000);
      expect(m.multiplyBy(1.5).minorUnits, equals(1500));
      expect(m.multiplyBy(0.333333).minorUnits, equals(333));
    });

    group('allocate()', () {
      test('splits Rs. 5000 as 3:2 ratio into Rs. 3000 and Rs. 2000', () {
        const money = Money(500000); // 5000.00
        final allocated = money.allocate([3, 2]);

        expect(allocated.length, equals(2));
        expect(allocated[0].minorUnits, equals(300000));
        expect(allocated[1].minorUnits, equals(200000));
        final sum = allocated[0].minorUnits + allocated[1].minorUnits;
        expect(sum, equals(500000));
      });

      test('allocates odd amounts without losing minor units', () {
        const money = Money(100); // 100 minor units split 3 ways
        final allocated = money.allocate([1, 1, 1]);

        expect(allocated.length, equals(3));
        expect(allocated[0].minorUnits, equals(34));
        expect(allocated[1].minorUnits, equals(33));
        expect(allocated[2].minorUnits, equals(33));

        final totalAllocated =
            allocated.fold<int>(0, (sum, m) => sum + m.minorUnits);
        expect(totalAllocated, equals(100));
      });

      test('property test: allocate always sums to total across 100 tests', () {
        final random = Random(42);

        for (var i = 0; i < 100; i++) {
          final totalAmount = random.nextInt(1000000) + 1; // 1 to 10,000.00
          final numParts = random.nextInt(5) + 1; // 1 to 5 parts
          final ratios = List.generate(numParts, (_) => random.nextInt(10) + 1);

          final money = Money(totalAmount);
          final parts = money.allocate(ratios);

          final sumParts = parts.fold<int>(0, (sum, m) => sum + m.minorUnits);
          expect(sumParts, equals(totalAmount));
        }
      });

      test('throws on empty or zero ratios', () {
        const money = Money(1000);
        expect(() => money.allocate([]), throwsArgumentError);
        expect(() => money.allocate([0, 0]), throwsArgumentError);
        expect(() => money.allocate([-1, 2]), throwsArgumentError);
      });
    });

    group('Money.parse()', () {
      test('parses integer strings', () {
        final money = Money.parse('1200');
        expect(money.minorUnits, equals(120000));
      });

      test('parses decimal strings with commas', () {
        final money = Money.parse('1,250.50');
        expect(money.minorUnits, equals(125050));
      });

      test('parses negative strings', () {
        final money = Money.parse('-500.25');
        expect(money.minorUnits, equals(-50025));
      });

      test('parses strings with currency prefixes', () {
        final money = Money.parse('PKR 1200.00');
        expect(money.minorUnits, equals(120000));
      });

      test('throws FormatException on unparseable input', () {
        expect(() => Money.parse('invalid'), throwsFormatException);
      });
    });

    group('format()', () {
      test('formats PKR currency with Rs. symbol', () {
        const money = Money(125050); // 1250.50
        expect(money.format(), equals('Rs.1,250.50'));
      });

      test('formats without symbol', () {
        const money = Money(125050);
        expect(money.format(includeSymbol: false), equals('1,250.50'));
      });
    });
  });
}
