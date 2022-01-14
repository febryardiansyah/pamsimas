import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/user_model.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;


class InvoiceScreen extends StatefulWidget {
  final UserModel data;

  const InvoiceScreen({Key? key,required this.data}) : super(key: key);
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}
class _InvoiceScreenState extends State<InvoiceScreen> {
  final lorem = pw.LoremText();

  List<Product> _products = <Product>[];
  UserModel get data => widget.data;
  @override
  void initState() {
    super.initState();
    _products = [
      Product(1, 'Tagihan pemakain air bersih', data.category!,'${data.bill!.currentUsage!} m3', data.bill!.currentBill!)
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
        elevation: 0,
      ),
      body: PdfPreview(
        build: (format)async=>_generatePdf(format, data),
      ),
    );
  }

  late var _image;

  Future<Uint8List> _generatePdf(PdfPageFormat format, UserModel user) async {
    final _doc = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
     _image = await flutterImageProvider(AssetImage('assets/images/MainLogo.png',));
    _doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        header: _buildHeader,
        footer: _buildFooter,
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
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('INVOICE',
                  style: pw.TextStyle(
                    color: PdfColors.blue,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Pampay - Pamsimas',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
                pw.Text('Desa Kalibagor',),
                pw.SizedBox(height: 10),
                pw.Text('Kepada',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
                pw.Text(data.name!,),
                pw.Text(data.address!,),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Container(
                  alignment: pw.Alignment.topRight,
                  padding: pw.EdgeInsets.only(bottom: 8, left: 30),
                  height: 72,
                  child: pw.Image(_image),
                ),
                pw.Container(
                    height: 100,
                    child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
                          pw.Text(data.bill!.id!.split('-').first,),
                          pw.Text('Periode :',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
                          pw.Text('${data.bill!.month} ${data.bill!.year}',),
                          pw.Text('Status :',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
                          pw.Text('${data.bill!.isPayed!?'Lunas':'Belum Lunas'}',style: pw.TextStyle(
                            color: data.bill!.isPayed!?PdfColors.blue:PdfColors.red,
                            fontWeight: pw.FontWeight.bold
                          )),
                        ]
                    )
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# 100',
            drawText: false,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }
  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'No',
      'Keterangan',
      'Kategori',
      'Pemakaian',
      'Harga'
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
      data: List<List<String>>.generate(_products.length, (row) => List<String>.generate(tableHeaders.length, (col) => _products[row].getIndex(col),),
      ),
    );
  }
  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            'Terimakasih telah berlangganan',
            style: pw.TextStyle(
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
            ),
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
                    pw.Text(Helper.formatCurrency(data.bill!.currentBill!)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Dibayar:'),
                    pw.Text(Helper.formatCurrency(data.bill!.totalPaid!)),
                  ],
                ),
                pw.Divider(color: PdfColors.red),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: data.bill!.isPayed!?PdfColors.blue:PdfColors.red,
                    fontSize: 17,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(Helper.formatCurrency(data.bill!.currentBill! - data.bill!.totalPaid!)),
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

class Product {
  Product(this.no,this.detail, this.category, this.usage, this.total,);

  final int no;
  final String detail;
  final String category;
  final String usage;
  final int total;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return no.toString();
      case 1:
        return detail;
      case 2:
        return category;
      case 3:
        return usage.toString();
      case 4:
        return Helper.formatCurrency(total);
    }
    return '';
  }
}