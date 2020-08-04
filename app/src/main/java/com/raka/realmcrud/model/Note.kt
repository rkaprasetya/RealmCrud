package com.raka.realmcrud.model

import io.realm.RealmObject

open class Note(var id:Int = 0,
               var text:String = ""):RealmObject() {
}