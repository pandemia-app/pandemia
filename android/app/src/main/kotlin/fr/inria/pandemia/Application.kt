package fr.inria.pandemia

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import rekab.app.background_locator.LocatorService
import com.tekartik.sqflite.SqflitePlugin

class   Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        LocatorService.setPluginRegistrant(this)
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        if (!registry!!.hasPlugin("com.tekartik.sqflite")) {
            SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite"))
        }
    }
}