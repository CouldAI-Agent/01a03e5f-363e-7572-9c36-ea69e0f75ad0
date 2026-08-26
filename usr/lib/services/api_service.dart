import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_data.dart';

class ApiService {
  // Using public APIs for demo purposes. In production, use authenticated APIs like Binance, Alpha Vantage, etc.
  
  static Future<MarketData?> fetchBitcoinData() async {
    try {
      final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final btc = data['bitcoin'];
        return MarketData(
          symbol: 'BTC',
          name: 'بيتكوين',
          price: (btc['usd'] as num).toDouble(),
          change24h: (btc['usd_24h_change'] as num).toDouble(),
          lastUpdated: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error fetching BTC data: $e');
    }
    return null;
  }

  static Future<MarketData?> fetchGoldData() async {
    try {
      // Mocking Gold API since free reliable live gold APIs are rare without API keys.
      // In a real app, you would integrate with an API like GoldAPI.io
      // For now, we simulate a response based on typical market behavior.
      await Future.delayed(const Duration(milliseconds: 500));
      return MarketData(
        symbol: 'XAU',
        name: 'الذهب (أونصة)',
        price: 2450.50 + (DateTime.now().second % 10), // Simulated slight fluctuation
        change24h: 0.45,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error fetching Gold data: $e');
    }
    return null;
  }
}