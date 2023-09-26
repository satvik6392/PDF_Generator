import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'invoice_model.dart';

Future<File> createpdf(Invoice invoice) async {
  pw.Document doc = pw.Document();
  doc.addPage(pw.MultiPage(
    build: (context) => [
      buildHeader(invoice),
      pw.SizedBox(height: 3 * PdfPageFormat.cm),
      buildTitle(invoice),
      buildInvoice(invoice),
      pw.Divider(),
      buildTotal(invoice)
    ],
  ));
  Directory filepath = await getApplicationDocumentsDirectory();
  File file = File("${filepath.path}/Invoice_${invoice.customerName}.pdf");
  await file.writeAsBytes(await doc.save());
  return file;
}

pw.Widget buildHeader(Invoice invoice) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // buildSupplierAddress(invoice.supplierName),
            pw.Text(
              invoice.customerName + "\n" + invoice.address,
              style: pw.TextStyle(
                  color: PdfColors.black, fontWeight: pw.FontWeight.bold),
            ),
            // Text(,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            pw.Container(
              height: 50,
              width: 50,
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: invoice.supplierName,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     buildCustomerAddress(invoice.customer),
        //     // buildInvoiceInfo(invoice.info),
        //   ],
        // ),
      ],
    );

//  Widget buildCustomerAddress(Customer customer) => Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(customer.address),
//       ],
//     );

//  Widget buildInvoiceInfo(InvoiceInfo info) {
//   final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
//   final titles = <String>[
//     'Invoice Number:',
//     'Invoice Date:',
//     'Payment Terms:',
//     'Due Date:'
//   ];
//   final data = <String>[
//     info.number,
//     Utils.formatDate(info.date),
//     paymentTerms,
//     Utils.formatDate(info.dueDate),
//   ];

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: List.generate(titles.length, (index) {
//       final title = titles[index];
//       final value = data[index];

//       return buildText(title: title, value: value, width: 200);
//     }),
//   );
// }

//  Widget buildSupplierAddress(String supplier) => Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(supplier, style: TextStyle(fontWeight: FontWeight.bold)),
//         SizedBox(height: 1 * PdfPageFormat.mm),
//         // Text(supplier.address),
//       ],
//     );

pw.Widget buildTitle(Invoice invoice) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'INVOICE',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        // SizedBox(height: 0.8 * PdfPageFormat.cm),
        // Text(invoice.info.description),
        pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
      ],
    );

pw.Widget buildInvoice(Invoice invoice) {
  final headers = ['No.', 'ID', 'Seat No.', 'Date', 'Method', 'Total'];
  final data = invoice.items.map((item) {
    // final total = item.unitPrice * item.quantity * (1 + item.vat);

    return [
      item.no,
      item.id,
      item.seat,
      item.date,
      item.method,
      item.amount,
    ];
  }).toList();
  return pw.TableHelper.fromTextArray(
    headers: headers,
    data: data,
    border: null,
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
    cellHeight: 30,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerRight,
      2: pw.Alignment.centerRight,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
    },
  );
}

pw.Widget buildTotal(Invoice invoice) {
  final total = invoice.items
      .map((item) => int.parse(item.amount))
      .reduce((item1, item2) => item1 + item2);
  final netTotal = total.toString();
  // final vatPercent = invoice.items.first.vat;
  // final vat = netTotal * vatPercent;
  // final total = netTotal + vat;

  return pw.Container(
    alignment: pw.Alignment.centerRight,
    child: pw.Row(
      children: [
        pw.Spacer(flex: 6),
        pw.Expanded(
          flex: 4,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildText(
                title: 'Net total',
                value: netTotal,
                unite: true,
              ),
              // buildText(
              //   title: 'Vat ${vatPercent * 100} %',
              //   value: Utils.formatPrice(vat),
              //   unite: true,
              // ),
              pw.Divider(),
              buildText(
                title: 'Total amount due',
                titleStyle: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
                value: netTotal,
                unite: true,
              ),
              pw.SizedBox(height: 2 * PdfPageFormat.mm),
              pw.Container(height: 1, color: PdfColors.grey400),
              pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
              pw.Container(height: 1, color: PdfColors.grey400),
            ],
          ),
        ),
      ],
    ),
  );
}

// static Widget buildFooter(Invoice invoice) => Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Divider(),
//         SizedBox(height: 2 * PdfPageFormat.mm),
//         buildSimpleText(title: 'Address', value: invoice.supplier.address),
//         SizedBox(height: 1 * PdfPageFormat.mm),
//         buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
//       ],
//     );

// static buildSimpleText({
//   required String title,
//   required String value,
// }) {
//   final style = TextStyle(fontWeight: FontWeight.bold);

//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment: pw.CrossAxisAlignment.end,
//     children: [
//       Text(title, style: style),
//       SizedBox(width: 2 * PdfPageFormat.mm),
//       Text(value),
//     ],
//   );
// }

pw.Widget buildText({
  required String title,
  required String value,
  double width = double.infinity,
  pw.TextStyle? titleStyle,
  bool unite = false,
}) {
  final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

  return pw.Container(
    width: width,
    child: pw.Row(
      children: [
        pw.Expanded(child: pw.Text(title, style: style)),
        pw.Text(value, style: unite ? style : null),
      ],
    ),
  );
}
