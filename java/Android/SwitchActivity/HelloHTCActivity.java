package org.crix.sample;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

public class HelloHTCActivity extends Activity {
	Spinner sp;
	Button btn;
	ListView lv;
	AutoCompleteTextView tv;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        sp = (Spinner)findViewById(R.id.spinner1);
        String[] strs = { "CEO", "CTO", "CFO" };
        @SuppressWarnings({ "rawtypes", "unchecked" })
		ArrayAdapter aa = new ArrayAdapter(this, android.R.layout.simple_spinner_item, strs);
        sp.setAdapter(aa);
        
        btn = (Button)findViewById(R.id.button7);
        btn.setOnClickListener(new OnClickListener() {

			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				Bundle b = new Bundle();
				b.putString("Pos", sp.getSelectedItem().toString());
				Intent i = new Intent(HelloHTCActivity.this, ResultActivity.class);
				i.putExtra("data", b);
				// i.putExtras(b);
				startActivity(i);
			}
        	
        });
        
        lv = (ListView)findViewById(R.id.listView1);
        List lst = new ArrayList();
        lst.add("abc");
        lst.add("bcd");
        lst.add("cde");
        lst.add("def");
        lst.add("efg");
        lst.add("fgh");
        ArrayAdapter aa1 = new ArrayAdapter(this, android.R.layout.simple_list_item_checked, lst);
        lv.setAdapter(aa1);
        
        tv = (AutoCompleteTextView)findViewById(R.id.autoCompleteTextView1);
        String[] strs1 = { "ab", "abc", "abcd", "abcde", "abcdef" };
        ArrayAdapter aa2 = new ArrayAdapter(this, android.R.layout.simple_dropdown_item_1line, strs1);
        tv.setAdapter(aa2);
    }
}