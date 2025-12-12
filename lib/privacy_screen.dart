import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_flow/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Gizlilik Politikası",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryGreen, // butonun arka planı
                            shape: const CircleBorder(), // yuvarlak
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white, // ikon beyaz
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Başlık İkonu ve Giriş
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.highlightGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    size: 64,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Sign Flow Gizlilik Politikası',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Son Güncelleme: ${DateTime.now().year}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 24),

              // Maddeler
              _buildSectionTitle('1. Giriş'),
              _buildSectionContent(
                'Sign Flow ("Uygulama") olarak gizliliğinize önem veriyoruz. Bu gizlilik politikası, uygulamamızı kullanırken verilerinizin nasıl toplandığını, kullanıldığını ve paylaşıldığını açıklar.',
              ),

              _buildSectionTitle('2. Toplanan Biyometrik Veriler (3D İmza)'),
              _buildSectionContent(
                'Uygulamamız, imzanızın güvenliğini ve benzersizliğini sağlamak amacıyla gelişmiş imza teknolojileri kullanır. İmza atma işlemi sırasında sadece görsel imza değil, aynı zamanda şu "Davranışsal Biyometrik Veriler" toplanmaktadır:\n\n'
                '• Kalem/Parmak vuruşları (Strokes)\n'
                '• İmza atma hızı ve süresi\n'
                '• Hareket koordinatları\n\n'
                'Bu veriler, imzanın size ait olduğunu doğrulamak ve dijital belgenin bütünlüğünü sağlamak için "3D İmza" formatında işlenir.',
              ),

              _buildSectionTitle('3. Verilerin Kullanımı ve İşlenmesi'),
              _buildSectionContent(
                'Toplanan biyometrik veriler ve PDF belgeleri, imzalama işleminin tamamlanması amacıyla güvenli Backend sunucularımıza iletilir. Bu veriler:\n\n'
                '1. PDF belgesinin üzerine kriptografik olarak işlenir.\n'
                '2. Belgenin orijinalliğini kanıtlamak için kullanılır.\n'
                '3. Yasal geçerlilik gerektiren durumlarda kanıt niteliği taşıması için saklanabilir.',
              ),

              _buildSectionTitle('4. Veri Paylaşımı'),
              _buildSectionContent(
                'Kişisel verileriniz ve imzalı belgeleriniz, yasal zorunluluklar haricinde üçüncü taraflarla paylaşılmaz. İmzalanan PDF dosyaları, yalnızca sizin belirlediğiniz alıcılar veya sistemlerimiz arasında transfer edilir.',
              ),

              _buildSectionTitle('5. İletişim'),
              _buildSectionContent(
                'Gizlilik politikamız veya verilerinizle ilgili sorularınız için bizimle iletişime geçebilirsiniz:',
              ),
              const SizedBox(height: 8),
              _buildContactInfo(context),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Başlıklar için yardımcı widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  // İçerik metinleri için yardımcı widget
  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: GoogleFonts.poppins(
        fontSize: 14,
        height: 1.6, // Okunabilirliği artırmak için satır aralığı
        color: AppColors.textDark.withOpacity(0.8),
      ),
    );
  }

  // İletişim kutusu widget'ı (GÜNCELLENMİŞ HALİ)
  Widget _buildContactInfo(BuildContext context) {
    const String email = 'info@proaktif01.com';

    return GestureDetector(
      onTap: () async {
        // 1. Panoya Kopyala
        await Clipboard.setData(const ClipboardData(text: email));

        // 2. Kullanıcıya Bilgi Ver (SnackBar)
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'E-posta adresi kopyalandı!',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: AppColors.primaryGreen,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Destek Ekibi',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  // E-posta ve Kopyalama Butonu Satırı
                  Row(
                    children: [
                      // E-posta Metni
                      Text(
                        email,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDark,
                        ),
                      ),

                      Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.copy_rounded, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }
}
