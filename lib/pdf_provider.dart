import 'package:flutter/material.dart';
import 'package:pdf_viewer/invoice_model.dart';
import 'package:pdf_viewer/pdf_create.dart';
import 'dart:io';
import 'invoice_json.dart';

class PdfProvider extends ChangeNotifier {
  bool isloading = false;
  bool isloaded = false;
  late File file;
  Future<void> generatepdf() async {
    print("object");
    isloading = true;
    notifyListeners();

    Invoice invoice = Invoice.fromJson(data);
    file = await createpdf(invoice);

    isloading = false;
    isloaded = true;
    notifyListeners();
  }
}
