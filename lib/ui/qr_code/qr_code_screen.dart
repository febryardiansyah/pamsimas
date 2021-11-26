import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pamsimas/helpers/base_color.dart';
import 'package:pamsimas/helpers/base_string.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      ),
      body: Center(
        child: QrImage(
          data: widget.uid!,
          version: QrVersions.auto,
          size: 200,
          // gapless: false,
          // embeddedImage: AssetImage(BaseString.iMainLogo),
          // embeddedImageStyle: QrEmbeddedImageStyle(
          //   size: Size(80, 80),
          // ),
        ),
      ),
    );
  }
}
