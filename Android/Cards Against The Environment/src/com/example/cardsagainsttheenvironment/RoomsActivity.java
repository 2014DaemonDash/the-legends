package com.example.cardsagainsttheenvironment;

import java.util.List;

import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.View;

public class RoomsActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_rooms);
		
		ParseUser currentUser = ParseUser.getCurrentUser();
		if (currentUser != null) {
			List<String> rooms = (List<String>)currentUser.get("rooms");
			
			if(rooms != null && rooms.size() > 0) {
				Log.d("Rooms", rooms.toString());
				
				for(int i = 0, size = rooms.size(); i < size; i++) {
					//create room entries
				}
			}
			
			
		} else {
			// show the signup or login screen
		}
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.rooms, menu);
		return true;
	}
	
	public void addRoom(View v) {
		Intent i = new Intent(RoomsActivity.this, AddRoomActivity.class);
		startActivity(i);
	}

}
