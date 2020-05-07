import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:subset/urls/allUrls.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfLink;
  PdfViewerScreen(this.pdfLink, {Key key}) : super(key: key);
  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool isLoading = true;
  PDFDocument document;

  loadPDF() async {
    document = await PDFDocument.fromURL(Constants().notesPDF + widget.pdfLink);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    this.loadPDF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(),
        body: Center(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : PDFViewer(
                    document: document,
                    showNavigation: true,
                    showPicker: false,
                  )));
  }
}
