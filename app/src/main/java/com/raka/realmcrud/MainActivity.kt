package com.raka.realmcrud

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.raka.realmcrud.model.Note
import com.raka.realmcrud.model.Student
import com.raka.realmcrud.model.User
import io.realm.Realm
import io.realm.RealmList
import io.realm.RealmResults
import io.realm.kotlin.createObject

class MainActivity : AppCompatActivity() {
    private lateinit var realm:Realm
    private val TAG = MainActivity::class.java.simpleName
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        realm = Realm.getDefaultInstance()
        deleteDataInDb()
        createDummyData()
    }
    private fun deleteDataInDb(){
        realm.beginTransaction()// to execute the query always begin with this line
        realm.deleteAll()// Delete all data in DB once the activity is created
        realm.commitTransaction()// to execute the query always end with this line
    }
    private fun readData(){
        val students = realm.where(Student::class.java).findAll()
        var response = ""
        students.forEach {
            response = response + "Name : ${it.name}, Age: ${it.age} \n"
        }
    }
    private fun createDummyData(){
        realm.executeTransactionAsync ({ realm ->
            for (userCount in 0 until 10){
                val user = realm.createObject<User>(userCount)
                user.apply {
                    name = "testName{$userCount}"
                    age = 30
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
                user.notes = notes
            }
        },{Log.e(TAG,"onsuccessid-> ${selectUserBasedOnId()} ---------- ${selectAllUser()} ")},{Log.e(TAG,"onerror ${it.message}")})
    }
    private fun selectAllUser():RealmResults<User>{
        return realm.where(User::class.java).findAllAsync()
    }
    private fun selectUserBasedOnId():RealmResults<User>?{
        //This query will return the first user that matches with the "0" id
        val id = 1
        return realm.where(User::class.java).equalTo("id",id).findAll()
    }
    private fun selectUsersWithNote(){
        //This query will return all the users that have a note with the text "note1"
        val users = realm.where(User::class.java).equalTo("notes.text","note1").findAll()
    }
}