import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pamsimas/bloc/get_all_user/get_all_user_cubit.dart';
import 'package:pamsimas/model/user_model.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class DownloadAllUserAccount extends StatefulWidget {
  @override
  _DownloadAllUserAccountState createState() => _DownloadAllUserAccountState();
}

class _DownloadAllUserAccountState extends State<DownloadAllUserAccount> {
  List<_UserModel> _users = <_UserModel>[];
  @override
  void initState() {
    super.initState();
    context.read<GetAllUserCubit>().fetchUsers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun pengguna'),
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
            final _data = state.users;
            for(int i = 0;i<_data.length;i++){
              final _item = _data[i];
              _users.add(_UserModel(i, _item.name!, _item.name!, _item.password!,));
            }
            return PdfPreview(
              build: (format) async => _generatePdf(format,_users),
              pdfFileName: 'Akun pengguna',
              previewPageMargin: EdgeInsets.all(4),
              canDebug: false,
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, List<_UserModel> users) async {
    final _doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true,);
    _doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: pw.EdgeInsets.all(12),
        build: (context) =>[
          pw.SizedBox(height: 20),
          _contentTable(context,_users),
        ],
      ),
    );
    return _doc.save();
  }

  pw.Widget _contentTable(pw.Context context,List<_UserModel> users) {
    const tableHeaders = [
      'No',
      'Nama',
      'Username',
      'Password',
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.blue,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 14,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.green,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(tableHeaders.length, (col) => tableHeaders[col],),
      data: List<List<String>>.generate(_users.length, (row) => List<String>.generate(tableHeaders.length, (col) => _users[row].getIndex(col),),
      ),
    );
  }
}

class _UserModel {
  _UserModel(this.no,this.name, this.username, this.password,);

  final int no;
  final String name;
  final String username;
  final String password;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return (no+1).toString();
      case 1:
        return name;
      case 2:
        return username;
      case 3:
        return password;
    }
    return '';
  }
}