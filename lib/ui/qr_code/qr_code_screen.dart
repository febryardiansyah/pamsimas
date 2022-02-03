import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class QrCodeScreen extends StatefulWidget {
  final String? uid;

  const QrCodeScreen({Key? key, this.uid}) : super(key: key);

  @override
  _QrCodeScreenState createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColor.lightBlue,
        title: Text('Qr Code'),
        elevation: 0,
      ),
      body: PdfPreview(
        build: (format) async => _generatePdf(format,),
        pdfFileName: 'Qr Code',
        previewPageMargin: EdgeInsets.all(4),
        canDebug: false,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format,) async {
    final _doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true,);
    _doc.addPage(
      pw.Page(
        pageFormat: format,
        margin: pw.EdgeInsets.all(12),
        build: (context) {
          return pw.Center(
            child: pw.BarcodeWidget(
              data: widget.uid!,
              barcode: pw.Barcode.qrCode(),
              width: 300,
              height: 300,
            ),
          );
        },
      ),
    );
    return _doc.save();
  }
}
