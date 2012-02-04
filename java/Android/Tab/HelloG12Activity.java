package org.crix.sample;

import java.util.ArrayList;
import java.util.List;

import android.app.TabActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TabHost;

public class HelloG12Activity extends TabActivity implements TabHost.TabContentFactory {
    /** Called when the activity is first created. */
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TabHost th = this.getTabHost();
        th.addTab(th.newTabSpec("all").setIndicator("所有来电").setContent(this));
        th.addTab(th.newTabSpec("accept").setIndicator("已接来电").setContent(this));
        th.addTab(th.newTabSpec("cancel").setIndicator("未接来电").setContent(this));
    }

	public View createTabContent(String arg0) {
		// TODO Auto-generated method stub
		ListView lv = new ListView(this);
		List<String> list = new ArrayList<String>();
		list.add(arg0);
		if (arg0.equals("all")) {
			list.add("12345");
			list.add("10086");
			list.add("10000");
		} else if (arg0.equals("accept")) {
			list.add("12345");
			list.add("10086");
		} else if (arg0.equals("cancel")) {
			list.add("10000");
		}
		ArrayAdapter aa = new ArrayAdapter(this, android.R.layout.simple_list_item_checked, list);
		lv.setAdapter(aa);
		return lv;
	}
}