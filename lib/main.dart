import 'package:flutter/material.dart';
import 'battery_api.g.dart'; // ← 自動生成ファイルを import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BatteryApp());
}

final _api = BatteryApi(); // Kotlin 側と話す窓口

class BatteryApp extends StatelessWidget {
  const BatteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery Pigeon Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const BatteryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  String _text = 'バッテリー残量: -- %';

  ///
  Future<void> _fetchLevel() async {
    setState(() => _text = '取得中...');
    try {
      final int? level = await _api.getBatteryLevel();
      setState(() => _text = 'バッテリー残量: $level %');
    } catch (e) {
      setState(() => _text = 'エラー: $e');
    }
  }

  ///
  @override
  void initState() {
    super.initState();
    _fetchLevel();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery (Pigeon)')),
      body: Center(child: Text(_text, style: Theme.of(context).textTheme.headlineMedium)),
      floatingActionButton: FloatingActionButton(onPressed: _fetchLevel, child: const Icon(Icons.refresh)),
    );
  }
}
