import 'dart:developer';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:santexnika_crm/models/basket/basket_model.dart';
import 'package:santexnika_crm/models/basket/save_basket_model.dart';
import 'package:santexnika_crm/tools/check_price.dart';
import 'package:santexnika_crm/tools/check_trade_type.dart';
import 'package:santexnika_crm/tools/constantas.dart';
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> printAwesomeSalesCheck(
    List<BasketModel> productList,
    String client,
    String clientPhoneNumber,
    String chekId,
    List<SavedBasketModel> dataa,
    int? zdachiType,
    int? zdachiPriceId,
    double? zdachi,
    String? selectedDate,
    String? comment,
    {bool isLan = true}) async {
  generatePdf(productList, client, clientPhoneNumber, chekId, dataa, zdachiType,
      zdachiPriceId, zdachi, selectedDate, comment);
  double summa = 0;
  print(productList.length);
  List<int> bytes = [];
  final profile = await CapabilityProfile.load();

  final generator = Generator(PaperSize.mm80, profile);

  // Header with logo (replace 'path/to/logo.png' with the actual path to your logo)
  bytes += generator.text(AppConstants.currentBranch,
      styles: const PosStyles(
          bold: false, align: PosAlign.center, height: PosTextSize.size2));
  // bytes += generator.text('123 Awesome Street',
  //     styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text('Fergana, Margilan',
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text('Tel: +998 (91) 282 76 61',
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text('Chek raqam: $chekId',
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text('Sana: ${formatDateWithHours(DateTime.now())}',
      styles: const PosStyles(
        align: PosAlign.center,
      ));
  bytes += generator.text('------------------------------------------------');
  int index = 1;
  // Sales Items
  for (var product in productList) {
    bytes += generator.text(
      '$index. ${product.store.name ?? "N/A"} x ${product.quantity}      ',
      styles: const PosStyles(
        align: PosAlign.left,
        width: PosTextSize.size1,
        height: PosTextSize.size1,
      ),
    );
    bytes += generator.text(
      '   ${double.parse(product.basketPrice[0].agreedPrice)} x ${product.quantity} = ${NumberFormat("##,###", "uz_UZ").format(double.parse(product.basketPrice[0].agreedPrice) * double.tryParse(product.quantity)!)}       ',
      styles: const PosStyles(
        align: PosAlign.right,
        width: PosTextSize.size1,
        height: PosTextSize.size1,
      ),
    );

    print(
      '   ${double.parse(product.basketPrice[0].agreedPrice)} x ${product.quantity} = ${NumberFormat("#,###", "uz_UZ").format(double.parse(product.basketPrice[0].agreedPrice) * double.tryParse(product.quantity)!)}       ',
    );

    bytes += generator.text('------------------------------------------------');

    summa += double.parse(product.basketPrice[0].agreedPrice) *
        double.parse(product.quantity);

    index++;
  }
  if (kDebugMode) {
    print(
      '   $summa     ',
    );
  }

  // Total
  for (var element in dataa) {
    bytes += generator.text(
      ' ${checkTradeType(element.typeId)} /  ${checkPrice(element.priceId)} : ${element.price}',
      styles: const PosStyles(
        align: PosAlign.right,
        width: PosTextSize.size1,
        height: PosTextSize.size1,
      ),
    );
    if (kDebugMode) {
      print(
          "${checkTradeType(element.typeId)} /  ${checkPrice(element.priceId)} : ${element.price}");
    }
  }
  if (zdachi != null) {
    bytes += generator.text(
      'Qaytim ${checkTradeType(zdachiType!)} / ${checkPrice(zdachiPriceId!)}:',
      styles: const PosStyles(
        align: PosAlign.left,
        width: PosTextSize.size1,
        height: PosTextSize.size1,
      ),
    );
    bytes += generator.text(
      '  ${NumberFormat("#,###", "uz_UZ").format(zdachi)}',
      styles: const PosStyles(
        align: PosAlign.right,
        width: PosTextSize.size1,
        height: PosTextSize.size1,
      ),
    );

    if (kDebugMode) {
      print(
        "Qaytim ${checkTradeType(zdachiType)} / ${checkPrice(zdachiPriceId)}: ${NumberFormat("#,###", "uz_UZ").format(zdachi)}",
      );
    }
  }
  bytes += generator.text('Jami summa:',
      styles: const PosStyles(
          align: PosAlign.left,
          width: PosTextSize.size1,
          height: PosTextSize.size1));
  bytes += generator.text(
    '  ${NumberFormat("#,###", "uz_UZ").format(summa)}',
    styles: const PosStyles(
      align: PosAlign.right,
      width: PosTextSize.size1,
      height: PosTextSize.size1,
    ),
  );
  // bytes += generator.text('----------------------');

  // Additional information
  bytes += generator.text(
    'Mijoz:$client',
    styles: const PosStyles(
      align: PosAlign.left,
    ),
  );
  bytes += generator.text(
    'Mijoz telefon raqami: $clientPhoneNumber',
    styles: const PosStyles(
      align: PosAlign.left,
    ),
  );
  if (selectedDate != null && selectedDate != "") {
    if (kDebugMode) {
      print("DATE TIME $selectedDate");
    }
    DateTime? parsedDate = DateTime.tryParse(selectedDate);
    if (parsedDate != null) {
      print("To'lash sanasi : ${formatDateWithHours(parsedDate)}");
      bytes +=
          generator.text("To'lash sanasi : ${formatDateWithHours(parsedDate)}",
              styles: const PosStyles(
                align: PosAlign.center,
                bold: true,
              ));
    } else {
      print("Invalid date format: $selectedDate");
    }
  }
  if (comment != null && comment != "") {
    if (kDebugMode) {
      print("DATE TIME $selectedDate");
    }
    print("Comment : ${comment}");
    bytes += generator.text("Izoh : $comment",
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
        ));
  }
  // bytes += generator.text('Tolov sanasi:${formatDate(DateTime.now())}',
  //     styles: const PosStyles(align: PosAlign.left));
  // bytes += generator.text('');

  bytes += generator.text('Xaridingiz uchun rahmat. Yana kelib turing!',
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.text(
    'Cheksiz mahsulotlar qaytib olinmaydi !',
    styles: const PosStyles(
      align: PosAlign.center,
      bold: true,
    ),
  );
  if (kDebugMode) {
    print("CHECK ID $chekId");
  }
  // Add auto-cut command
  bytes += generator.cut();

  try {
    final printer = PrinterNetworkManager('192.168.123.100');

    PosPrintResult connect = await printer.connect();

    if (connect == PosPrintResult.success) {
      PosPrintResult printing = await printer.printTicket(bytes);
      // final printingUsb = await printerManager.usbPrinterConnector.send(bytes);

      if (kDebugMode) {
        print(printing.msg);
      }
      if (kDebugMode) {
        print("SUCCESS PRINTEED ================>");
      }
      // print(usbPrinting.msg);

      printer.disconnect();
    }
  } catch (e) {
    log(e.toString());
  }
}

// Future<Uint8List> generatePdf(
//     List<BasketModel> productList,
//     String client,
//     String clientPhoneNumber,
//     String chekId,
//     List<SavedBasketModel> dataa,
//     int? zdachiType,
//     int? zdachiPriceId,
//     double? zdachi,
//     String? selectedDate,
//     String? comment,
//     ) async {
//   // Create a PDF document
//   final pdf = pw.Document();
//
//   // Add content to the PDF
//   pdf.addPage(
//
//     pw.Page(
//       pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, double.infinity),
//       build: (pw.Context context) {
//         double summa = 0;
//
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Header
//             pw.Text('MUSAFFO SANTEXNIKA',
//                 style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     fontSize: 20,
//                      )),
//             pw.SizedBox(height: 10),
//             pw.Text('Fergana, Margilan',
//                 style: pw.TextStyle(fontSize: 16,  )),
//             pw.Text('Tel: +998 (91) 282 76 61',
//                 style: pw.TextStyle(fontSize: 16, )),
//             pw.Text('Chek raqam: $chekId',
//                 style: pw.TextStyle(fontSize: 16,  )),
//             pw.Text('Sana: ${formatDateWithHours(DateTime.now())}',
//                 style: pw.TextStyle(fontSize: 16,  )),
//             pw.Divider(),
//
//             // Sales Items
//             for (var product in productList)
//
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                       '${product.store.name ?? "N/A"} x ${product.quantity}',
//                       style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
//                   pw.Text(
//                       '${double.parse(product.basketPrice[0].agreedPrice)} x ${product.quantity} = ${NumberFormat("#,###", "uz_UZ").format(double.parse(product.basketPrice[0].agreedPrice) * double.parse(product.quantity))}',
//                       style: pw.TextStyle(fontSize: 16,  )),
//                   pw.Divider(),
//                 ],
//               ),
//
//             // Total
//             pw.Text('Jami summa: ${NumberFormat("#,###", "uz_UZ").format(summa)}',
//                 style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
//             pw.Divider(),
//
//             // Additional information
//             pw.Text('Mijoz: $client', style: pw.TextStyle(fontSize: 16)),
//             pw.Text('Mijoz telefon raqami: $clientPhoneNumber',
//                 style: pw.TextStyle(fontSize: 16)),
//             if (selectedDate != null && selectedDate != "")
//               pw.Text('To\'lash sanasi: ${formatDateWithHours(DateTime.parse(selectedDate))}',
//                   style: pw.TextStyle(fontSize: 16)),
//             if (comment != null && comment != "")
//               pw.Text('Izoh: $comment', style: pw.TextStyle(fontSize: 16)),
//
//             // Footer
//             pw.Text('Xaridingiz uchun rahmat. Yana kelib turing!',
//                 style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//                 textAlign: pw.TextAlign.center),
//             pw.Text('Cheksiz mahsulotlar qaytib olinmaydi !',
//                 style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//                 textAlign: pw.TextAlign.center),
//           ],
//         );
//       },
//     ),
//   );
//
//   // Save the PDF document to bytes
//
//   await Printing.layoutPdf(
//      onLayout: (_)async => pdf.save(),
//   );
//   return pdf.save();
// }
Future<Uint8List> generatePdf(
  List<BasketModel> productList,
  String client,
  String clientPhoneNumber,
  String chekId,
  List<SavedBasketModel> dataa,
  int? zdachiType,
  int? zdachiPriceId,
  double? zdachi,
  String? selectedDate,
  String? comment,
) async {
  // Create a PDF document
  final pdf = pw.Document();

  // Add content to the PDF
  pdf.addPage(
    pw.Page(
      pageFormat: const PdfPageFormat(58 * PdfPageFormat.mm, double.infinity),
      build: (pw.Context context) {
        double summa = productList.fold(
          0,
          (previousValue, product) =>
              previousValue +
              double.parse(product.basketPrice[0].agreedPrice) *
                  double.parse(product.quantity),
        );

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with logo
            pw.Column(
              children: [
                pw.Text(
                  AppConstants.currentBranch,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Fergana, Margilan',
                  style: const pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  'Tel: +998 (91) 282 76 61',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Chek raqam: $chekId',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              'Sana: ${formatDateWithHours(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Divider(),

            // Sales Items
            for (var product in productList)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${product.store.name ?? "N/A"} x ${product.quantity}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    '${double.parse(product.basketPrice[0].agreedPrice)} x ${product.quantity} = ${NumberFormat("#,###", "uz_UZ").format(double.parse(product.basketPrice[0].agreedPrice) * double.parse(product.quantity))}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Divider(height: 2),
                ],
              ),

            // Total
            pw.Text(
              'Jami summa: ${NumberFormat("#,###", "uz_UZ").format(summa)}',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Divider(height: 2),

            // Additional information
            pw.Text(
              'Mijoz: $client',
              style: const pw.TextStyle(fontSize: 10),
            ),

            if (client != "")
              pw.Text(
                'Mijoz telefon raqami: $clientPhoneNumber',
                style: const pw.TextStyle(fontSize: 10),
              ),
            if (selectedDate != null && selectedDate.isNotEmpty)
              pw.Text(
                'To\'lash sanasi: ${formatDateWithHours(DateTime.parse(selectedDate))}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            if (comment != null && comment.isNotEmpty)
              pw.Text(
                'Izoh: $comment',
                style: const pw.TextStyle(fontSize: 10),
              ),
            // Additional data
            for (var element in dataa)
              pw.Text(
                '${checkTradeType(element.typeId)} /  ${checkPrice(element.priceId)} : ${element.price}',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            if (zdachi != null)
              pw.Text(
                'Qaytim ${checkTradeType(zdachiType!)} / ${checkPrice(zdachiPriceId!)}: ${NumberFormat("#,###", "uz_UZ").format(zdachi)}',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

            // Footer
            pw.SizedBox(height: 10),
            pw.Text(
              'Xaridingiz uchun rahmat\nYana kelib turing!',
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.left,
            ),
            pw.Text(
              'Cheksiz mahsulotlar qaytib olinmaydi!',
              style: pw.TextStyle(
                fontSize: 7,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.left,
            ),

            pw.SizedBox(height: 100),
          ],
        );
      },
    ),
  );

  // Save the PDF document to bytes
  await Printing.layoutPdf(
    onLayout: (_) async => pdf.save(),
  );
  return pdf.save();
}
