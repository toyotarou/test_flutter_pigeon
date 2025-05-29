package com.example.battery_pigeon_demo

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.HandlerThread
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withTimeoutOrNull

class StepCounterApiImpl(private val context: Context) : StepCounterApi {

    override fun getTotalSteps(): Long {
        val manager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val sensor = manager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) ?: return -1

        val deferred = CompletableDeferred<Long>()

        // ★ メイン UI スレッドをブロックしないよう、HandlerThread を用意
        val handlerThread = HandlerThread("step-counter-thread").apply { start() }
        val handler = Handler(handlerThread.looper)

        val listener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent?) {
                val value = event?.values?.firstOrNull()?.toLong() ?: -1
                if (!deferred.isCompleted) deferred.complete(value)
                manager.unregisterListener(this)
                handlerThread.quitSafely()
            }
            override fun onAccuracyChanged(s: Sensor?, accuracy: Int) {}
        }

        manager.registerListener(
            listener,
            sensor,
            SensorManager.SENSOR_DELAY_NORMAL,
            handler
        )

        // 最大 2 秒待って値が来なければ -1
        val result = runBlocking {
            withTimeoutOrNull(2_000) { deferred.await() } ?: -1
        }
        return result
    }
}
