import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamsimas/bloc/get_all_user/get_all_user_cubit.dart';
import 'package:pamsimas/model/user_model.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class DownloadAllQrCode extends StatefulWidget {
  @override
  State<DownloadAllQrCode> createState() => _DownloadAllQrCodeState();
}

class _DownloadAllQrCodeState extends State<DownloadAllQrCode> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllUserCubit>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Code pengguna'),
      ),
      body: BlocBuilder<GetAllUserCubit, GetAllUserState>(
        builder: (context, state) {
          if (state is GetAllUserLoading) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is GetAllUserFailure) {
            return Center(
              child: Text(state.msg),
            );
          }
          if (state is GetAllUserSuccess) {
            final _users = state.users;
            return PdfPreview(
              build: (format) async => _generatePdf(format, _users),
              pdfFileName: 'Qr Code Pengguna',
              previewPageMargin: EdgeInsets.all(4),
              canDebug: false,
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, List<UserModel> users) async {
    final _doc = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
    );
    for (int i = 0; i < users.length; i++) {
      final _item = users[i];
      _doc.addPage(
        pw.Page(
          pageFormat: format,
          margin: pw.EdgeInsets.all(12),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.BarcodeWidget(
                    data: _item.uid!,
                    barcode: pw.Barcode.qrCode(),
                    width: 300,
                    height: 300,
                  ),
                ),
                pw.SizedBox(height: 24),
                pw.Text(_item.name!, style: pw.TextStyle(fontSize: 24))
              ],
            );
          },
        ),
      );
    }
    return _doc.save();
  }
}
