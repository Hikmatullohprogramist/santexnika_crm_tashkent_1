import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> printLabels(String productName, String barcode) async {
  final pdf = pw.Document(
    pageMode: PdfPageMode.thumbs,
  );

  print("WIZ ${75 * PdfPageFormat.mm}");
  print("HEIGHT ${40 * PdfPageFormat.mm}");

  pdf.addPage(
    pw.Page(
      pageFormat:
          const PdfPageFormat(75 * PdfPageFormat.mm, 40 * PdfPageFormat.mm),
      build: (pw.Context context) {
        return pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(5),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 1),
              borderRadius: pw.BorderRadius.circular(2), // Rounded corners
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  productName,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                // Barcode
                pw.BarcodeWidget(
                    barcode: pw.Barcode.fromType(pw.BarcodeType.Code128),
                    // Example of Code 39 barcode
                    data: barcode,
                    height: 50,
                    width: 50 * PdfPageFormat.mm,
                    textStyle: pw.TextStyle(fontSize: 18)),
              ],
            ),
          ),
        );
      },
    ),
  );

  // Print the label
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async {
      print("Dimension  X ${format.dimension.x}");
      print("Dimension  Y ${format.dimension.y}");
      print("Avaible dimension ${format.availableDimension.x}");
      return pdf.save();
    },
  );
}
