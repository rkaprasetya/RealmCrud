package com.raka.realmcrud

import android.app.Application
import io.realm.Realm
import io.realm.RealmConfiguration

class MyApp:Application() {
    override fun onCreate() {
        super.onCreate()
        Realm.init(this)
        Realm.setDefaultConfiguration(getRealmConfig())
    }
    private fun getRealmConfig() = RealmConfiguration.Builder()

        .name("test.db.realm")
        .schemaVersion(1)
        .deleteRealmIfMigrationNeeded()
        .build()

}