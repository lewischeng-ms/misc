package org.crix.sample;

import java.util.Collection;
import java.util.LinkedList;

import android.app.Activity;
import android.os.Bundle;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

public class MainActivity extends Activity {
	RadioGroup rgGender;
	RadioButton rbMale;
	RadioButton rbFemale;
	CheckBox cbMath;
	CheckBox cbIT;
	CheckBox cbMusic;
	
	String gender = "男";
	Collection<String> hobbies = new LinkedList<String>();
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        rbMale = (RadioButton)findViewById(R.id.radioMale);
        rbFemale = (RadioButton)findViewById(R.id.radioFemale);
        rgGender = (RadioGroup)findViewById(R.id.radioGroup1);
		rgGender.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				// TODO Auto-generated method stub
				if (checkedId == rbMale.getId()) {
					gender = rbMale.getText().toString();
				} else {
					gender = rbFemale.getText().toString();
				}
			}
		});
		
		CompoundButton.OnCheckedChangeListener lsnr = new CompoundButton.OnCheckedChangeListener() {

			@Override
			public void onCheckedChanged(CompoundButton buttonView,
					boolean isChecked) {
				// TODO Auto-generated method stub
				String hobby = buttonView.getText().toString();
				if (isChecked) {
					hobbies.add(hobby);
					String msg = "我是" + gender + "人，我喜欢";
					for (String s : hobbies) {
						msg = msg + s + " ";
					}
					Toast t = Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT);
					t.show();
				} else {
					hobbies.remove(hobby);
				}
			}
			
		};
		cbMath = (CheckBox)findViewById(R.id.checkBoxMath);
		cbIT = (CheckBox)findViewById(R.id.checkBoxIT);
		cbMusic = (CheckBox)findViewById(R.id.checkBoxMusic);
		cbMath.setOnCheckedChangeListener(lsnr);
		cbIT.setOnCheckedChangeListener(lsnr);
		cbMusic.setOnCheckedChangeListener(lsnr);
    }
}