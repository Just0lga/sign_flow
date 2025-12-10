import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sign_flow/ad_helper.dart'; // Kendi importun
import '../services/file_picker_service.dart';
import 'pdf_editor_screen.dart'; // Yeni oluşturacağımız sayfa
import 'terms_of_service_screen.dart';
import 'privacy_policy_screen.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final LocaleProvider? localeProvider;
  const HomeScreen({Key? key, this.localeProvider}) : super(key: key);

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
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfEditorScreen(file: file)),
      );
      // Geri dönüldüğünde reklamı yenile
      _loadBannerAd();
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
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                child: PopupMenuButton<Locale>(
                  color: Colors.black,
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 24,
                  ),
                  onSelected: (Locale locale) {
                    widget.localeProvider?.setLocale(locale);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Locale>>[
                        PopupMenuItem<Locale>(
                          value: Locale('en'),
                          child: Row(
                            children: [
                              Text('🇬🇧', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Text(
                                'English',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<Locale>(
                          value: Locale('tr'),
                          child: Row(
                            children: [
                              Text('🇹🇷', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 8),
                              Text(
                                'Türkçe',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ),
            ),
            Image.asset("assets/galaxy.gif"),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 48,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.subtitle,
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
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.selectPdf,
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
          AppLocalizations.of(context)!.and,
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
            AppLocalizations.of(context)!.privacyPolicy,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.agreeTo,
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
          AppLocalizations.of(context)!.byClicking,
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
            AppLocalizations.of(context)!.termsOfService,
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
