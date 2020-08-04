package com.raka.realmcrud.model

import io.realm.RealmList
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class User(
    @PrimaryKey var id:Long = 0,
    var name:String = "",
    var age: Int = 0,
    var notes:RealmList<Note> = RealmList(),
           var singleNote:Note?=null
):RealmObject() {
}