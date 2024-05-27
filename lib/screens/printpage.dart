// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
// import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';

// // import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
// import 'package:intl/intl.dart';
// import 'package:santexnika_crm/models/pruduct/productModel.dart';

// void main() {
//   runApp(const PrintPage(client: "JABBERER"));
// }

// class PrintPage extends StatefulWidget {
//   final String client;

//   const PrintPage({Key? key, required this.client}) : super(key: key);

//   @override
//   State<PrintPage> createState() => _PrintPageState();
// }

// class _PrintPageState extends State<PrintPage> {
//   // Printer Type [bluetooth, usb, network]
//   var defaultPrinterType = PrinterType.bluetooth;
//   var _isBle = false;
//   var _reconnect = false;
//   var _isConnected = false;
//   var printerManager = PrinterManager.instance;
//   var devices = <BluetoothPrinter>[];
//   StreamSubscription<PrinterDevice>? _subscription;
//   StreamSubscription<BTStatus>? _subscriptionBtStatus;
//   StreamSubscription<USBStatus>? _subscriptionUsbStatus;
//   BTStatus _currentStatus = BTStatus.none;

//   // _currentUsbStatus is only supports on Android
//   // ignore: unused_field
//   USBStatus _currentUsbStatus = USBStatus.none;
//   List<int>? pendingTask;
//   String _ipAddress = '';
//   String _port = '9100';
//   final _ipController = TextEditingController();
//   final _portController = TextEditingController();
//   BluetoothPrinter? selectedPrinter;
//   List<ProductModel> productList = [];
//   final DateFormat formatterDate = DateFormat('yyyy-MM-dd,HH:mm');
//   int summa = 0;

//   getData() async {
//     productList = [
//       ProductModel(
//         quantity: "10",
//         price: Price(name: "NAMEE", createdAt: "NOW", updatedAt: "TODaY"),
//         priceCome: "12122121",
//         priceId: 1,
//         priceSell: "123123",
//         priceWholesale: 123123213,
//         dangerCount: "123",
//       ),
//       ProductModel(
//         quantity: "10",
//         price: Price(name: "NAMEE", createdAt: "NOW", updatedAt: "TODaY"),
//         priceCome: "12122121",
//         priceId: 1,
//         priceSell: "123123",
//         priceWholesale: 123123213,
//         dangerCount: "123",
//       ),
//       ProductModel(
//         quantity: "10",
//         price: Price(name: "NAMEE", createdAt: "NOW", updatedAt: "TODaY"),
//         priceCome: "12122121",
//         priceId: 1,
//         priceSell: "123123",
//         priceWholesale: 123123213,
//         dangerCount: "123",
//       ),
//       ProductModel(
//         quantity: "10",
//         price: Price(name: "NAMEE", createdAt: "NOW", updatedAt: "TODaY"),
//         priceCome: "12122121",
//         priceId: 1,
//         priceSell: "123123",
//         priceWholesale: 123123213,
//         dangerCount: "123",
//       ),
//       ProductModel(
//         quantity: "10",
//         price: Price(name: "NAMEE", createdAt: "NOW", updatedAt: "TODaY"),
//         priceCome: "12122121",
//         priceId: 1,
//         priceSell: "123123",
//         priceWholesale: 123123213,
//         dangerCount: "123",
//       ),
//     ];
//   }

//   @override
//   void initState() {
//     getData();
//     productList.forEach((element) {
//       summa =
//           summa + int.parse(element.priceSell!) * int.parse(element.quantity!);
//     });
//     if (Platform.isWindows) defaultPrinterType = PrinterType.usb;
//     super.initState();
//     _portController.text = _port;
//     _scan();

