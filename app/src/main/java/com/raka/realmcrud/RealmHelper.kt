package com.raka.realmcrud

import android.util.Log
import com.raka.realmcrud.model.Note
import com.raka.realmcrud.model.User
import io.realm.Realm
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.createObject

class RealmHelper(private val realm: Realm) {
    private fun saveUser(){
        realm.executeTransactionAsync ({
            var maxId = realm.where(User::class.java).max("id")
            if (maxId == null){
                maxId = 1
            }else{
                maxId = maxId.toInt()+1
            }
            val notes:RealmList<Note> = RealmList()
            for (noteCount in 0 until 10){
                val note = realm.createObject<Note>()
                note.apply {
                    id = noteCount
                    text = "note${noteCount}"
                }
                notes.add(note)
            }
            val user = User(maxId.toLong(),"Raka",20,notes,null)
            realm.copyToRealm(user)
        },{ Log.e("On success","onsuccess")},{Log.e("onerror","onerror")})
    }
    private fun deleteUser(){
        //delete object from realm where id == value
        val user:RealmResults<User> = realm.where(User::class.java).equalTo("id","1").findAll()
        realm.executeTransactionAsync { user.deleteAllFromRealm() }
    }
    private fun deleteUserTable(){
        //delete User Table
        realm.executeTransactionAsync { it.delete(User::class.java) }
    }
}