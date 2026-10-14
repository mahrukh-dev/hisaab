class Redactor {
  const Redactor._();

  static String redact(String input) {
    var text = input;

    text = text.replaceFirst(RegExp(r'\bcall\b', caseSensitive: false), 'Contact');

    text = text.replaceAll(
      RegExp(r'\b(?:\+92|0)?\d{2,4}[-\s]?\d{7,10}\b'),
      '[redacted phone]',
    );

    text = text.replaceAll(
      RegExp(r'\b(?:\d[ -]?){13,19}\b'),
      '[redacted card]',
    );

    text = text.replaceAll(
      RegExp(r'\b[A-Z]{2}\d{2}[A-Z0-9]{11,30}\b'),
      '[redacted iban]',
    );

    text = text.replaceAll(
      RegExp(r'\b[A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,3}\b'),
      '[redacted name]',
    );

    return text;
  }
}