//     // subscription to listen change status of bluetooth connection
//     _subscriptionBtStatus =
//         PrinterManager.instance.stateBluetooth.listen((status) {
//       log(' ----------------- status bt $status ------------------ ');
//       _currentStatus = status;
//       if (status == BTStatus.connected) {
//         setState(() {
//           _isConnected = true;
//         });
//       }
//       if (status == BTStatus.none) {
//         setState(() {
//           _isConnected = false;
//         });
//       }
//       if (status == BTStatus.connected && pendingTask != null) {
//         if (Platform.isAndroid) {
//           Future.delayed(const Duration(milliseconds: 1000), () {
//             PrinterManager.instance
//                 .send(type: PrinterType.bluetooth, bytes: pendingTask!);
//             pendingTask = null;
//           });
//         } else if (Platform.isIOS) {
//           PrinterManager.instance
//               .send(type: PrinterType.bluetooth, bytes: pendingTask!);
//           pendingTask = null;
//         }
//       }
//     });
//     //  PrinterManager.instance.stateUSB is only supports on Android
//     _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
//       log(' ----------------- status usb $status ------------------ ');
//       _currentUsbStatus = status;
//       if (Platform.isAndroid) {
//         if (status == USBStatus.connected && pendingTask != null) {
//           Future.delayed(const Duration(milliseconds: 1000), () {
//             PrinterManager.instance
//                 .send(type: PrinterType.usb, bytes: pendingTask!);
//             pendingTask = null;
//           });
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     _subscriptionBtStatus?.cancel();
//     _subscriptionUsbStatus?.cancel();
//     _portController.dispose();
//     _ipController.dispose();
//     super.dispose();
//   }

//   // method to scan devices according PrinterType
//   void _scan() {
//     devices.clear();
//     _subscription = printerManager
//         .discovery(type: defaultPrinterType, isBle: _isBle)
//         .listen((device) {
//       devices.add(BluetoothPrinter(
//         deviceName: device.name,
//         address: device.address,
//         isBle: _isBle,
//         vendorId: device.vendorId,
//         productId: device.productId,
//         typePrinter: defaultPrinterType,
//       ));
//       setState(() {});
//     });
//   }

//   void setPort(String value) {
//     if (value.isEmpty) value = '9100';
//     _port = value;
//     var device = BluetoothPrinter(
//       deviceName: value,
//       address: _ipAddress,
//       port: _port,
//       typePrinter: PrinterType.network,
//       state: false,
//     );
//     selectDevice(device);
//   }

//   void setIpAddress(String value) {
//     _ipAddress = value;
//     var device = BluetoothPrinter(
//       deviceName: value,
//       address: _ipAddress,
//       port: _port,
//       typePrinter: PrinterType.network,
//       state: false,
//     );
//     selectDevice(device);
//   }

//   void selectDevice(BluetoothPrinter device) async {
//     if (selectedPrinter != null) {
//       if ((device.address != selectedPrinter!.address) ||
//           (device.typePrinter == PrinterType.usb &&
//               selectedPrinter!.vendorId != device.vendorId)) {
//         await PrinterManager.instance
//             .disconnect(type: selectedPrinter!.typePrinter);
//       }
//     }

//     selectedPrinter = device;
//     setState(() {});
//   }

//   Future _printReceiveTest() async {
//     List<int> bytes = [];

//     // Xprinter XP-N160I
//     final profile = await CapabilityProfile.load(name: 'XP-N160I');

//     // PaperSize.mm80 or PaperSize.mm58
//     final generator = Generator(PaperSize.mm80, profile);
//     bytes += generator.text(widget.client);
//     bytes += generator.emptyLines(2);
//     bytes += generator.row([
//       PosColumn(
//           text: "Sana va vaqt",
//           width: 8,
//           styles: const PosStyles(
//               align: PosAlign.left,
//               fontType: PosFontType.fontA,
//               height: PosTextSize.size2)),
//       PosColumn(
//           text: formatterDate.format(DateTime.now()),
//           width: 4,
//           styles: const PosStyles(
//               align: PosAlign.right,
//               fontType: PosFontType.fontA,
//               height: PosTextSize.size2)),
//     ]);
//     bytes += generator.emptyLines(1);
//     productList.forEach((element) {
//       bytes += generator.text(element.name!,
//           styles: const PosStyles(
//               align: PosAlign.left,
//               fontType: PosFontType.fontA,
//               height: PosTextSize.size2));
//       bytes += generator.row([
//         PosColumn(
//             text:
//                 "${element.quantity!}x${NumberFormat("#,###", "en_US").format((element.price))}",
//             width: 8,
//             styles: const PosStyles(
//                 align: PosAlign.left,
//                 fontType: PosFontType.fontA,
//                 height: PosTextSize.size2)),
//         PosColumn(
//             text: NumberFormat("#,###", "en_US")
//                 .format((element.priceSell! * int.parse(element.quantity!)))
//                 .toString(),
//             width: 4,
//             styles: const PosStyles(
//                 align: PosAlign.right,
//                 fontType: PosFontType.fontA,
//                 height: PosTextSize.size2)),
//       ]);
//       bytes +=
//           generator.text('------------------------------------------------');
//     });
//     bytes += generator.row([
//       PosColumn(
//           text: "Jami umumiy summa:",
//           width: 8,
//           styles: const PosStyles(
//               align: PosAlign.left,
//               fontType: PosFontType.fontA,
//               height: PosTextSize.size2)),
//       PosColumn(
//           text: NumberFormat("#,###", "en_US").format(summa).toString(),
//           width: 4,
//           styles: const PosStyles(
//               align: PosAlign.right,
//               fontType: PosFontType.fontA,
//               height: PosTextSize.size2)),
//     ]);

