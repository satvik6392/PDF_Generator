import 'package:flutter/material.dart';
import 'package:pdf_viewer/pdf_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pdf Viewer"),
      ),
      body: Center(
        child: Consumer<PdfProvider>(
          builder: (context, value, child) {
            return !value.isloaded
                ? ElevatedButton(
                    onPressed: () {
                      value.generatepdf();
                    },
                    child: value.isloading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Generate Pdf"))
                : PdfPreview(build: ((format) async {
                    return value.file.readAsBytes();
                  }));
          },
        ),
      ),
    );
  }
}
