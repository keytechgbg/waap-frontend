import 'package:flutter/material.dart';
import 'package:waap/STYLES.dart';
import 'package:waap/components/WaapButton.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ShowPdfPage extends StatelessWidget {
  ShowPdfPage(this.pdfname);

  final double borderSize = 2;
  var pdfname;

  @override
  Widget build(BuildContext context) {
    var W = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: STYLES.buttonTopPadding.add(EdgeInsets.only(bottom: 20)),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: WaapButton(
                        Icon(Icons.arrow_back),
                        type: WaapButton.RIGHT,
                        callback: () {
                          Navigator.pop(context);
                        },
                      )),
                ],
              ),
            ),
            Expanded(
              child: PDFView(
                filePath: pdfname,
                autoSpacing: false,
                pageFling: false,
                onError: (e){print(e);},
              ),
            )
          ],
        ),
      ),
    );
  }
}
