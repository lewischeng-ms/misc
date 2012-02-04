package org.crix.sample;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.*;

public class GridViewSampleActivity extends Activity {
	GridView gv;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        gv = (GridView)findViewById(R.id.gridView1);
        gv.setNumColumns(4);
        /*
        gv.setNumColumns(3);
        String[] strs = { "a1", "a2", "a3", "b1", "b2", "b3", "c1", "c2" };
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_gallery_item, strs);
        gv.setAdapter(adapter); */
        
        gv.setAdapter(new MyAdapter());
    }
    
    class MyAdapter extends BaseAdapter {
    	
    	int[] imgs = {
    			R.drawable.p1,
    			R.drawable.p2,
    			R.drawable.p3,
    			R.drawable.p4,
    			R.drawable.p5,
    			R.drawable.p6,
    			R.drawable.p7,
    			R.drawable.p8,
    			R.drawable.p9
    	};

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return imgs.length;
		}

		@Override
		public Object getItem(int arg0) {
			// TODO Auto-generated method stub
			return arg0;
		}

		@Override
		public long getItemId(int arg0) {
			// TODO Auto-generated method stub
			return arg0;
		}

		@Override
		public View getView(int arg0, View arg1, ViewGroup arg2) {
			// TODO Auto-generated method stub
			ImageView view;
			if (arg1 == null) {
				view = new ImageView(GridViewSampleActivity.this);
				view.setLayoutParams(new GridView.LayoutParams(100, 100));
				view.setAdjustViewBounds(false);
				view.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
				view.setPadding(8, 8, 8, 8);
			} else {
				view = (ImageView)arg1;
			}
			view.setImageResource(imgs[arg0]);
			return view;
		}
    	
    }
}