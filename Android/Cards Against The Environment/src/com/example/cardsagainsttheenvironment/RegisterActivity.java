package com.example.cardsagainsttheenvironment;

import java.util.HashMap;

import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.EditText;

import com.parse.Parse;
import com.parse.ParseAnalytics;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

public class RegisterActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_register);
		
		Parse.initialize(this, "KfRZwxhtH70yJC1aUGr7kaS53UO7rRjXBuLukpb4", "UP8vGfiIB6kIRrursaeE1A7r59YGYUpWUluTeRoR");
		
		String usernameHelp = "username";
		String passwordHelp = "password";
		String emailHelp = "email";
		
		EditText username = (EditText) findViewById(R.id.username_register);
		username.setHint(usernameHelp);
		EditText password = (EditText) findViewById(R.id.password_register);
		password.setHint(passwordHelp);
		EditText email = (EditText) findViewById(R.id.email);
		email.setHint(emailHelp);
		
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.register, menu);
		return true;
	}
	
	
	public void registerUser(View v) {
		ParseUser user = new ParseUser();
		
		EditText username = (EditText) findViewById(R.id.username_register);
		EditText password = (EditText) findViewById(R.id.password_register);
		EditText email = (EditText) findViewById(R.id.email);
		
		HashMap[] rooms = {};
		
		user.setUsername(username.getText().toString());
		user.setPassword(password.getText().toString());
		user.setEmail(email.getText().toString());
		user.put("rooms", rooms);
		
		user.signUpInBackground(new SignUpCallback() {
			public void done(ParseException e) {
				if (e == null) {
					// Hooray! Let them use the app now.
			    } else {
			    	// Sign up didn't succeed. Look at the ParseException
			    	// to figure out what went wrong
			    	Log.d("AAAAHH", e.getMessage());
			    }
			}
		});
		
		finish();
	}

}
