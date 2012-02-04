package org.crix.sample;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class ResultActivity extends Activity {
	TextView txt1;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.result);
		
		Bundle b = getIntent().getBundleExtra("data");
		// Bundle b = getIntent().getExtras();
		
		txt1 = (TextView)findViewById(R.id.txt1);
		txt1.setText(b.getString("Pos"));
	}
}
