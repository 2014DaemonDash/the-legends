package com.example.cardsagainsttheenvironment;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.parse.LogInCallback;
import com.parse.Parse;
import com.parse.ParseAnalytics;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

public class LoginActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		
		Parse.initialize(this, "KfRZwxhtH70yJC1aUGr7kaS53UO7rRjXBuLukpb4", "UP8vGfiIB6kIRrursaeE1A7r59YGYUpWUluTeRoR");
		
		String usernameHelp = "username";
		String passwordHelp = "password";
		
		EditText username = (EditText) findViewById(R.id.username);
		username.setHint(usernameHelp);
		EditText password = (EditText) findViewById(R.id.password);
		password.setHint(passwordHelp);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.login, menu);
		return true;
	}
	
	
	public void loginCheck(View view) {
		//check inputs here!
		EditText username = (EditText) findViewById(R.id.username);
		EditText password = (EditText) findViewById(R.id.password);
		
		Log.d("fields", username.getText() + "     " + password.getText());
		
		ParseUser.logInInBackground(username.getText().toString(), password.getText().toString(), new LogInCallback() {
			public void done(ParseUser user, ParseException e) {
			    if (user != null) {
			    	// Hooray! The user is logged in.
			    	Intent i = new Intent(LoginActivity.this, RoomsActivity.class);
	                startActivity(i);
			    } else {
			    	// Signup failed. Look at the ParseException to see what happened.
			    	Log.d("AAAAHH", e.getMessage());
			    }
			}
		});
	}
	
	
	public void openRegisterPage(View v) {
		Intent i = new Intent(LoginActivity.this, RegisterActivity.class);
		startActivity(i);
	}

}
