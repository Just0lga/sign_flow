import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_flow/app_colors.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePadWidget extends StatefulWidget {
  const SignaturePadWidget({Key? key}) : super(key: key);

  @override
  _SignaturePadWidgetState createState() => _SignaturePadWidgetState();
}

class _SignaturePadWidgetState extends State<SignaturePadWidget> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  void _clearSignature() {
    _signaturePadKey.currentState?.clear();
  }

  Future<void> _saveSignature() async {
    final ui.Image image = await _signaturePadKey.currentState!.toImage(
      pixelRatio: 3.0,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null && mounted) {
      Navigator.of(context).pop(byteData.buffer.asUint8List());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 420,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          Text(
            "Aşağıyı İmzalayın",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),

          // SIGNATURE BOX
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGreen, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SfSignaturePad(
                key: _signaturePadKey,
                backgroundColor: Colors.transparent,
                strokeColor: AppColors.textDark,
                minimumStrokeWidth: 2,
                maximumStrokeWidth: 4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // BUTTONS
          Row(
            children: [
              // CLEAR BUTTON
              Expanded(
                child: ElevatedButton(
                  onPressed: _clearSignature,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: width * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: AppColors.primaryDark.withOpacity(0.4),
                  ),
                  child: Text(
                    "Temizle",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // SAVE BUTTON
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveSignature,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: width * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 7,
                    shadowColor: AppColors.accentGreen.withOpacity(0.5),
                  ),
                  child: Text(
                    "İmzayı Kaydet",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
