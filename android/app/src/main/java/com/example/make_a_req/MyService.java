package com.example.make_a_req;

import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;

import androidx.core.app.NotificationCompat;

/**
 * @author furkanozkan
 */
public class MyService extends Service {
//    public MyService() {
//    }
//
//    @Override
//    public void onCreate() {
//        super.onCreate();
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "notifications")
//                    .setContentText("This is running in background")
//                    .setContentTitle("Background Service")
//                    .setSmallIcon(R.drawable.ic_bg_service_small);
//
//            startForeground(101, builder.build());
//        }
//
//    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        // throw new UnsupportedOperationException("Not yet implemented");
        return null;
    }
}