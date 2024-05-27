// ignore_for_file: deprecated_member_use

import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as pr;
import 'package:santexnika_crm/tools/format_date_time.dart';
import 'package:santexnika_crm/tools/money_formatter.dart';

import '../../../../../models/basket/basket_model.dart';

Future<Future<bool>> printSalesCheck(
    BuildContext context,
    List<BasketModel> productList,
    String sotuvchi,
    String oluvchi,
    int chekId) async {
  return pr.Printing.layoutPdf(
    onLayout: (format) =>
        _generateSalesCheckPdf(format, productList, sotuvchi, oluvchi, chekId),
  );
}

pw.Widget titleMedium(String text, pw.Font font) => pw.Text(
      text,
      style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold, fontSize: 23, font: font),
    );
Future<Uint8List> _generateSalesCheckPdf(
  PdfPageFormat format,
  List<BasketModel> productList,
  String sotuvchi,
  String oluvchi,
  int chekId,
) async {
  double allPrice = 0.0;
  final pdf = pw.Document();
  final font400 = await rootBundle.load("font/inter/Inter-Regular.ttf");
  final font600 = await rootBundle.load("font/inter/Inter-SemiBold.ttf");
  final ttf400 = pw.Font.ttf(font400);
  final ttf600 = pw.Font.ttf(font600);
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Container(
          width: double.infinity,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Nakladnoy: #$chekId',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Sotuvchi: $sotuvchi',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Oluvchi: $oluvchi',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    titleMedium("техтr", ttf400),
                  ]),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
                data: productList.map((sale) {
                  double agreedPrice =
                      double.parse(sale.basketPrice[0].agreedPrice.toString());
                  double quantity = double.parse(sale.quantity.toString());
                  allPrice = agreedPrice * quantity;

                  print(allPrice);
                  return [
                    sale.store.name,
                    sale.quantity.toString(),
                    moneyFormatter(double.parse(
                        sale.basketPrice[0].agreedPrice.toString())),
                    (
                      NumberFormat("##,###", "uz_UZ").format(
                        double.parse(sale.basketPrice[0].agreedPrice) *
                            double.tryParse(sale.quantity)!,
                      ),
                    ),
                  ];
                }).toList(),
                border: pw.TableBorder.all(),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Jami summa: ${moneyFormatter(allPrice)}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(
                """
DIQQAT!
Mahsulotni sotuvchidan sotuvchiga berishdan so'ng, keyinchalik mahsulotning javobi to'liq ravishda xaridorga tegishli. Mahsulotni qaytarish, mahsulotda zarar yoki buzilma belgilari yo'qligida mumkin!
Mahsulotni qaytarishda, mahsulotning iste'dodining qolgan vaqtini yodda tutishni so'raymiz!
"SOBSAN, MASTER, CHROME, UNUKA, TYTAN, POLIFIX va ARTELIT" mahsulotlari quyidagi shartlar asosida qabul qilinadi:
Qolgan iste'dod muddati:
3 oy - mahsulotning narxidan 10%gacha;
2 oy - mahsulotning narxidan 20%gacha;
1 oy - mahsulotning narxidan 30%gacha;

Muddati o'tgan mahsulotlar:
"TYTAN, POLIFIX va ARTELIT" - qabul qilinmaydi
"SOBSAN, MASTER, CHROME, UNUKA" - mahsulotning narxidan 40%gacha
""",
              ),
              pw.Center(child: pw.Text(formatDateWithHours(DateTime.now()))),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}
