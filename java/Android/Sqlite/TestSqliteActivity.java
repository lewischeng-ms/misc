package com.crix.sample;

import android.app.Activity;
import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;

public class TestSqliteActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        DatabaseHelper helper = new DatabaseHelper(this, "haha.db", null, 1);
        SQLiteDatabase db = helper.getWritableDatabase();
        
        System.out.println("Clearing tables");
        db.delete("student", null, null);
        db.delete("class", null, null);
        
        System.out.println("Insert into class");
        ContentValues cv = new ContentValues();
        for (int i = 1; i <= 3; ++i) {
	        cv.put("clsno", i);
	        db.insert("class", null, cv);
        }
        
        System.out.println("Insert into student");
        // Class 1.
        cv.put("clsno", 1);
        
        cv.put("stuno", 11);
        cv.put("name", "Scott");
        cv.put("grade", 100);
        db.insert("student", null, cv);
        
        cv.put("stuno", 12);
        cv.put("name", "Tiger");
        cv.put("grade", 61);
        db.insert("student", null, cv);
        
        // Class 2.
        cv.put("clsno", 2);
        
        cv.put("stuno", 21);
        cv.put("name", "Mary");
        cv.put("grade", 73);
        db.insert("student", null, cv);
        
        cv.put("stuno", 22);
        cv.put("name", "Jack");
        cv.put("grade", 86);
        db.insert("student", null, cv);
        
        // Class 3.
        cv.put("clsno", 3);
        
        cv.put("stuno", 31);
        cv.put("name", "King");
        cv.put("grade", 99);
        db.insert("student", null, cv);
        
        cv.put("stuno", 32);
        cv.put("name", "Allen");
        cv.put("grade", 77);
        db.insert("student", null, cv);
        
        // Not valid.
        cv.put("clsno", 4);
        cv.put("stuno", 41);
        cv.put("name", "Gates");
        cv.put("grade", 50);
        db.insert("student", null, cv);
        
        db.delete("student", "stuno = ?", new String[]{ "41" });
        
        // Update
        System.out.println("Update record");
        cv.clear();
        cv.put("name", "Alloy");
        db.update("student", cv, "stuno = ?", new String[] { "32" });
        
        // Query
        System.out.println("Query");
        Cursor c = db.query(
    		"student",
    		new String[]{ "clsno", "avg(grade)" },
    		"name <> ?",
    		new String[] { "King" },
    		"clsno",
    		"clsno <> 2",
    		"clsno");
        while (c.moveToNext()) {
        	System.out.println("Class: " + c.getInt(0) + ", Average Grade: " + c.getInt(1));
        }
        
        // Upgrade db.
        helper = new DatabaseHelper(this, "haha.db", null, 2);
        helper.getReadableDatabase();
    }
}