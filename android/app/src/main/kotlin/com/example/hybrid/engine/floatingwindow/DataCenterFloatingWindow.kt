package com.example.hybrid.engine.floatingwindow

import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEnginer

@RequiresApi(Build.VERSION_CODES.O)
class DataCenterFloatingWindow(flutterEnginer: FlutterEnginer) :
    AbstractFloatingWindow(flutterEnginer) {
}