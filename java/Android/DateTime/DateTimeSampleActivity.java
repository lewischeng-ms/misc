package org.crix.sample;

import java.util.Calendar;

import android.app.*;
import android.app.DatePickerDialog.OnDateSetListener;
import android.app.TimePickerDialog.OnTimeSetListener;
import android.os.Bundle;
import android.view.View;
import android.view.View.*;
import android.widget.*;

public class DateTimeSampleActivity extends Activity {
	static final int DLG_DATE = 0;
	static final int DLG_TIME = 1;
	
	Button btnDate;
	Button btnTime;
	TextView txtTime;
	Calendar c;
	
	int year;
	int month;
	int day;
	int hour;
	int minute;
	private OnDateSetListener ld = new OnDateSetListener() {
		@Override
		public void onDateSet(DatePicker arg0, int arg1, int arg2, int arg3) {
			// TODO Auto-generated method stub
			year = arg1;
			month = arg2;
			day = arg3;
			txtTime.setText(getDateTimeString());
		}
	};
	private OnTimeSetListener lt = new OnTimeSetListener() {
		@Override
		public void onTimeSet(TimePicker arg0, int arg1, int arg2) {
			// TODO Auto-generated method stub
			hour = arg1;
			minute = arg2;
			txtTime.setText(getDateTimeString());
		}
	};
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        btnDate = (Button)findViewById(R.id.button1);
        btnTime = (Button)findViewById(R.id.button2);
        txtTime = (TextView)findViewById(R.id.text1);
        
        c = Calendar.getInstance();
        year = c.get(Calendar.YEAR);
        month = c.get(Calendar.MONTH);
        day = c.get(Calendar.DAY_OF_MONTH);
        hour = c.get(Calendar.HOUR);
        minute = c.get(Calendar.MINUTE);
        
        txtTime.setText(getDateTimeString());
        
        btnDate.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				showDialog(DLG_DATE);
			}
        });
        btnTime.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				showDialog(DLG_TIME);
			}
        });
    }
    
    @Override
	protected Dialog onCreateDialog(int id) {
		// TODO Auto-generated method stub
    	switch (id) {
    	case DLG_DATE:
    		return new DatePickerDialog(this, ld, year, month, day);
    	case DLG_TIME:
    		return new TimePickerDialog(this, lt, hour, minute, false);
    	}
		return super.onCreateDialog(id);
	}

	private String getDateTimeString() {
    	StringBuilder sb = new StringBuilder();
    	sb.append("时间快照：");
    	sb.append(year);
    	sb.append("年");
    	sb.append(month);
    	sb.append("月");
    	sb.append(day);
    	sb.append("日");
    	sb.append(hour);
    	sb.append("时");
    	sb.append(minute);
    	sb.append("分");
    	
    	return sb.toString();
    }
}