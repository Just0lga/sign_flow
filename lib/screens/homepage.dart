import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sign_flow/ad_helper.dart'; // Kendi importun
import '../services/file_picker_service.dart';
import 'pdf_editor_screen.dart'; // Yeni oluşturacağımız sayfa
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FilePickerService _filePickerService = FilePickerService();
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print("Failed to load a banner ad: ${error.message}");
          ad.dispose();
        },
      ),
    ).load();
  }

  void _pickFile() async {
    final File? file = await _filePickerService.pickPdfFile();
    if (file != null && mounted) {
      // Dosya seçildiyse diğer sayfaya (Editor) git
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfEditorScreen(file: file)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("assets/galaxy.gif"),
            Text(
              'Sign Flow',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 48,
              ),
            ),
            Text(
              'Belgelerinizi kolayca imzalayın',
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 130, 130, 130),
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: width * 0.94,
                height: width * 0.14,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 13, 20, 100),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        13,
                        20,
                        100,
                      ).withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'PDF Dosyası Seç',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            const Security1(), // Aşağıdaki widget sınıfları
            const Security2(),
            SizedBox(height: 8),
            _bannerAd != null
                ? Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

// Security Widget'larını buraya veya ayrı bir dosyaya koyabilirsin
class Security2 extends StatelessWidget {
  const Security2({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          " ve ",
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PrivacyPolicyScreen(),
            ),
          ),
          child: Text(
            "Gizlilik Politikasını",
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
        Text(
          " kabul etmiş olursunuz: ",
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
      ],
    );
  }
}

class Security1 extends StatelessWidget {
  const Security1({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "'PDF Dosyası Seç' butonuna basarak",
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsOfServiceScreen(),
            ),
          ),
          child: Text(
            "Hizmet Şartları",
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
