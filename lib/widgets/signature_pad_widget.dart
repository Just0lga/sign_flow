import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePadWidget extends StatefulWidget {
  final Function(Uint8List) onSigned;

  const SignaturePadWidget({Key? key, required this.onSigned}) : super(key: key);

  @override
  _SignaturePadWidgetState createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState extends State<SignaturePadWidget> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  void _clearSignature() {
    _signaturePadKey.currentState?.clear();
  }

  Future<void> _saveSignature() async {
    final ui.Image image =
        await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      widget.onSigned(pngBytes);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Sign Below',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SfSignaturePad(
                key: _signaturePadKey,
                backgroundColor: Colors.white,
                strokeColor: Colors.black,
                minimumStrokeWidth: 2.0,
                maximumStrokeWidth: 4.0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _clearSignature,
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _saveSignature,
                child: const Text('Save Signature'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
