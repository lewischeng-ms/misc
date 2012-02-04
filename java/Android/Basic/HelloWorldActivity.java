package org.crix.sample;

import java.io.IOException;
import java.util.*;
import java.util.Map.Entry;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import android.app.Activity;
import android.content.res.Resources;
import android.content.res.XmlResourceParser;
import android.os.Bundle;
import android.view.View;
import android.view.View.*;
import android.widget.*;

public class HelloWorldActivity extends Activity {
	Button btnLogin;
	Button btnCancel;
	Button btnXML;
	EditText txtUser;
	EditText txtPwd;
	EditText txtXml;
	
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        btnLogin = (Button)findViewById(R.id.btnLogin);
        btnCancel = (Button)findViewById(R.id.btnCancel);
        btnXML = (Button)findViewById(R.id.btnXML);
        txtUser = (EditText)findViewById(R.id.txtUser);
        txtPwd = (EditText)findViewById(R.id.txtPwd);
        txtXml = (EditText)findViewById(R.id.txtXml);
        getWindow().setBackgroundDrawableResource(R.color.opaque_blue);
        Resources res = getResources();
        float x = res.getDimension(R.dimen.sixteen_sp);
        setTitle("Font size is " + x);
        btnLogin.setOnClickListener(new OnClickListener() {
			public void onClick(View arg0) {
				String username = getString(R.string.username);
				String pwd = getString(R.string.pwd);
				if (txtUser.getText().toString().equals(username) && txtPwd.getText().toString().equals(pwd))
					setTitle(R.string.login_ok);
				else
					setTitle(R.string.login_fail);
			}
        });
        btnCancel.setOnClickListener(new OnClickListener() {
			public void onClick(View arg0) {
				finish();
			}
        });
        btnXML.setOnClickListener(new OnClickListener() {
			public void onClick(View arg0) {		
				TreeMap<Integer, String> map = new TreeMap<Integer, String>();
				Resources res = getResources();
				XmlResourceParser xrp = res.getXml(R.xml.btb);
				try {
					while (true) {
						boolean end = false;
						int event = xrp.getEventType();
						switch (event) {
						case XmlPullParser.START_DOCUMENT:
							break;
						case XmlPullParser.END_DOCUMENT:
							end = true;
							break;
						case XmlPullParser.START_TAG:
							String tagName = xrp.getName();
							if (tagName.equals("group")) {
								String name = xrp.getAttributeValue(0);
								String order = xrp.getAttributeValue(1);
								int o = Integer.parseInt(order);
								map.put(o, name);
							}
							break;
						case XmlPullParser.END_TAG:
							break;
						}
						if (end)
							break;
						else
							xrp.next();
					}
					
					StringBuilder sb = new StringBuilder();
					Iterator<Entry<Integer, String>> i = map.entrySet().iterator();
					while (i.hasNext()) {
						sb.append(i.next().getValue() + "\n");
					}
					txtXml.setText(sb);
				} catch (XmlPullParserException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
        });
    }
}