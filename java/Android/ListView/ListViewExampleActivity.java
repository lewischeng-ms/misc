package org.crix.sample;

import android.app.*;
import android.content.ContentResolver;
import android.database.*;
import android.os.Bundle;
import android.provider.*;
import android.provider.ContactsContract.PhoneLookup;
import android.util.Log;
import android.widget.*;

public class ListViewExampleActivity extends ListActivity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        /* String[] strs = { "C++", "Java", "Basic" };
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, strs);
        setListAdapter(adapter); */
        Cursor c = getContentResolver().query(ContactsContract.Contacts.CONTENT_URI,null, null, null, null);
        startManagingCursor(c);
        
        ListAdapter adapter = new SimpleCursorAdapter(
        		this,
        		android.R.layout.simple_list_item_1,
        		c,
        		new String[] { PhoneLookup.DISPLAY_NAME },
        		new int[] { android.R.id.text1 }
        );
        setListAdapter(adapter);
    }
}