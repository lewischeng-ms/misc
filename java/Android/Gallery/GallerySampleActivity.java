package org.crix.sample;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.*;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.AnimationUtils;
import android.widget.*;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ViewSwitcher.ViewFactory;

public class GallerySampleActivity extends Activity implements ViewFactory {
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
	
	ImageSwitcher sw;
	Gallery g;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.main);
        
        sw = (ImageSwitcher)findViewById(R.id.imageSwitcher1);
        sw.setFactory(this);
        sw.setInAnimation(AnimationUtils.loadAnimation(this, android.R.anim.fade_in));
        sw.setOutAnimation(AnimationUtils.loadAnimation(this, android.R.anim.fade_out));
        
        g = (Gallery)findViewById(R.id.gallery1);
        g.setAdapter(new MyAdapter());
        g.setOnItemSelectedListener(new OnItemSelectedListener() {

			@Override
			public void onItemSelected(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				// TODO Auto-generated method stub
				sw.setImageResource(imgs[arg2]);
			}

			@Override
			public void onNothingSelected(AdapterView<?> arg0) {
				// TODO Auto-generated method stub
				
			}
        	
        });
    }
    
    class MyAdapter extends BaseAdapter {

    	
		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return imgs.length;
		}

		@Override
		public Object getItem(int arg0) {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public long getItemId(int arg0) {
			// TODO Auto-generated method stub
			return arg0;
		}

		@Override
		public View getView(int arg0, View arg1, ViewGroup arg2) {
			// TODO Auto-generated method stub
			ImageView view = new ImageView(GallerySampleActivity.this);
			view.setAdjustViewBounds(true);
			view.setLayoutParams(new Gallery.LayoutParams(200, 200));
			view.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
			view.setImageResource(imgs[arg0]);
			return view;
		}
    	
    }

	@Override
	public View makeView() {
		// TODO Auto-generated method stub
		ImageView view = new ImageView(this);
		view.setScaleType(ImageView.ScaleType.FIT_CENTER);
		view.setLayoutParams(new ImageSwitcher.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
		return view;
	}
}