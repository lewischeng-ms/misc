package org.crix.sample;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.SubMenu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.*;

public class HelloMotoActivity extends Activity {
	ImageView img;
	MenuInflater menu;
	EditText et;
	String[] options = { "Blood", "Wine", "Scarf" };
	
	@Override
	public boolean onContextItemSelected(MenuItem item) {
		// TODO Auto-generated method stub
		switch (item.getItemId()) {
		case 0x123450: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setMessage("你剪切了")
					.setCancelable(false)
					.setPositiveButton("确定", null)
					.create();
			dlg.show();
			break;
		}
		case 0x123451: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setMessage("你复制了")
					.setCancelable(false)
					.setPositiveButton("确定", null)
					.create();
			dlg.show();
			break;
		}
		case 0x123452: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setMessage("你粘贴了")
					.setCancelable(false)
					.setPositiveButton("确定", null)
					.create();
			dlg.show();
			break;
		}
		}
		return super.onContextItemSelected(item);
	}
	
	@Override
	public void onCreateContextMenu(ContextMenu menu, View v,
			ContextMenuInfo menuInfo) {
		// TODO Auto-generated method stub
		if (v == img) {
			menu.add(ContextMenu.NONE, 0x123450, ContextMenu.NONE, "剪切");
			menu.add(ContextMenu.NONE, 0x123451, ContextMenu.NONE, "复制");
			menu.add(ContextMenu.NONE, 0x123452, ContextMenu.NONE, "粘贴");
		}
		super.onCreateContextMenu(menu, v, menuInfo);
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// TODO Auto-generated method stub
		switch (item.getItemId()) {
		case R.id.aboutitem: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setMessage("About dialog\nEnjoy Android")
					.setCancelable(false)
					.setPositiveButton("确定", null)
					.create();
			dlg.show();
			break;
		}
		case R.id.exititem: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setMessage("Do you really want to exit?")
					.setCancelable(false)
					.setPositiveButton("Yes", new DialogInterface.OnClickListener() {

						public void onClick(DialogInterface arg0, int arg1) {
							// TODO Auto-generated method stub
							finish();
						}
						
					})
					.setNegativeButton("No", null)
					.create();
			dlg.show();
		}
		case 0x124450: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setSingleChoiceItems(options, -1, new DialogInterface.OnClickListener() {
						
						public void onClick(DialogInterface arg0, int arg1) {
							// TODO Auto-generated method stub
							et.setText(options[arg1]);
						}
					})
					.setTitle("你选了红色，请进一步选择红色产品")
					.setCancelable(false)
					.setPositiveButton("确定", null)
					.create();
			dlg.show();
			break;
		}
		case 0x124451: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setMessage("你选了绿色")
					.setCancelable(false)
					.setPositiveButton("确定", null)
					.create();
			dlg.show();
			break;
		}
		case 0x124452: {
			AlertDialog.Builder bld = new AlertDialog.Builder(this);
			AlertDialog dlg = bld
					.setMessage("你选了蓝色")
					.setCancelable(false)
					.setPositiveButton("确定", null)
					.create();
			dlg.show();
			break;
		}
		}
		return super.onOptionsItemSelected(item);
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// TODO Auto-generated method stub
		this.menu.inflate(R.menu.main_menu, menu);
		menu.add(Menu.NONE, Menu.NONE, Menu.NONE, "开始");
		menu.add(Menu.NONE, Menu.NONE, Menu.NONE, "设置");
		SubMenu edit = (menu.findItem(R.id.edititem)).getSubMenu();
		edit.setGroupCheckable(0xff, true, true);
		edit.add(0xff, 0x124450, SubMenu.NONE, "红色");
		edit.add(0xff, 0x124451, SubMenu.NONE, "绿色");
		edit.add(0xff, 0x124452, SubMenu.NONE, "蓝色");
		return super.onCreateOptionsMenu(menu);
	}

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        menu = new MenuInflater(this);
        
        
        img = (ImageView)findViewById(R.id.imageView1);
        img.setOnClickListener(new OnClickListener() {

			public void onClick(View arg0) {
				// TODO Auto-generated method stub
				Resources res = getResources();
				Drawable d = res.getDrawable(R.drawable.hello2);
				img.setImageDrawable(d);
			}
        	
        });
        registerForContextMenu(img);
        
        et = (EditText)findViewById(R.id.editText1);
    }
}