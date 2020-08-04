package com.raka.realmcrud.model

import io.realm.RealmObject

open class Student(var name:String?=null,
var age:Int?=null):RealmObject()