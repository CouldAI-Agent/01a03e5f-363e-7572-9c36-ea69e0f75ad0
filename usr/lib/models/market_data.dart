class MarketData {
  final String symbol;
  final String name;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;

  MarketData({
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
  });

  factory MarketData.fromJson(Map<String, dynamic> json, String name, String symbol) {
    return MarketData(
      symbol: symbol,
      name: name,
      currentPrice: (json['usd'] ?? 0).toDouble(),
      priceChange24h: (json['usd_24h_change'] ?? 0).toDouble(), // Approximate, usually need full coin data for exact change but CoinGecko simple price offers it with flags
      priceChangePercentage24h: (json['usd_24h_change'] ?? 0).toDouble(),
    );
  }
}
