import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// =======================================================
/// 🌙 APP ROOT WITH THEME + FONT SIZE
/// =======================================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// 🔥 ĐỂ SETTINGS PAGE GỌI ĐƯỢC
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 🌙 DARK MODE
  ThemeMode _themeMode = ThemeMode.light;

  /// 🔠 FONT SCALE (1.0 = mặc định)
  double _fontScale = 1.0;

  // ================= PUBLIC METHODS =================

  void toggleDarkMode(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void changeFontScale(double scale) {
    setState(() {
      _fontScale = scale;
    });
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🌙 THEME MODE
      themeMode: _themeMode,

      // ☀️ LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
        textTheme: _textTheme(Brightness.light),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      // 🌑 DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
        textTheme: _textTheme(Brightness.dark),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const AppRoot(),
    );
  }

  // ================= TEXT THEME =================

  TextTheme _textTheme(Brightness brightness) {
    final base =
    brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    return base.apply(
      fontSizeFactor: _fontScale,
    );
  }
}
