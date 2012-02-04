package org.crix.app;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.*;
import android.provider.Contacts.People;

public class ResultActivity extends Activity {
	ListView lstInfo;
	Button btnOK;
	Intent i;

	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
    	setContentView(R.layout.result);
    	
    	lstInfo = (ListView)findViewById(R.id.listView1);
    	
    	i = getIntent();
    	Bundle b = i.getExtras();
    	String name = b.getString("name");
    	
    	String[] prj = { People._ID, People.NAME, People.NUMBER };
    	Uri uri = People.CONTENT_URI;
    	Cursor c = getContentResolver().query(uri, prj, People.NAME + " like \'%" + name + "%\'", null, People.NAME + " asc");
    	ArrayList<String> strs = new ArrayList<String>();
    	if (c.getCount() < 1) {
    		strs.add("Ã»ÕÒµ½");
    	} else {
    		while (c.moveToNext()) {
    			strs.add("ID: " + c.getString(0) + ", Name: " + c.getString(1) + ", Number: " + c.getString(2));
    		}
    	}
    	ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, strs);
    	lstInfo.setAdapter(adapter);
    	
    	btnOK = (Button)findViewById(R.id.button2);
    	btnOK.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				ResultActivity.this.setResult(188, i);
				ResultActivity.this.finish();
			}
    		
    	});
    }
}
