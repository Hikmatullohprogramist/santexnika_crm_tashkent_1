 import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('USB Printing Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              generateAndPrintUsb(
                [
                  BasketModel(
                    store: Store(name: 'Store 1'),
                    quantity: '2',
                    basketPrice: [BasketPrice(agreedPrice: '1000')],
                  ),
                ],
                'John Doe',
                '+1234567890',
                '12345',
                [
                  SavedBasketModel(typeId: 1, priceId: 1, price: 1000.0),
                  SavedBasketModel(typeId: 2, priceId: 2, price: 500.0),
                ],
                1,
                2,
                1500.0,
                '2024-05-23 12:00:00',
                'Thank you!',
              );
            },
            child: Text('Print Receipt via USB'),
          ),
        ),
      ),
    );
  }
}

Future<void> generateAndPrintUsb(
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
  final profile = await CapabilityProfile.load();
  final printer = PrinterNetworkManager('192.168.123.100');

  final ticket = Generator(PaperSize.mm80, profile);

  ticket.text(
    'MUSAFFO SANTEXNIKA',
    styles: PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size2,
      width: PosTextSize.size2,
      bold: true,
    ),
  );
  ticket.text('Fergana, Margilan', styles: PosStyles(align: PosAlign.center));
  ticket.text('Tel: +998 (91) 282 76 61', styles: PosStyles(align: PosAlign.center));
  ticket.text('Chek raqam: $chekId', styles: PosStyles(align: PosAlign.center));
  ticket.text('Sana: ${formatDateWithHours(DateTime.now())}', styles: PosStyles(align: PosAlign.center));
  ticket.hr();

  double summa = 0;

  for (var product in productList) {
    final double agreedPrice = double.parse(product.basketPrice[0].agreedPrice);
    final double quantity = double.parse(product.quantity);
    final double total = agreedPrice * quantity;
    summa += total;

    ticket.text('${product.store.name ?? "N/A"} x ${product.quantity}', styles: PosStyles(bold: true));
    ticket.text('${agreedPrice.toString()} x ${product.quantity} = ${NumberFormat("#,###", "uz_UZ").format(total)}');
    ticket.hr();
  }

  for (var element in dataa) {
    ticket.text('${checkTradeType(element.typeId)} / ${checkPrice(element.priceId)} : ${element.price}');
  }

  if (zdachi != null) {
    ticket.text('Qaytim ${checkTradeType(zdachiType!)} / ${checkPrice(zdachiPriceId!)}: ${NumberFormat("#,###", "uz_UZ").format(zdachi)}');
  }

  ticket.text('Jami summa: ${NumberFormat("#,###", "uz_UZ").format(summa)}', styles: PosStyles(bold: true));
  ticket.hr();

  ticket.text('Mijoz: $client');
  ticket.text('Mijoz telefon raqami: $clientPhoneNumber');

  if (selectedDate != null && selectedDate.isNotEmpty) {
    ticket.text('To\'lash sanasi: ${formatDateWithHours(DateTime.parse(selectedDate))}');
  }

  if (comment != null && comment.isNotEmpty) {
    ticket.text('Izoh: $comment');
  }

  ticket.hr();
  ticket.text('Xaridingiz uchun rahmat. Yana kelib turing!', styles: PosStyles(align: PosAlign.center, bold: true));
  ticket.text('Cheksiz mahsulotlar qaytib olinmaydi!', styles: PosStyles(align: PosAlign.center, bold: true));

  ticket.cut();

  final PosPrintResult result = await printer.printTicket(ticket as List<int>);
  if (result == PosPrintResult.success) {
    print('Print success');
  } else {
    print('Print failed: ${result.msg}');
  }
}

// Helper functions
String formatDateWithHours(DateTime date) {
  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}

String checkTradeType(int typeId) {
  // Implement your logic to get the trade type based on the typeId
  return 'Trade Type $typeId';
}

String checkPrice(int priceId) {
  // Implement your logic to get the price type based on the priceId
  return 'Price Type $priceId';
}

class BasketModel {
  final Store store;
  final String quantity;
  final List<BasketPrice> basketPrice;

  BasketModel({
    required this.store,
    required this.quantity,
    required this.basketPrice,
  });
}

class Store {
  final String? name;

  Store({this.name});
}

class BasketPrice {
  final String agreedPrice;

  BasketPrice({required this.agreedPrice});
}

class SavedBasketModel {
  final int typeId;
  final int priceId;
  final double price;

  SavedBasketModel({
    required this.typeId,
    required this.priceId,
    required this.price,
  });
}
