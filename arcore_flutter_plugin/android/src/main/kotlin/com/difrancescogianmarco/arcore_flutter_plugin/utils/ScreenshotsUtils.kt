//package com.difrancescogianmarco.arcore_flutter_plugin.utils
//
//import java.nio.ByteBuffer
//import java.io.File
//import java.io.OutputStream
//import java.io.FileOutputStream
//import java.text.SimpleDateFormat
//import java.util.Date
//import android.content.pm.PackageManager;
//import android.view.PixelCopy
//import android.graphics.Canvas
//import android.os.Handler
//import android.os.Environment
//import android.os.Build
//import android.Manifest;
//import android.graphics.Bitmap
//import android.app.Activity
//import android.util.Log
//import io.flutter.plugin.common.MethodChannel
//import com.google.ar.sceneform.ArSceneView
//
//class ScreenshotsUtils {
//
//    companion object {
//
//        fun getPictureName(): String {
//
//            var sDate: String = SimpleDateFormat("yyyyMMddHHmmss").format(Date());
//
//            return "MyApp-" + sDate + ".png";
//        }
//
//
//        fun saveBitmap(bitmap: Bitmap,activity: Activity): String {
//
//
//            val externalDir = Environment.getExternalStorageDirectory().getAbsolutePath();
//
//            val sDir = externalDir + File.separator + "MyApp";
//
//            val dir = File(sDir);
//
//            val dirPath: String;
//
//            if( dir.exists() || dir.mkdir()) {
//                dirPath = sDir + File.separator + getPictureName();
//            } else {
//                dirPath = externalDir + File.separator + getPictureName();
//            }
//
//
//
//            try{
//
//                val file = File(dirPath)
//
//                // Get the file output stream
//                val stream: OutputStream = FileOutputStream(file)
//
//                // Compress bitmap
//                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
//
//                // Flush the stream
//                stream.flush()
//
//                // Close stream
//                stream.close()
//
//
//            }catch (e: Exception){
//                e.printStackTrace()
//            }
//
//
//            return dirPath;
//
//
//
//        }
//
//        fun permissionToWrite(activity: Activity): Boolean {
//
//            if(Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
//                Log.i("Sreenshot", "Permission to write false due to version codes.");
//
//                return false;
//            }
//
//            var perm = activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE);
//
//            if(perm == PackageManager.PERMISSION_GRANTED) {
//                Log.i("Sreenshot", "Permission to write granted!");
//
//                return true;
//            }
//
//            Log.i("Sreenshot","Requesting permissions...");
//            activity.requestPermissions(
//                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
//                11
//            );
//            Log.i("Sreenshot", "No permissions :(");
//
//            return false;
//        }
//
//
//        fun onGetSnapshot(arSceneView: ArSceneView?, result: MethodChannel.Result,activity: Activity){
//
//            if( !permissionToWrite(activity) ) {
//                Log.i("Sreenshot", "Permission to write files missing!");
//
//                result.success(null);
//
//                return;
//            }
//
//            if(arSceneView == null){
//                Log.i("Sreenshot", "Ar Scene View is NULL!");
//
//                result.success(null);
//
//                return;
//            }
//
//
//            try {
//
//                val view = arSceneView!!;
//
//                val bitmapImage: Bitmap = Bitmap.createBitmap(
//                    view.getWidth(),
//                    view.getHeight(),
//                    Bitmap.Config.ARGB_8888
//                );
//                Log.i("Sreenshot", "PixelCopy requesting now...");
//                PixelCopy.request(view, bitmapImage, { copyResult ->
//                    if (copyResult == PixelCopy.SUCCESS) {
//                        Log.i("Sreenshot", "PixelCopy request SUCESS. ${copyResult}");
//
//                        var pathSaved: String = saveBitmap(bitmapImage,activity);
//
//                        Log.i("Sreenshot", "Saved on path: ${pathSaved}");
//                        result.success(pathSaved);
//
//                    }else{
//                        Log.i("Sreenshot", "PixelCopy request failed. ${copyResult}");
//                        result.success(null);
//                    }
//
//                },
//                    Handler());
//
//            } catch (e: Exception){
//
//                e.printStackTrace()
//            }
//
//
//        }
//    }
//}


package com.difrancescogianmarco.arcore_flutter_plugin.utils

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.os.Build
import android.os.Environment
import android.os.Handler
import android.util.Log
import android.view.PixelCopy
import android.widget.Toast
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream
import java.text.SimpleDateFormat
import java.util.Date
import com.google.ar.sceneform.ArSceneView


class ScreenshotsUtils {

    companion object {

        private const val DIRECTORY_NAME = "Screenshots"
        private const val PERMISSION_REQUEST_CODE = 11

        fun getPictureName(): String {
            val sDate: String = SimpleDateFormat("yyyyMMddHHmmss").format(Date())
            return "MyApp-$sDate.png"
        }

        fun saveBitmap(bitmap: Bitmap, directory: File): String {
            val fileName = getPictureName()
            val file = File(directory, fileName)

            try {
                FileOutputStream(file).use { stream ->
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                    stream.flush()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            return file.absolutePath
        }

        fun permissionToWrite(activity: Activity): Boolean {
            return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                true
            } else {
                val permission = activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                if (permission == PackageManager.PERMISSION_GRANTED) {
                    true
                } else {
                    activity.requestPermissions(
                        arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                        PERMISSION_REQUEST_CODE
                    )
                    false
                }
            }
        }

        fun onGetSnapshot(arSceneView: ArSceneView?, result: MethodChannel.Result, activity: Activity) {
            if (!permissionToWrite(activity)) {
                Log.i("Screenshot", "Permission to write files missing!")
                result.success(null)
                return
            }

            if (arSceneView == null) {
                Log.i("Screenshot", "AR Scene View is NULL!")
                result.success(null)
                return
            }

            try {
                val view = arSceneView
                val bitmapImage: Bitmap = Bitmap.createBitmap(view.width, view.height, Bitmap.Config.ARGB_8888)
                Log.i("Screenshot", "PixelCopy requesting now...")

                PixelCopy.request(view, bitmapImage, { copyResult ->
                    if (copyResult == PixelCopy.SUCCESS) {
                        Log.i("Screenshot", "PixelCopy request SUCCESS. $copyResult")

                        // Use the DCIM/Screenshots directory
                        val screenshotsDir = File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM), DIRECTORY_NAME)
                        if (!screenshotsDir.exists()) {
                            screenshotsDir.mkdirs()
                        }

                        val pathSaved = saveBitmap(bitmapImage, screenshotsDir)
                        Log.i("Screenshot", "Saved on path: $pathSaved")
                        result.success(pathSaved)
                    } else {
                        Log.i("Screenshot", "PixelCopy request failed. $copyResult")
                        result.success(null)
                    }
                }, Handler())
            } catch (e: Exception) {
                e.printStackTrace()
                result.success(null)
            }
        }
    }
}
