package org.crix.sample;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import android.app.Activity;
import android.app.ListActivity;
import android.os.Bundle;
import android.widget.SimpleAdapter;

public class Test3Activity extends ListActivity {
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
        HashMap<String, String> map1 = new HashMap<String, String>();
        HashMap<String, String> map2 = new HashMap<String, String>();
        HashMap<String, String> map3 = new HashMap<String, String>();
        map1.put("username", "Tom");
        map1.put("user_ip", "192.168.1.24");
        map2.put("username", "Jerry");
        map2.put("user_ip", "192.168.1.25");
        map3.put("username", "Stone");
        map3.put("user_ip", "192.168.1.26");
        list.add(map1);
        list.add(map2);
        list.add(map3);
        SimpleAdapter adapter = new SimpleAdapter(
        		this,
        		list,
        		R.layout.listitem,
        		new String[] { "username", "user_ip" },
        		new int[] { R.id.tv1, R.id.tv2 }
        );
        setListAdapter(adapter);
    }
}