import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pamsimas/components/build_category.dart';
import 'package:pamsimas/helpers/helper.dart';
import 'package:pamsimas/model/user_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class DownloadReportScreen extends StatefulWidget {
  final DownloadReportParams data;

  const DownloadReportScreen({Key? key,required this.data}) : super(key: key);
  @override
  _DownloadReportScreenState createState() => _DownloadReportScreenState();
}

class _DownloadReportScreenState extends State<DownloadReportScreen> {
  DownloadReportParams get data => widget.data;

  int _lastUsage = 0;
  int _currentUsage = 0;
  int _vol = 0;
  int _lastBill = 0;
  int _currentBill = 0;
  int _totalBill = 0;
  int _totalPaid = 0;
  int _remain = 0;

  @override
  void initState() {
    super.initState();
    final _data = data.user;
    for(int i =0;i<_data.length;i++){
      _lastUsage += _data[i].bill!.lastUsage!;
      _currentUsage += _data[i].bill!.currentUsage!;
      _vol += _data[i].bill!.currentUsage! - _data[i].bill!.lastUsage!;
      _lastBill += _data[i].bill!.lastBill!;
      _currentBill += _data[i].bill!.currentBill!;
      _totalBill += _data[i].bill!.lastBill!+ _data[i].bill!.currentBill!;
      _totalPaid += _data[i].bill!.totalPaid!;
      _remain += (_data[i].bill!.lastBill!+_data[i].bill!.currentBill!) - _data[i].bill!.totalPaid!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan tagihan'),
        elevation: 0,
      ),
      body: PdfPreview(
        build: (format)async=>_generatePdf(format),
        pdfFileName: 'Laporan tagihan ${data.date}',
        previewPageMargin: EdgeInsets.all(4),
        canDebug: false,
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
          _buildContent(context),
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
                pw.Text('Periode : ${data.date}'),
                pw.Spacer(),
                pw.Text('Wilayah : ${data.address}')
              ]
            )
          ],
        )
    );
  }
  pw.Widget _buildContent(pw.Context context){
    return pw.ListView.separated(
      separatorBuilder: (context,i)=>pw.Divider(),
      itemCount: data.user.length,
      itemBuilder: (context,i){
        final _item = data.user[i];
        return pw.Container(
          margin: pw.EdgeInsets.all(8),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Text('${i+1}. ${_item.name!}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 16),),
                  pw.SizedBox(width: 8),
                  pw.Text('Golongan : ${_item.category}')
                ],
              ),
              pw.SizedBox(height: 4,),
              pw.Text('(${_item.uid})',style: pw.TextStyle(color: PdfColors.black),),
              pw.SizedBox(height: 8,),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Meteran : '),
                  pw.Spacer(),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Lalu'),
                      pw.Text('${_item.bill!.lastUsage}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                    ],
                  ),
                  pw.SizedBox(width: 24,),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Sekarang'),
                      pw.Text('${_item.bill!.currentUsage}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                    ],
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Vol(m3) : '),
                  pw.Spacer(),
                  pw.Text('${_item.bill!.currentUsage! - _item.bill!.lastUsage!}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                ],
              ),
              pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Tagihan : '),
                  pw.Spacer(),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Lalu'),
                      pw.Text('${Helper.formatCurrency(_item.bill!.lastBill!)}',style: pw.TextStyle(fontWeight:pw.FontWeight.bold),),
                    ],
                  ),
                  pw.SizedBox(width: 24,),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Sekarang'),
                      pw.Text('${Helper.formatCurrency(_item.bill!.currentBill!)}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                    ],
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Total Tagihan : '),
                  pw.Spacer(),
                  pw.Text('${Helper.formatCurrency(_item.bill!.lastBill! + _item.bill!.currentBill!)}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
                ],
              ),
              pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Dibayar : '),
                  pw.Spacer(),
                  pw.Text('${Helper.formatCurrency(_item.bill!.totalPaid!)}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
                ],
              ),
              pw.Divider(),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Sisa tagihan : '),
                  pw.Spacer(),
                  pw.Text('${Helper.formatCurrency((_item.bill!.lastBill! + _item.bill!.currentBill!) - _item.bill!.totalPaid!)}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold),)
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  pw.Widget _contentFooter(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
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
              flex: 2,
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
                        pw.Text('Meter lalu:'),
                        pw.Text('$_lastUsage'),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Meter sekarang:'),
                        pw.Text('$_currentUsage'),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Vol(m3):'),
                        pw.Text('$_vol'),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Tagihan lalu:'),
                        pw.Text('${Helper.formatCurrency(_lastBill)}'),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Tagihan sekarang:'),
                        pw.Text('${Helper.formatCurrency(_currentBill)}'),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Tagihan Total:'),
                        pw.Text('${Helper.formatCurrency(_totalBill)}'),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Dibayar:'),
                        pw.Text('${Helper.formatCurrency(_totalPaid)}'),
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
                          pw.Text('Sisa:'),
                          pw.Text('${Helper.formatCurrency(_remain)}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 30),
        pw.Text('Kalibagor,'),
        pw.SizedBox(height: 30),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Text('Yang menerima setoran,'),
            pw.Text('Yang menyetorkan,'),
          ]
        )
      ]
    );
  }
}


class DownloadReportParams{
  final List<UserModel> user;
  final String date;
  final String address;

  DownloadReportParams({required this.user,required this.date,required this.address});

}