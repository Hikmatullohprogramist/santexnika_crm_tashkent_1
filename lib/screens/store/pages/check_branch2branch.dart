import 'dart:developer';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import '../../../tools/format_date_time.dart';

Future<void> printBranchTransferCheck(
  List<String> productList,
  List<int> productAmounts,
  String fromBranch,
  String toBranch,
  String fromBranchUserName,
  String? transferDate,
) async {
  List<int> bytes = [];

  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  print("Print started");

  String fixedString = "FILIAL O'TKAZMA TEKSHIRIMI";

  print(productList.length);

  // Header Information
  bytes += generator.text(fixedString,
      styles: const PosStyles(
          bold: true, align: PosAlign.center, height: PosTextSize.size2));
  bytes += generator.text('Yuboruvchi: $fromBranch / $fromBranchUserName',
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text('Qabul qiluvchi: $toBranch',
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text('Sana: ${formatDateWithHours(DateTime.now())}',
      styles: const PosStyles(align: PosAlign.left));
  bytes += generator.text('------------------------------------------------');

  // Sales Items
  for (var i = 0; i < productList.length; i++) {
    bytes += generator.text(
      '${productList[i] ?? "N/A"} x ${productAmounts[i]}',
      styles: const PosStyles(
        align: PosAlign.left,
        width: PosTextSize.size1,
        height: PosTextSize.size1,
      ),
    );

    print('${productList[i] ?? "N/A"} x ${productAmounts[i]}');
    bytes += generator.text('------------------------------------------------');
  }

  // Additional Information
  if (transferDate != null && transferDate != "") {
    DateTime? parsedDate = DateTime.tryParse(transferDate);
    if (parsedDate != null) {
      bytes +=
          generator.text("Yuborish sanasi: ${formatDateWithHours(parsedDate)}",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));

      print("Yuborish sanasi: ${formatDateWithHours(parsedDate)}");
    } else {
      print("Noto‘g‘ri sana formati: $transferDate");
    }
  }

  // Auto-cut command
  bytes += generator.cut();

  try {
    final printer = PrinterNetworkManager('192.168.123.100');
    PosPrintResult connect = await printer.connect();

    if (connect == PosPrintResult.success) {
      PosPrintResult printing = await printer.printTicket(bytes);
      if (kDebugMode) {
        print(printing.msg);
      }
      printer.disconnect();
    }
  } catch (e) {
    log(e.toString());
  }
}
