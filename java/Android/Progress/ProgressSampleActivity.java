package org.crix.sample;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.ProgressBar;

public class ProgressSampleActivity extends Activity {
	static final int PROGRESS_DIALOG = 1;
	static final int MSG_SET_DLG = 1;
	static final int MSG_SET_BAR = 2;
	static final int MSG_DISMISS_DLG = -1;
	ProgressDialog dlg;
	ProgressThread th;
	ProgressBarThread th1;
	
	boolean showProgressBar = false;
	
	Button btn;
	Button btn1;
	ProgressBar pb;
	
    // Define the Handler that receives messages from the thread and update the progress
	// 注意这里必须用这种复杂的办法，因为更新主UI的线程必须是主线程。
    final Handler handler = new Handler() {
        public void handleMessage(Message msg) {
        	switch (msg.arg1) {
        	case MSG_SET_DLG:
        		dlg.setProgress(msg.arg2);
        		break;
        	case MSG_DISMISS_DLG:
        		dismissDialog(PROGRESS_DIALOG);
        		break;
        	case MSG_SET_BAR:
        		pb.setProgress(msg.arg2);
        		break;
        	}
        }
    };
    
    class ProgressThread extends Thread {
    	public int Max;
    	public boolean Running = true;
    	
    	@Override
		public void run() {
    		Message msg;
			int i = 1;
			while (i <= Max && Running){
				msg = handler.obtainMessage();
				msg.arg1 = MSG_SET_DLG;
				msg.arg2 = i++;
				handler.sendMessage(msg);
				if (!Running) return;
				try {
					Thread.sleep(100);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			msg = handler.obtainMessage();
			msg.arg1 = MSG_DISMISS_DLG;
			handler.sendMessage(msg);
		}
    }
    
    class ProgressBarThread extends Thread {
    	public int Max;
    	public boolean Running = true;
    	
    	@Override
		public void run() {
    		Message msg;
			int i = 1;
			while (i <= Max && Running){
				msg = handler.obtainMessage();
				msg.arg1 = MSG_SET_BAR;
				msg.arg2 = i++;
				handler.sendMessage(msg);
				if (!Running) return;
				try {
					Thread.sleep(100);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
    }
	
	@Override
	protected void onPrepareDialog(int id, Dialog dialog) {
		if (id == PROGRESS_DIALOG) {
			dlg.setProgress(0);
			th = new ProgressThread();
			th.Max = 100;
			th.start();
		}
	}
	
    @Override
	protected Dialog onCreateDialog(int id) {
		// TODO Auto-generated method stub
    	if (id == PROGRESS_DIALOG) {
	    	dlg = new ProgressDialog(this);
	    	dlg.setTitle("进行中……");
			dlg.setIndeterminate(false);
			dlg.setMax(100);
			dlg.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
			dlg.setMessage("请稍后……");
			dlg.setCancelable(true);
			dlg.setOnCancelListener(new OnCancelListener() {

				@Override
				public void onCancel(DialogInterface arg0) {
					// TODO Auto-generated method stub
					th.Running = false;
				}
				
			});
			return dlg;
    	}
    	return null;
	}

	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
        setContentView(R.layout.main);
        
        btn = (Button)findViewById(R.id.button1);
        btn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				showDialog(PROGRESS_DIALOG);
			}
        	
        });
        
        btn1 = (Button)findViewById(R.id.button2);
        btn1.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				showProgressBar = !showProgressBar;
				setProgressBarIndeterminateVisibility(showProgressBar);
			}
        	
        });
        
        pb = (ProgressBar)findViewById(R.id.progressBar1);
        pb.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				th1 = new ProgressBarThread();
				th1.Max = 100;
				th1.start();
			}
        	
        });
    }
}