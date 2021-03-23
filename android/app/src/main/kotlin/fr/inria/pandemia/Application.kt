package fr.inria.pandemia

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import rekab.app.background_locator.IsolateHolderService
import com.tekartik.sqflite.SqflitePlugin
import com.baseflow.geolocator.GeolocatorPlugin

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        IsolateHolderService.setPluginRegistrant(this)
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        if (!registry!!.hasPlugin("com.tekartik.sqflite")) {
            SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite"))
        }
        if (!registry!!.hasPlugin("com.baseflow.geolocator"))
            GeolocatorPlugin.registerWith(registry.registrarFor("com.baseflow.geolocator"))
    }
}