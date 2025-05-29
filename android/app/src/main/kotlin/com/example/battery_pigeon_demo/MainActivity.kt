package com.example.battery_pigeon_demo

import android.Manifest
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.BatteryManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

/** Flutter → Android で呼ばれる実装 */
class MainActivity : FlutterActivity(), BatteryApi {

    /* -------- バッテリー実装 -------- */
    override fun getBatteryLevel(): Long {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val bm = getSystemService(BATTERY_SERVICE) as BatteryManager
            bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY).toLong()
        } else {
            val intent = ContextWrapper(applicationContext)
                .registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            val level = intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
            val scale = intent?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
            (level * 100 / scale).toLong()
        }
    }

    /* -------- FlutterEngine へ API を登録 -------- */
    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)

        // BatteryApi は MainActivity 自身
        BatteryApi.setUp(engine.dartExecutor.binaryMessenger, this)

        // StepCounterApi は別クラス
        StepCounterApi.setUp(
            engine.dartExecutor.binaryMessenger,
            StepCounterApiImpl(this)
        )

        // 実行時パーミッションを要求
        requestActivityRecognitionPermissionIfNeeded()
    }

    /* -------- ACTIVITY_RECOGNITION の実行時許可 -------- */
    private fun requestActivityRecognitionPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return

        val perm = Manifest.permission.ACTIVITY_RECOGNITION
        val granted = ContextCompat.checkSelfPermission(this, perm) ==
                PackageManager.PERMISSION_GRANTED

        if (!granted) {
            ActivityCompat.requestPermissions(this, arrayOf(perm), 1001)
        }
    }
}
