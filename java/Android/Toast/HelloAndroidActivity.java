package org.crix.sample;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;

public class HelloAndroidActivity extends Activity {
	Button longToast;
	Button shortToast;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        longToast = (Button)findViewById(R.id.button2);
        longToast.setOnClickListener(new OnClickListener() {

			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				Toast t = Toast.makeText(HelloAndroidActivity.this, "长时间提示信息", Toast.LENGTH_LONG);
				t.show();
			}
        	
        });
        shortToast = (Button)findViewById(R.id.button1);
        shortToast.setOnClickListener(new OnClickListener() {

			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				Toast t = Toast.makeText(getApplicationContext(), "短时间提示信息", Toast.LENGTH_SHORT);
				t.show();
			}
        	
        });
    }
}