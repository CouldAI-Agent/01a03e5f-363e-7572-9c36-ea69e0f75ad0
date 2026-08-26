import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/market_data.dart';
import '../services/api_service.dart';

class MarketProvider with ChangeNotifier {
  MarketData? _bitcoin;
  MarketData? _gold;
  bool _isLoading = false;
  Timer? _timer;

  MarketData? get bitcoin => _bitcoin;
  MarketData? get gold => _gold;
  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    final btcFuture = ApiService.fetchBitcoinData();
    final goldFuture = ApiService.fetchGoldData();

    final results = await Future.wait([btcFuture, goldFuture]);
    
    if (results[0] != null) _bitcoin = results[0];
    if (results[1] != null) _gold = results[1];

    _isLoading = false;
    notifyListeners();
  }

  void startAutoUpdate() {
    fetchData(); // Initial fetch
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}