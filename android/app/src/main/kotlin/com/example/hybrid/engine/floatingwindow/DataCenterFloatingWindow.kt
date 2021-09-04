package com.example.hybrid.engine.floatingwindow

import android.graphics.Rect
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEnginer

@RequiresApi(Build.VERSION_CODES.R)
class DataCenterFloatingWindow(flutterEnginer: FlutterEnginer) :
    AbstractFloatingWindow(flutterEnginer)