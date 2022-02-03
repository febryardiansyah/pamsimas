import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/user_model.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class DownloadUserAccount extends StatefulWidget {
  final UserModel user;

  const DownloadUserAccount({Key? key,required this.user}) : super(key: key);
  @override
  _DownloadUserAccountState createState() => _DownloadUserAccountState();
}

class _DownloadUserAccountState extends State<DownloadUserAccount> {
  UserModel get user => widget.user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download akun pengguna'),
        elevation: 0,
      ),
      body: PdfPreview(
        build: (format)async=>_generatePdf(format),
        pdfFileName: 'Akun ${user.name}',
        previewPageMargin: EdgeInsets.all(4),
        canDebug: false,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format,) async {
    final _doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true,);
    _doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: pw.EdgeInsets.all(100),
        // orientation: pw.PageOrientation.landscape,
        build: (context) =>[
          pw.SizedBox(height: 20),
          _buildQrCode(),
          pw.SizedBox(height: 24),
          _buildContent(),
        ],
      ),
    );
    return _doc.save();
  }

  pw.Widget _buildQrCode(){
    return pw.Center(
      child: pw.BarcodeWidget(
        data: user.uid!,
        barcode: pw.Barcode.qrCode(),
        width: 300,
        height: 300,
      )
    );
  }

  pw.Widget _buildContent(){
    return pw.DefaultTextStyle(
      style: pw.TextStyle(fontSize: 17),
      child: pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Text('ID Pengguna',style: pw.TextStyle(),),
                pw.Spacer(),
                pw.Text(user.uid!),
              ],
            ),
            pw.SizedBox(height: 8,),
            pw.Row(
              children: [
                pw.Text('Nama',style: pw.TextStyle(),),
                pw.Spacer(),
                pw.Text(user.name!),
              ],
            ),
            pw.SizedBox(height: 8,),
            pw.Row(
              children: [
                pw.Text('Username',style: pw.TextStyle(),),
                pw.Spacer(),
                pw.Text(user.name!),
              ],
            ),
            pw.SizedBox(height: 8,),
            pw.Row(
              children: [
                pw.Text('Password',style: pw.TextStyle(),),
                pw.Spacer(),
                pw.Text(user.password!),
              ],
            ),
            pw.SizedBox(height: 8,),
            pw.Row(
              children: [
                pw.Text('Role',style: pw.TextStyle(),),
                pw.Spacer(),
                pw.Text(user.role!),
              ],
            ),
            pw.SizedBox(height: 8,),
            pw.Row(
              children: [
                pw.Text('Kategori',style: pw.TextStyle(),),
                pw.Spacer(),
                pw.Text(user.category!),
              ],
            ),
          ]
      ),
    );
  }

}
