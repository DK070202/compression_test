import 'dart:io';

String escape(String input) => input.replaceAll("'", "''");

String buildBulkInsertQuery(String message) {
  final rows = message.split('#').map((line) => line.split('|')).toList();
  final buffer = StringBuffer();
  buffer.write('INSERT INTO exchange_data (');
  buffer.write('Exch, ExchType, ScripCode, Symbol, CPType, ');
  buffer.write('MarketLot, Series, Nsecode, Bsecode, Companyname');
  buffer.write(') VALUES ');

  for (int i = 0; i < rows.length; i++) {
    final row = rows[i];
    buffer.write("('${escape(row[0])}', ");
    buffer.write("'${escape(row[1])}', ");
    buffer.write("'${escape(row[2])}', ");
    buffer.write("'${escape(row[3])}', ");
    buffer.write("'${escape(row[4])}', ");
    buffer.write("${row[5]}, ");
    buffer.write("'${escape(row[6])}', ");
    buffer.write("'${escape(row[7])}', ");
    buffer.write("'${escape(row[8])}', ");
    buffer.write("'${escape(row[9])}')");
    if (i != rows.length - 1) buffer.write(', ');
  }

  buffer.write(';');
  return buffer.toString();
}

void main() async {
  int rss = ProcessInfo.currentRss;
  print('Memory used (RSS): ${rss ~/ (1024 * 1024)} MB');
  final singleRecord =
      'N|C|3715|VLSFINANCE|XX|1|EQ|3715|0|VLSFINANCE|||0|Y|467131|Y|0|0.010000|1||N|N';

  // Define how many records you want (150,000 in this case)
  final numberOfRecords = 150000;

  // Repeat the single record multiple times to reach the desired length
  final rawData = List.generate(numberOfRecords, (_) => singleRecord).join('#');

  final result = buildBulkInsertQuery(rawData);

  print(result.length);

  rss = ProcessInfo.currentRss;
  print('Memory used (RSS): ${rss ~/ (1024 * 1024)} MB');
}
