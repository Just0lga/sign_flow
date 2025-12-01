import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sign_flow/screens/splash_screen.dart';
import 'screens/homepage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocaleProvider _localeProvider = LocaleProvider();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _localeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'PDF İmzalayıcı',
          locale: _localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('tr')],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
