import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_flow/file_picker_service.dart';
import 'package:sign_flow/pdf_editor_screen.dart';
import 'package:sign_flow/app_colors.dart';
import 'package:sign_flow/privacy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FilePickerService _filePickerService = FilePickerService();

  void _pickFile() async {
    final File? file = await _filePickerService.pickPdfFile();
    if (file != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfEditorScreen(file: file)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // 1. Üst Başlık
              _buildHeader(),

              Expanded(
                child: Container(
                  child: Image.asset("assets/signing.png"),
                  alignment: Alignment.center,
                ),
              ),

              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.primaryGreen,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Dosya Seç',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.backgroundLight,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.textGrey, width: 1),
                      ),
                      child: Icon(
                        Icons.privacy_tip_outlined,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset("assets/logo_no_background.png", height: 32),
            SizedBox(width: 8),
            Text(
              'SignFlow',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Belgelerinizi\nDijital Olarak İmzalayın',
          style: GoogleFonts.poppins(
            fontSize: 34,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'PDF dosyalarınızı saniyeler içinde yükleyin, düzenleyin ve imzalayın.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textGrey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
