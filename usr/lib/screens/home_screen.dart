import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/market_provider.dart';
import '../models/market_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('روبوت تحليل السوق', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: () => context.read<MarketProvider>().fetchData(),
          child: Consumer<MarketProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.bitcoin == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildStatusHeader(provider.isLoading),
                  const SizedBox(height: 20),
                  _buildMarketCard(context, provider.bitcoin, Icons.currency_bitcoin, Colors.orange),
                  const SizedBox(height: 16),
                  _buildMarketCard(context, provider.gold, Icons.monetization_on, Colors.amber),
                  const SizedBox(height: 24),
                  _buildAnalysisSection(provider.bitcoin, provider.gold),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(bool isUpdating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'الأسعار المباشرة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (isUpdating)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text('محدث', style: TextStyle(color: Colors.green)),
            ],
          ),
      ],
    );
  }

  Widget _buildMarketCard(BuildContext context, MarketData? data, IconData icon, Color iconColor) {
    if (data == null) return const Card(child: ListTile(title: Text('جاري التحميل...')));

    final isPositive = data.priceChangePercentage24h >= 0;
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: iconColor.withOpacity(0.2),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Text(
                  data.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  data.symbol,
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('السعر الحالي', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      currencyFormat.format(data.price),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isPositive ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${data.change24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            Text(
              'آخر تحديث: ${DateFormat('HH:mm:ss').format(data.lastUpdated)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection(MarketData? btc, MarketData? gold) {
    if (btc == null || gold == null) return const SizedBox();

    String analysisText = 'الأسواق مستقرة حالياً. ';
    if (btc.change24h > 2) {
      analysisText += 'يوجد زخم إيجابي قوي في البيتكوين. ';
    } else if (btc.change24h < -2) {
      analysisText += 'يشهد البيتكوين تراجعاً ملحوظاً. ';
    }

    if (gold.change24h > 0.5) {
      analysisText += 'الذهب في مسار تصاعدي كملاذ آمن.';
    } else if (gold.change24h < -0.5) {
      analysisText += 'الذهب يشهد بعض الضغوط البيعية.';
    }

    return Card(
      color: Colors.blue.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.analytics, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'تحليل الروبوت الذكي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              analysisText,
              style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}