package org.crix.sample;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.app.ListActivity;
import android.content.ContentResolver;
import android.database.Cursor;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.widget.SimpleAdapter;

public class ListContactsActivity extends ListActivity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        // ContactsContract.Contacts - 联系人表
        // ContactsContract.PhoneLookup - 对来电者快速查阅
        // ContactsContract.CommonDataKinds - 在查询了联系人表后，可以对各项进一步查询，如电话、EMAIL
        ContentResolver resolver = getContentResolver();
        Cursor main = resolver.query(
        		ContactsContract.Contacts.CONTENT_URI,
        		new String[] { 
        			ContactsContract.Contacts._ID,
        			ContactsContract.Contacts.DISPLAY_NAME,
        			ContactsContract.Contacts.HAS_PHONE_NUMBER
        		},
        		null,
        		null,
        		null
        );
        
        List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
        while (main.moveToNext()) {
        	String id = main.getString(0);
        	String name = main.getString(1);
        	int has_phone_number = main.getInt(2);
        	
        	HashMap<String, String> map = new HashMap<String, String>();
        	map.put("name", name);
        	
        	String number = null;
        	if (has_phone_number > 0) {
	        	Cursor phone = resolver.query(
	        			ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
	        			new String[] { ContactsContract.CommonDataKinds.Phone.NUMBER }, 
	        			ContactsContract.CommonDataKinds.Phone.CONTACT_ID + "=" + id,
	        			null,
	        			null);
	        	
	        	// 只要第一个有效号码。
	        	while (phone.moveToNext() && number == null) {
	        		number = phone.getString(0);
	        	}
        	}
        	
        	map.put("number", number);
        	list.add(map);
        }
        
        SimpleAdapter adapter = new SimpleAdapter(
        		this,
        		list,
        		R.layout.item_view,
        		new String[] { "name", "number" },
        		new int[] { R.id.tv1, R.id.tv2 }
        );
        setListAdapter(adapter);
    }
}