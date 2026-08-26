import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/market_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarketProvider()..startAutoUpdate()),
      ],
      child: const MarketAnalyzerApp(),
    ),
  );
}

class MarketAnalyzerApp extends StatelessWidget {
  const MarketAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'روبوت تحليل السوق',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E293B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Cairo', // Assuming standard arabic font support or fallback
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}
