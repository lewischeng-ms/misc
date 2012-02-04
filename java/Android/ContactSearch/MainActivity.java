package org.crix.app;

import android.app.Activity;
import android.content.*;
import android.os.Bundle;
import android.view.View;
import android.view.View.*;
import android.widget.*;

public class MainActivity extends Activity {
	static final int RESULT_ACT_CODE = 1;
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == RESULT_ACT_CODE) {
			txtName.setText(String.valueOf(resultCode));
			return;
		}
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
	}

	Button btnFind;
	EditText txtName;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        btnFind = (Button)findViewById(R.id.button1);
        txtName = (EditText)findViewById(R.id.editText1);
        
        btnFind.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				String name = txtName.getText().toString();
				if (name.equals("")) return;
				Intent i = new Intent(MainActivity.this, ResultActivity.class);
				Bundle b = new Bundle();
				b.putString("name", name);
				i.putExtras(b);
				startActivityForResult(i, RESULT_ACT_CODE);
			}
        	
        });
    }
}