//     _printEscPos(bytes, generator);
//   }

//   /// print ticket
//   void _printEscPos(List<int> bytes, Generator generator) async {
//     if (selectedPrinter == null) return;
//     var bluetoothPrinter = selectedPrinter!;

//     switch (bluetoothPrinter.typePrinter) {
//       case PrinterType.usb:
//         bytes += generator.feed(2);
//         bytes += generator.cut();
//         await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: UsbPrinterInput(
//                 name: bluetoothPrinter.deviceName,
//                 productId: bluetoothPrinter.productId,
//                 vendorId: bluetoothPrinter.vendorId));
//         pendingTask = null;
//         break;
//       case PrinterType.bluetooth:
//         bytes += generator.cut();
//         await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: BluetoothPrinterInput(
//                 name: bluetoothPrinter.deviceName,
//                 address: bluetoothPrinter.address!,
//                 isBle: bluetoothPrinter.isBle ?? false,
//                 autoConnect: _reconnect));
//         pendingTask = null;
//         if (Platform.isAndroid) pendingTask = bytes;
//         break;
//       case PrinterType.network:
//         bytes += generator.feed(2);
//         bytes += generator.cut();
//         await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
//         break;
//       default:
//     }
//     if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
//         Platform.isAndroid) {
//       if (_currentStatus == BTStatus.connected) {
//         printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
//         pendingTask = null;
//       }
//     } else {
//       printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
//     }
//   }

//   // conectar dispositivo
//   _connectDevice() async {
//     _isConnected = false;
//     if (selectedPrinter == null) return;
//     switch (selectedPrinter!.typePrinter) {
//       case PrinterType.usb:
//         await printerManager.connect(
//             type: selectedPrinter!.typePrinter,
//             model: UsbPrinterInput(
//                 name: selectedPrinter!.deviceName,
//                 productId: selectedPrinter!.productId,
//                 vendorId: selectedPrinter!.vendorId));
//         _isConnected = true;
//         break;
//       case PrinterType.bluetooth:
//         await printerManager.connect(
//             type: selectedPrinter!.typePrinter,
//             model: BluetoothPrinterInput(
//                 name: selectedPrinter!.deviceName,
//                 address: selectedPrinter!.address!,
//                 isBle: selectedPrinter!.isBle ?? false,
//                 autoConnect: _reconnect));
//         break;
//       case PrinterType.network:
//         await printerManager.connect(
//             type: selectedPrinter!.typePrinter,
//             model: TcpPrinterInput(ipAddress: selectedPrinter!.address!));
//         _isConnected = true;
//         break;
//       default:
//     }

//     setState(() {});
//   }

