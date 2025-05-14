import 'dart:io';

class ScripInfo {
  final String exch;
  final String exchType;
  final String scripCode;
  final String symbol;
  final String cpType;
  final String marketLot;
  final String series;
  final String nsecode;
  final String bsecode;
  final String companyName;
  final String description;
  final String shortCode;
  final String surveillanceIndicator;
  final String mtfEnabled;
  final String qtyLimit;
  final String isSliceEnable;
  final String expiry;
  final String tickSize;
  final String scripMultiplier;
  final String displayUnitMessage;
  final String isIndice;
  final String isEtf;

  ScripInfo({
    required this.exch,
    required this.exchType,
    required this.scripCode,
    required this.symbol,
    required this.cpType,
    required this.marketLot,
    required this.series,
    required this.nsecode,
    required this.bsecode,
    required this.companyName,
    required this.description,
    required this.shortCode,
    required this.surveillanceIndicator,
    required this.mtfEnabled,
    required this.qtyLimit,
    required this.isSliceEnable,
    required this.expiry,
    required this.tickSize,
    required this.scripMultiplier,
    required this.displayUnitMessage,
    required this.isIndice,
    required this.isEtf,
  });

  factory ScripInfo.fromPipeDelimited(String data) {
    final fields = data.split('|');
    if (fields.length != 22) {
      throw FormatException('Expected 22 fields, found ${fields.length}');
    }

    return ScripInfo(
      exch: fields[0],
      exchType: fields[1],
      scripCode: fields[2],
      symbol: fields[3],
      cpType: fields[4],
      marketLot: fields[5],
      series: fields[6],
      nsecode: fields[7],
      bsecode: fields[8],
      companyName: fields[9],
      description: fields[10],
      shortCode: fields[11],
      surveillanceIndicator: fields[12],
      mtfEnabled: fields[13],
      qtyLimit: fields[14],
      isSliceEnable: fields[15],
      expiry: fields[16],
      tickSize: fields[17],
      scripMultiplier: fields[18],
      displayUnitMessage: fields[19],
      isIndice: fields[20],
      isEtf: fields[21],
    );
  }

  Map<String, dynamic> toJson() => {
        'Exch': exch,
        'ExchType': exchType,
        'ScripCode': scripCode,
        'Symbol': symbol,
        'CPType': cpType,
        'MarketLot': marketLot,
        'Series': series,
        'Nsecode': nsecode,
        'Bsecode': bsecode,
        'Companyname': companyName,
        'Description': description,
        'ShortCode': shortCode,
        'SurveillanceIndicator': surveillanceIndicator,
        'MTFEnabled': mtfEnabled,
        'QtyLimit': qtyLimit,
        'IsSliceEnable': isSliceEnable,
        'Expiry': expiry,
        'TickSize': tickSize,
        'ScripMultiplier': scripMultiplier,
        'DisplayUnitMessage': displayUnitMessage,
        'Isindice': isIndice,
        'isETF': isEtf,
      };
}

List<CompanyModel> processSingleString(String rawData) {
  // Step 1: Split by the hash ('#') delimiter to separate records
  final records = rawData.split('#');

  List<CompanyModel> models = [];

  // Step 2: Iterate over each record and parse it
  int count = 1;
  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();
  for (final record in records) {
    count++;
    if (record.trim().isNotEmpty) {
      try {
        final m = CompanyModel.fromPipeDelimited(record);
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
  final result = processSingleString(rawData);

  result[149000].toJson().forEach((key, value) {
    print('$key: $value');
  });
  

  rss = ProcessInfo.currentRss;
  print('Memory used (RSS): ${rss ~/ (1024 * 1024)} MB');
}

class CompanyModel {
  final String exch;
  final String exchType;
  final String nseCode;
  final String bseCode;
  final String symbol;
  final double tickSize;
  final String series;
  final String companyName;
  final double scripMultiplier;
  final String displayUnitMessage;
  final String description;
  final String shortCode;
  final String surveillanceIndicator;
  final DateTime? expiry;
  final String? cpType;
  final int marketLot;
  final bool isSliceEnable;
  final int qtyLimit;
  final bool mtfEnabled;
  final String scripCode;
  final bool isIndice;
  final bool isEtf;

  const CompanyModel({
    required this.exch,
    required this.exchType,
    required this.nseCode,
    required this.bseCode,
    required this.symbol,
    required this.tickSize,
    required this.series,
    required this.companyName,
    required this.scripMultiplier,
    required this.displayUnitMessage,
    required this.description,
    required this.shortCode,
    required this.surveillanceIndicator,
    required this.expiry,
    required this.cpType,
    required this.marketLot,
    required this.isSliceEnable,
    required this.qtyLimit,
    required this.mtfEnabled,
    required this.scripCode,
    required this.isIndice,
    required this.isEtf,
  });

  factory CompanyModel.fromPipeDelimited(String data) {
    final fields = data.split('|');
    if (fields.length != 22) {
      throw FormatException(
          'Expected 22 fields, found ${fields.length} in $data');
    }

    return CompanyModel(
      exch: fields[0],
      exchType: fields[1],
      scripCode: fields[2],
      symbol: fields[3],
      cpType: fields[4].isEmpty ? null : fields[4],
      marketLot: int.tryParse(fields[5]) ?? 0,
      series: fields[6],
      nseCode: fields[7],
      bseCode: fields[8],
      companyName: fields[9],
      description: fields[10],
      shortCode: fields[11],
      surveillanceIndicator: fields[12],
      mtfEnabled: fields[13].toLowerCase() == 'true',
      qtyLimit: int.tryParse(fields[14]) ?? 0,
      isSliceEnable: fields[15].toLowerCase() == 'true',
      expiry: fields[16].isEmpty ? null : DateTime.tryParse(fields[16]),
      tickSize: double.tryParse(fields[17]) ?? 0.0,
      scripMultiplier: double.tryParse(fields[18]) ?? 1.0,
      displayUnitMessage: fields[19],
      isIndice: fields[20].toLowerCase() == 'true',
      isEtf: fields[21].toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() => {
        'Exch': exch,
        'ExchType': exchType,
        'ScripCode': scripCode,
        'Symbol': symbol,
        'CPType': cpType,
        'MarketLot': marketLot,
        'Series': series,
        'Companyname': companyName,
        'Description': description,
        'ShortCode': shortCode,
        'SurveillanceIndicator': surveillanceIndicator,
        'MTFEnabled': mtfEnabled,
        'QtyLimit': qtyLimit,
        'IsSliceEnable': isSliceEnable,
        'Expiry': expiry,
        'TickSize': tickSize,
        'ScripMultiplier': scripMultiplier,
        'DisplayUnitMessage': displayUnitMessage,
        'Isindice': isIndice,
        'isETF': isEtf,
      };
}
