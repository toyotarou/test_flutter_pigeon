import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/native_apis.g.dart',
    kotlinOut: 'android/app/src/main/kotlin/com/example/battery_pigeon_demo/NativeApis.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.battery_pigeon_demo'),
  ),
)
@HostApi() // バッテリー用
abstract class BatteryApi {
  int getBatteryLevel(); // 0-100 (%)
}

@HostApi() // 歩数用
abstract class StepCounterApi {
  int getTotalSteps(); // 端末起動後の総歩数
}
