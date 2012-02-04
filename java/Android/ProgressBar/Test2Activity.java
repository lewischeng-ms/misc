package org.crix.sample;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ProgressBar;

public class Test2Activity extends Activity {
	ProgressBar pbLong;
	ProgressBar pbSpin;
	Button button;
	int i = 0;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        pbLong = (ProgressBar)findViewById(R.id.longProgress);
        System.out.println(pbLong.getMax());
        pbSpin = (ProgressBar)findViewById(R.id.spinProgress);
        button = (Button)findViewById(R.id.button1);
		button.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				
				if (i == 0) {
					pbLong.setVisibility(ProgressBar.VISIBLE);
					pbSpin.setVisibility(ProgressBar.VISIBLE);
					i += 10;
				} else if (i <= 90) {
					pbSpin.setProgress(i);
					pbLong.setProgress(i);
					pbLong.setSecondaryProgress(i + 10);
					i += 10;
				} else {
					pbLong.setVisibility(ProgressBar.INVISIBLE);
					pbSpin.setVisibility(ProgressBar.INVISIBLE);
					i = 0;
				}
				
			}
			
		});
    }
}