package com.example.make_a_req

//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.PendingIntent
//import android.content.ContentResolver
//import android.content.Context
import android.content.Intent
//import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
//import androidx.core.app.NotificationCompat
//import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

//    companion object {
//        private const val CHANNEL = "com.example.make_a_req"
//    }
//
//
//    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
//        super.onCreate(savedInstanceState, persistentState)
//
//    }
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//
//        val intent = Intent(this, MainActivity::class.java).apply {
//            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
//        }
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            startForegroundService(intent)
//        } else {
//            startService(intent)
//        }
//
//    }


//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//
//        createNotificationChannel()
//
////        sendNotification()
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//
//            if (call.method == "startService") {
//                sendNotification()
//                result.success("Service started")
//            } else if (call.method == "stopService") {
//                cancelNotification()
//                result.success("Service stopped")
//            } else {
//                result.notImplemented()
//            }
//
//    }
//
//
//    }

//    private fun createNotificationChannel() {
//
//        val channelID = "channel_id_make_a_req"
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//
//            val name = "Default Channel"
//            val description = "This is the default channel"
//            val importance = NotificationManager.IMPORTANCE_DEFAULT
//
//            val channel = NotificationChannel(channelID, name, importance).apply { this.description = description }
//
//            val notificationManager: NotificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//            notificationManager.createNotificationChannel(channel)
//        }
//    }
//
//    private fun sendNotification() {
//
//        val channelID = "channel_id_make_a_req"
//        val notificationID = 101
//
//        val intent = Intent(this, MainActivity::class.java).apply {
//            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
//        }
//
//        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)
//
//        val sound: Uri =
//            Uri.parse((ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + this.packageName) + "/" + R.raw.notification9)
//
//
//        val builder = NotificationCompat.Builder(this, channelID)
//            .setContentText("Hello World from Make A Req!")
//            .setContentTitle("My Kotlin notification")
//            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .setAutoCancel(true)
//            .setVibrate(longArrayOf(1000, 500, 1000, 500, 1000))
//            .setOngoing(true)
//            .setContentIntent(pendingIntent)
//            .setSound(sound)
//            .setCategory(NotificationCompat.CATEGORY_MESSAGE)
//
//        with(NotificationManagerCompat.from(this)) {
//            notify(notificationID, builder.build())
//        }
//    }
//
//    private fun cancelNotification() {
//        val notificationID = 101
//        NotificationManagerCompat.from(this).cancel(notificationID)
//    }

}
