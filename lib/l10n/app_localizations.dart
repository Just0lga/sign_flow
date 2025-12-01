import 'dart:convert';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Sign Flow',
      'subtitle': 'Easily sign your documents',
      'selectPdf': 'Select PDF File',
      'and': ' and ',
      'privacyPolicy': 'Privacy Policy',
      'agreeTo': ' you agree to: ',
      'byClicking': "By clicking 'Select PDF File'",
      'termsOfService': 'Terms of Service',
      'language': 'Language',
      'signatureAddedSuccess': 'Signature added successfully!',
      'signedDocumentShareText': 'Here is my signed document.',
      'savedToDownloads': 'Saved to Downloads: ',
      'storagePermissionDenied': 'Storage permission denied.',
      'downloadError': 'Download error: ',
      'share': 'Share',
      'download': 'Download',
      'addSignature': 'Add Signature',
      'errorAddingSignature': 'Error adding signature: ',
      'placeSignature': 'Place Signature',
      'tapToPlaceSignature': 'Tap anywhere on the PDF to place your signature',
      'privacyPolicyTitleText':
          'This document explains how the application handles user data.',
      'privacyPolicyText':
          'Sign Flow is a fully local PDF signing application that operates entirely on the user’s device without connecting to any server. The application does not collect, process, store, or share any personal data. PDF files located on the user’s device are opened, signed, and saved only locally. It is not technically possible for files or signatures to be transmitted to the developer or any external service, as the application does not perform any data communication over the internet. The app does not use analytics tools, cookies, tracking technologies, or any data collection systems for advertising. All file operations occur under the security mechanisms provided by the device’s operating system. No information related to signature actions performed within the application is recorded in any form. This privacy policy may be updated over time, and updates become effective once published. For any questions, you may contact us at info@proaktif01.com.',
      'termsOfServiceTitleText':
          'This document explains the conditions for using the application and user responsibilities.',
      'termsOfServiceText':
          'Sign Flow is a mobile application that allows users to sign PDF files stored on their devices, functioning entirely locally. Since the application does not use any backend infrastructure, all operations take place solely on the user’s device. The user is fully responsible for the content, accuracy, and storage of the documents they sign; the application does not provide legal validation, identity verification, or electronic certificate services. When the Share feature is used, files may be sent to other applications on the device, and because this action is initiated by the user, the application does not have control or responsibility over what happens afterward. The application is provided “as is,” and the developer makes no warranties and is not responsible for any file loss, errors, or technical issues that may occur during use. These terms may be updated when necessary, and updates become effective as soon as they are published. For any inquiries, please contact us at info@proaktif01.com.',
      'signBelow': 'Sign Below',
      'clear': 'Clear',
      'saveSignature': 'Save Signature',
    },
    'tr': {
      'appTitle': 'Sign Flow',
      'subtitle': 'Belgelerinizi kolayca imzalayın',
      'selectPdf': 'PDF Dosyası Seç',
      'and': ' ve ',
      'privacyPolicy': 'Gizlilik Politikasını',
      'agreeTo': ' kabul etmiş olursunuz: ',
      'byClicking': "'PDF Dosyası Seç' butonuna basarak",
      'termsOfService': 'Hizmet Şartları',
      'language': 'Dil',
      'signatureAddedSuccess': 'İmza başarıyla eklendi!',
      'signedDocumentShareText': 'İşte imzalı belgem.',
      'savedToDownloads': 'İndirilenlere kaydedildi: ',
      'storagePermissionDenied': 'Depolama izni reddedildi.',
      'downloadError': 'İndirme hatası: ',
      'share': 'Paylaş',
      'download': 'İndir',
      'addSignature': 'İmza Ekle',
      'errorAddingSignature': 'İmza ekleme hatası: ',
      'placeSignature': 'İmzayı Yerleştir',
      'tapToPlaceSignature':
          'İmzanızı yerleştirmek için PDF üzerinde herhangi bir yere dokunun',
      'privacyPolicyTitleText':
          'Bu metin, uygulamanın kullanıcı verilerini nasıl ele aldığını açıklar.',
      'privacyPolicyText':
          'Sign Flow, tamamen cihaz üzerinde çalışan ve hiçbir şekilde sunucuya bağlanmayan bir PDF imzalama uygulamasıdır. Uygulama, kullanıcılarından herhangi bir kişisel veri toplamaz, işlemez, saklamaz veya üçüncü taraflarla paylaşmaz. Kullanıcıların cihazlarında bulunan PDF dosyaları yalnızca lokal olarak açılır, imzalanır ve yine lokal olarak kaydedilir. Dosyaların veya imzaların geliştiriciye ya da herhangi bir kuruluşa iletilmesi mümkün değildir çünkü uygulama internet üzerinden hiçbir veri iletişimi gerçekleştirmez. Uygulama, analitik araçları, çerezler, takip teknolojileri veya reklam amaçlı veri toplama sistemleri kullanmaz. Tüm dosya işlemleri kullanıcı cihazının işletim sistemi tarafından sağlanan güvenlik mekanizmaları kapsamında gerçekleşir. Uygulama içerisinde yapılan imzalama işlemlerine dair hiçbir bilgi kayıt altına alınmaz. Bu gizlilik politikası zamanla güncellenebilir ve güncellemeler yayınlandığı andan itibaren geçerli olur. Sorularınız için info@proaktif01.com adresinden iletişime geçebilirsiniz.',
      'termsOfServiceTitleText':
          'Bu metin, uygulamanın kullanım koşullarını ve kullanıcı sorumluluklarını açıklar.',
      'termsOfServiceText':
          'Sign Flow, kullanıcıların cihazlarındaki PDF dosyalarını imzalamalarına olanak sağlayan, tamamen lokal çalışan bir mobil uygulamadır. Uygulama herhangi bir sunucu altyapısı kullanmadığından bütün işlemler yalnızca kullanıcının cihazı üzerinde gerçekleşir. İmzalanan belgelerin içeriği, doğruluğu ve saklanması konusunda tüm sorumluluk kullanıcıya aittir; uygulama hukuki geçerlilik, kimlik doğrulama veya elektronik sertifika hizmeti sunmaz. Paylaş özelliği kullanıldığında dosyalar cihazdaki diğer uygulamalara gönderilebilir ve bu paylaşım kullanıcı tarafından başlatıldığı için uygulama bu aşamadan sonraki süreç üzerinde kontrol veya sorumluluk kabul etmez. Uygulama “olduğu gibi” sunulmakta olup geliştirici herhangi bir garanti vermez ve kullanım sırasında oluşabilecek dosya kayıpları, hatalar veya teknik sorunlardan dolayı sorumluluk kabul etmez. Hizmet şartları gerektiğinde güncellenebilir ve güncellemeler yayınlandığı anda geçerlilik kazanır. Her türlü soru için info@proaktif01.com üzerinden bize ulaşabilirsiniz.',
      'signBelow': 'Aşağıyı İmzalayın',
      'clear': 'Temizle',
      'saveSignature': 'İmzayı Kaydet',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get subtitle => _localizedValues[locale.languageCode]!['subtitle']!;
  String get selectPdf => _localizedValues[locale.languageCode]!['selectPdf']!;
  String get and => _localizedValues[locale.languageCode]!['and']!;
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]!['privacyPolicy']!;
  String get agreeTo => _localizedValues[locale.languageCode]!['agreeTo']!;
  String get byClicking =>
      _localizedValues[locale.languageCode]!['byClicking']!;
  String get termsOfService =>
      _localizedValues[locale.languageCode]!['termsOfService']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;

  String get signatureAddedSuccess =>
      _localizedValues[locale.languageCode]!['signatureAddedSuccess']!;
  String get signedDocumentShareText =>
      _localizedValues[locale.languageCode]!['signedDocumentShareText']!;
  String get savedToDownloads =>
      _localizedValues[locale.languageCode]!['savedToDownloads']!;
  String get storagePermissionDenied =>
      _localizedValues[locale.languageCode]!['storagePermissionDenied']!;
  String get downloadError =>
      _localizedValues[locale.languageCode]!['downloadError']!;
  String get share => _localizedValues[locale.languageCode]!['share']!;
  String get download => _localizedValues[locale.languageCode]!['download']!;
  String get addSignature =>
      _localizedValues[locale.languageCode]!['addSignature']!;
  String get errorAddingSignature =>
      _localizedValues[locale.languageCode]!['errorAddingSignature']!;
  String get placeSignature =>
      _localizedValues[locale.languageCode]!['placeSignature']!;
  String get tapToPlaceSignature =>
      _localizedValues[locale.languageCode]!['tapToPlaceSignature']!;
  String get privacyPolicyTitleText =>
      _localizedValues[locale.languageCode]!['privacyPolicyTitleText']!;
  String get privacyPolicyText =>
      _localizedValues[locale.languageCode]!['privacyPolicyText']!;
  String get termsOfServiceTitleText =>
      _localizedValues[locale.languageCode]!['termsOfServiceTitleText']!;
  String get termsOfServiceText =>
      _localizedValues[locale.languageCode]!['termsOfServiceText']!;
  String get signBelow => _localizedValues[locale.languageCode]!['signBelow']!;
  String get clear => _localizedValues[locale.languageCode]!['clear']!;
  String get saveSignature =>
      _localizedValues[locale.languageCode]!['saveSignature']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
