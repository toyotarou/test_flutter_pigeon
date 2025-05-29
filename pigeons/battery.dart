// pigeons/battery.dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/battery_api.g.dart',
    kotlinOut: 'android/app/src/main/kotlin/com/example/battery_pigeon_demo/BatteryApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.battery_pigeon_demo'),
  ),
)
@HostApi() // Flutter → Android 方向
abstract class BatteryApi {
  int getBatteryLevel(); // 0〜100 を返す
}
