import 'dart:io';

List<Map<String, dynamic>> processSingleString(String rawData) {
  // Step 1: Split by the hash ('#') delimiter to separate records
  final records = rawData.split('#');

  List<Map<String, dynamic>> models = <Map<String, dynamic>>[];

  // Step 2: Iterate over each record and parse it
  int count = 0;
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (final record in records) {
    count++;
    if (record.trim().isNotEmpty) {
      try {
        final m = parseFromPipeDelimited(record);
        models.add(m);  
      } catch (e) {
        print('Error parsing record: $e');
      }
    }
  }
  stopwatch.stop();
  print(stopwatch.elapsedMilliseconds / 1000);
  print(count);
  return models;
}

Map<String, dynamic> parseFromPipeDelimited(String record) {
  final fields = record.split('|');
  return {
    'exch': fields[0],
    'exchType': fields[1],
    'nseCode': fields[2],
    'bseCode': fields[3],
    'symbol': fields[4],
    'tickSize': fields[5],
    'series': fields[6],
    'companyName': fields[7],
    'scripMultiplier': fields[8],
    'displayUnitMessage': fields[9],
    'description': fields[10],
    'shortCode': fields[11],
    'surveillanceIndicator': fields[12],
    'expiry': fields[13],
    'cpType': fields[14],
    'marketLot': fields[15],
    'isSliceEnable': fields[16] == 'Y',
    'qtyLimit': fields[17],
    'mtfEnabled': fields[18] == 'Y',
    'scripCode': fields[19],
    'isIndice': fields[20] == 'Y',
    'isEtf': fields[21] == 'Y',
  };
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

  // Process the data in chunks
  processSingleString(rawData);
  rss = ProcessInfo.currentRss;
  print('Memory used (RSS): ${rss ~/ (1024 * 1024)} MB');
}
