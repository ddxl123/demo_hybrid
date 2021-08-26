package com.example.hybrid.engine.service

import android.app.Service
import com.example.hybrid.engine.manager.FlutterEnginer

abstract class AbstractService(flutterEnginer: FlutterEnginer) : Service()