//   final printer = PrinterNetworkManager('192.168.100.123');

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         floatingActionButton: FloatingActionButton(onPressed: () async {
//           printTicket();
//         }),
//         appBar: AppBar(
//           title: const Text('Flutter Pos Plugin Platform example app'),
//         ),
//         // body: Center(
//         //   child: Container(
//         //     height: double.infinity,
//         //     constraints: const BoxConstraints(maxWidth: 400),
//         //     child: SingleChildScrollView(
//         //       padding: EdgeInsets.zero,
//         //       child: Column(
//         //         children: [
//         //           Padding(
//         //             padding: const EdgeInsets.all(8.0),
//         //             child: Row(
//         //               children: [
//         //                 Expanded(
//         //                   child: ElevatedButton(
//         //                     onPressed: selectedPrinter == null || _isConnected
//         //                         ? null
//         //                         : () {
//         //                             _connectDevice();
//         //                           },
//         //                     child: const Text(
//         //                       "Connect",
//         //                       textAlign: TextAlign.center,
//         //                     ),
//         //                   ),
//         //                 ),
//         //                 const SizedBox(width: 8),
//         //                 Expanded(
//         //                   child: ElevatedButton(
//         //                     onPressed: selectedPrinter == null || !_isConnected
//         //                         ? null
//         //                         : () {
//         //                             if (selectedPrinter != null) {
//         //                               printerManager.disconnect(
//         //                                   type: selectedPrinter!.typePrinter);
//         //                             }
//         //                             setState(() {
//         //                               _isConnected = false;
//         //                             });
//         //                           },
//         //                     child: const Text("Disconnect",
//         //                         textAlign: TextAlign.center),
//         //                   ),
//         //                 ),
//         //               ],
//         //             ),
//         //           ),
//         //           DropdownButtonFormField<PrinterType>(
//         //             value: defaultPrinterType,
//         //             decoration: const InputDecoration(
//         //               prefixIcon: Icon(
//         //                 Icons.print,
//         //                 size: 24,
//         //               ),
//         //               labelText: "Type Printer Device",
//         //               labelStyle: TextStyle(fontSize: 18.0),
//         //               focusedBorder: InputBorder.none,
//         //               enabledBorder: InputBorder.none,
//         //             ),
//         //             items: <DropdownMenuItem<PrinterType>>[
//         //               if (Platform.isAndroid || Platform.isIOS)
//         //                 const DropdownMenuItem(
//         //                   value: PrinterType.bluetooth,
//         //                   child: Text("bluetooth"),
//         //                 ),
//         //               if (Platform.isAndroid || Platform.isWindows)
//         //                 const DropdownMenuItem(
//         //                   value: PrinterType.usb,
//         //                   child: Text("usb"),
//         //                 ),
//         //               const DropdownMenuItem(
//         //                 value: PrinterType.network,
//         //                 child: Text("Wifi"),
//         //               ),
//         //             ],
//         //             onChanged: (PrinterType? value) {
//         //               setState(() {
//         //                 if (value != null) {
//         //                   setState(() {
//         //                     defaultPrinterType = value;
//         //                     selectedPrinter = null;
//         //                     _isBle = false;
//         //                     _isConnected = false;
//         //                     _scan();
//         //                   });
//         //                 }
//         //               });
//         //             },
//         //           ),
//         //           Visibility(
//         //             visible: defaultPrinterType == PrinterType.bluetooth &&
//         //                 Platform.isAndroid,
//         //             child: SwitchListTile.adaptive(
//         //               contentPadding:
//         //                   const EdgeInsets.only(bottom: 20.0, left: 20),
//         //               title: const Text(
//         //                 "This device supports ble (low energy)",
//         //                 textAlign: TextAlign.start,
//         //                 style: TextStyle(fontSize: 19.0),
//         //               ),
//         //               value: _isBle,
//         //               onChanged: (bool? value) {
//         //                 setState(() {
//         //                   _isBle = value ?? false;
//         //                   _isConnected = false;
//         //                   selectedPrinter = null;
//         //                   _scan();
//         //                 });
//         //               },
//         //             ),
//         //           ),
//         //           Visibility(
//         //             visible: defaultPrinterType == PrinterType.bluetooth &&
//         //                 Platform.isAndroid,
//         //             child: SwitchListTile.adaptive(
//         //               contentPadding:
//         //                   const EdgeInsets.only(bottom: 20.0, left: 20),
//         //               title: const Text(
//         //                 "reconnect",
//         //                 textAlign: TextAlign.start,
//         //                 style: TextStyle(fontSize: 19.0),
//         //               ),
//         //               value: _reconnect,
//         //               onChanged: (bool? value) {
//         //                 setState(() {
//         //                   _reconnect = value ?? false;
//         //                 });
//         //               },
//         //             ),
//         //           ),
//         //           Column(
//         //               children: devices
//         //                   .map(
//         //                     (device) => ListTile(
//         //                       title: Text('${device.deviceName}'),
//         //                       subtitle: Platform.isAndroid &&
//         //                               defaultPrinterType == PrinterType.usb
//         //                           ? null
//         //                           : Visibility(
//         //                               visible: !Platform.isWindows,
//         //                               child: Text("${device.address}")),
//         //                       onTap: () {
//         //                         // do something
//         //                         selectDevice(device);
//         //                       },
//         //                       leading: selectedPrinter != null &&
//         //                               ((device.typePrinter == PrinterType.usb &&
//         //                                           Platform.isWindows
//         //                                       ? device.deviceName ==
//         //                                           selectedPrinter!.deviceName
//         //                                       : device.vendorId != null &&
//         //                                           selectedPrinter!.vendorId ==
//         //                                               device.vendorId) ||
//         //                                   (device.address != null &&
//         //                                       selectedPrinter!.address ==
//         //                                           device.address))
//         //                           ? const Icon(
//         //                               Icons.check,
//         //                               color: Colors.green,
//         //                             )
//         //                           : null,
//         //                       trailing: OutlinedButton(
//         //                         onPressed: selectedPrinter == null ||
//         //                                 device.deviceName !=
//         //                                     selectedPrinter?.deviceName
//         //                             ? null
//         //                             : () async {
//         //                                 _printReceiveTest();
//         //                               },
//         //                         child: const Padding(
//         //                           padding: EdgeInsets.symmetric(
//         //                               vertical: 2, horizontal: 20),
//         //                           child: Text("Print test ticket",
//         //                               textAlign: TextAlign.center),
//         //                         ),
//         //                       ),
//         //                     ),
//         //                   )
//         //                   .toList()),
//         //           Visibility(
//         //             visible: defaultPrinterType == PrinterType.network &&
//         //                 Platform.isWindows &&
//         //                 Platform.isAndroid,
//         //             child: Padding(
//         //               padding: const EdgeInsets.only(top: 10.0),
//         //               child: TextFormField(
//         //                 controller: _ipController,
//         //                 keyboardType:
//         //                     const TextInputType.numberWithOptions(signed: true),
//         //                 decoration: const InputDecoration(
//         //                   label: Text("Ip Address"),
//         //                   prefixIcon: Icon(Icons.wifi, size: 24),
//         //                 ),
//         //                 onChanged: setIpAddress,
//         //               ),
//         //             ),
//         //           ),
//         //           Visibility(
//         //             visible: defaultPrinterType == PrinterType.network &&
//         //                 Platform.isWindows &&
//         //                 Platform.isAndroid,
//         //             child: Padding(
//         //               padding: const EdgeInsets.only(top: 10.0),
//         //               child: TextFormField(
//         //                 controller: _portController,
//         //                 keyboardType:
//         //                     const TextInputType.numberWithOptions(signed: true),
//         //                 decoration: const InputDecoration(
//         //                   label: Text("Port"),
//         //                   prefixIcon: Icon(Icons.numbers_outlined, size: 24),
//         //                 ),
//         //                 onChanged: setPort,
//         //               ),
//         //             ),
//         //           ),
//         //           Visibility(
//         //             visible: defaultPrinterType == PrinterType.network &&
//         //                 Platform.isWindows &&
//         //                 Platform.isAndroid,
//         //             child: Padding(
//         //               padding: const EdgeInsets.only(top: 10.0),
//         //               child: OutlinedButton(
//         //                 onPressed: () async {
//         //                   if (_ipController.text.isNotEmpty) {
//         //                     setIpAddress(_ipController.text);
//         //                   }
//         //                   _printReceiveTest();
//         //                 },
//         //                 child: const Padding(
//         //                   padding:
//         //                       EdgeInsets.symmetric(vertical: 4, horizontal: 50),
//         //                   child: Text("Print test ticket",
//         //                       textAlign: TextAlign.center),
//         //                 ),
//         //               ),
//         //             ),
//         //           )
//         //         ],
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ),
//     );
//   }
// }

// class BluetoothPrinter {
//   int? id;
//   String? deviceName;
//   String? address;
//   String? port;
//   String? vendorId;
//   String? productId;
//   bool? isBle;

//   PrinterType typePrinter;
//   bool? state;

//   BluetoothPrinter(
//       {this.deviceName,
//       this.address,
//       this.port,
//       this.state,
//       this.vendorId,
//       this.productId,
//       this.typePrinter = PrinterType.bluetooth,
//       this.isBle = false});
// }

// Future<List<int>> testTicket() async {
//   final profile = await CapabilityProfile.load(name: "XP-320L");
//   final generator = Generator(PaperSize.mm80, profile);
//   List<int> bytes = [];

//   bytes += generator.text(
//       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//   bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
//       styles: const PosStyles(codeTable: 'CP1252'));
//   bytes += generator.text('Special 2: blåbærgrød',
//       styles: const PosStyles(codeTable: 'CP1252'));

//   bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
//   bytes +=
//       generator.text('Reverse text', styles: const PosStyles(reverse: true));
//   bytes += generator.text('Underlined text',
//       styles: const PosStyles(underline: true), linesAfter: 1);
//   bytes += generator.text('Align left',
//       styles: const PosStyles(align: PosAlign.left));
//   bytes += generator.text('Align center',
//       styles: const PosStyles(align: PosAlign.center));
//   bytes += generator.text('Align right',
//       styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

//   bytes += generator.row([
//     PosColumn(
//       text: 'col3',
//       width: 3,
//       styles: const PosStyles(align: PosAlign.center, underline: true),
//     ),
//     PosColumn(
//       text: 'col6',
//       width: 6,
//       styles: const PosStyles(align: PosAlign.center, underline: true),
//     ),
//     PosColumn(
//       text: 'col3',
//       width: 3,
//       styles: const PosStyles(align: PosAlign.center, underline: true),
//     ),
//   ]);

//   bytes += generator.text('Text size 200%',
//       styles: const PosStyles(
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ));

