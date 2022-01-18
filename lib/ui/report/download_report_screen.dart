import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class DownloadReportScreen extends StatefulWidget {
  final List<UserModel> data;

  const DownloadReportScreen({Key? key,required this.data}) : super(key: key);
  @override
  _DownloadReportScreenState createState() => _DownloadReportScreenState();
}

class _DownloadReportScreenState extends State<DownloadReportScreen> {
  List<_ProductModel> _products = <_ProductModel>[];
  List<UserModel> get data => widget.data;

  @override
  void initState() {
    super.initState();
    _products = [
      _ProductModel(10, '100', 'P', 'Febry', '100', '200', 2, 29, 30, 10, 2, 34)
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Laporan'),
        elevation: 0,
      ),
      body: PdfPreview(
        build: (format)async=>_generatePdf(format),
        pdfFileName: 'Laporan tagihan November 2021',
        previewPageMargin: EdgeInsets.all(4),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format,) async {
    final _doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    _doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        header: _buildHeader,
        margin: pw.EdgeInsets.all(12),
        // orientation: pw.PageOrientation.landscape,
        build: (context) =>[
          pw.SizedBox(height: 20),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
        ],
      ),
    );
    return _doc.save();
  }
  pw.Widget _buildHeader(pw.Context context) {
    return pw.DefaultTextStyle(
        style: pw.TextStyle(fontSize: 17),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text('DAFTAR TAGIHAN BULANAN AIR BERSIH',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
            ),
            pw.SizedBox(height: 12),
            pw.Row(
              children: [
                pw.Text('Periode : November 2021'),
                pw.Spacer(),
                pw.Text('Wilayah : Rt.004/Rw.002')
              ]
            )
          ],
        )
    );
  }
  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Id',
      'Gol',
      'Nama',
      'Penggunaan Lalu',
      'Penggunaan Skrng',
      'Vol',
      'Tagihan Lalu',
      'Tagihan Skrng',
      'Total',
      'Dibayar',
      'Sisa',
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
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
      data: List<List<String>>.generate(_products.length, (row) => List<String>.generate(tableHeaders.length, (col) => _products[row].getIndex(col),),),
    );
  }
  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Text(
                    'Setoran tagihan : ',
                    style: pw.TextStyle(
                        color: PdfColors.black,
                        fontStyle: pw.FontStyle.italic
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Text(
                    'Rp.',
                    style: pw.TextStyle(
                        color: PdfColors.black,
                    ),
                  ),
                ]
              ),
              pw.Row(
                  children: [
                    pw.Text(
                      'Potongan fee (6%) : ',
                      style: pw.TextStyle(
                          color: PdfColors.black,
                          fontStyle: pw.FontStyle.italic
                      ),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text(
                      'Rp.',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                      ),
                    ),
                  ]
              ),
              pw.Row(
                  children: [
                    pw.Text(
                      'Potongan lainnya : ',
                      style: pw.TextStyle(
                          color: PdfColors.black,
                          fontStyle: pw.FontStyle.italic
                      ),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text(
                      'Rp.',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                      ),
                    ),
                  ]
              ),
              pw.Container(
                width: 250,
                color: PdfColors.grey,
                margin: pw.EdgeInsets.symmetric(vertical: 8)
              ),
              pw.Row(
                  children: [
                    pw.Text(
                      'Jumlah setoran : ',
                      style: pw.TextStyle(
                          color: PdfColors.black,
                          fontStyle: pw.FontStyle.italic
                      ),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text(
                      'Rp.',
                      style: pw.TextStyle(
                        color: PdfColors.black,
                      ),
                    ),
                  ]
              ),
            ]
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text('1000000'),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Dibayar:'),
                    pw.Text('20000'),
                  ],
                ),
                pw.Divider(color: PdfColors.red),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: PdfColors.red,
                    fontSize: 17,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text('90000'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductModel {


  final int no;
  final String uid;
  final String category;
  final String name;
  final String lastUsage;
  final String currentUsage;
  final int vol;
  final int lastBill;
  final int currentBill;
  final int totalBill;
  final int totalRemains;
  final int totalPaid;

  _ProductModel(this.no, this.uid, this.category, this.name, this.lastUsage, this.currentUsage, this.vol, this.lastBill, this.currentBill, this.totalBill, this.totalRemains, this.totalPaid);

  String getIndex(int index) {
    switch (index) {
      case 0:
        return no.toString();
      case 1:
        return name;
      case 2:
        return category;
      case 3:
        return currentUsage.toString();
      case 4:
        return Helper.formatCurrency(totalBill);
    }
    return '';
  }
}
