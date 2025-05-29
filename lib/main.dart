import 'package:flutter/material.dart';
import 'native_apis.g.dart';   // ← Pigeon が生成した単一ファイル

/// ネイティブへの窓口
final _batteryApi = BatteryApi();
final _stepApi    = StepCounterApi();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery & Steps Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _battery = '--';
  String _steps   = '--';

  /// バッテリーと歩数を取得
  Future<void> _refresh() async {
    setState(() {
      _battery = _steps = '取得中…';
    });

    // --- バッテリー ---
    int? battery;
    try {
      battery = await _batteryApi.getBatteryLevel();
    } catch (e, s) {
      debugPrint('BatteryApi エラー: $e\n$s');
    }

    // --- 歩数 ---
    int? steps;
    try {
      steps = await _stepApi.getTotalSteps();
    } catch (e, s) {
      debugPrint('StepCounterApi エラー: $e\n$s');
    }

    // --- 画面へ反映（例外時は短い文言だけ） ---
    setState(() {
      _battery = (battery != null && battery >= 0) ? '$battery %' : '取得失敗';
      _steps   = (steps   != null && steps   >= 0) ? '$steps 歩' : '取得失敗';
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Battery & Steps (Pigeon)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('バッテリー残量: $_battery', style: t.headlineMedium),
            const SizedBox(height: 12),
            Text('歩数（端末起動後）: $_steps', style: t.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