//   // Print barcode
//   final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//   bytes += generator.barcode(Barcode.upcA(barData));

//   bytes += generator.feed(2);
//   bytes += generator.cut();
//   return bytes;
// }

// Future<void> printTicket() async {
//   List<int> bytes = [];
//   final profile = await CapabilityProfile.load();

//   final generator = Generator(PaperSize.mm80, profile);

//   bytes += generator.text(
//       'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//   bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
//       styles: const PosStyles(codeTable: 'CP1252'));
//   bytes += generator.text('Special 2: blåbærgrød',
//       styles: const PosStyles(codeTable: 'CP1252'));

//   bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
//   bytes +=
//       generator.text('Reverse text', styles: const PosStyles(reverse: true));
//   bytes += generator.text('Underlined text',
//       styles: const PosStyles(underline: true), linesAfter: 1);
//   bytes += generator.text('Align left',
//       styles: const PosStyles(align: PosAlign.left));
//   bytes += generator.text('Align center',
//       styles: const PosStyles(align: PosAlign.center));
//   bytes += generator.text('Align right',
//       styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

//   bytes += generator.row([
//     PosColumn(
//       text: 'col3',
//       width: 3,
//       styles: const PosStyles(align: PosAlign.center, underline: true),
//     ),
//     PosColumn(
//       text: 'col6',
//       width: 6,
//       styles: const PosStyles(align: PosAlign.center, underline: true),
//     ),
//     PosColumn(
//       text: 'col3',
//       width: 3,
//       styles: const PosStyles(align: PosAlign.center, underline: true),
//     ),
//   ]);

//   bytes += generator.text('Text size 200%',
//       styles: const PosStyles(
//         height: PosTextSize.size2,
//         width: PosTextSize.size2,
//       ));
//   bytes += generator.cut();

//   try {
//     final printer = PrinterNetworkManager('192.168.123.100');
//     PosPrintResult connect = await printer.connect();
//     if (connect == PosPrintResult.success) {
//       PosPrintResult printing = await printer.printTicket(bytes);
//       print(printing.msg);

//       printer.disconnect();
//     }
//   } catch (e) {
//     log(e.toString());
//   }
// }
