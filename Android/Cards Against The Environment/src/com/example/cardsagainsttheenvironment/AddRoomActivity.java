package com.example.cardsagainsttheenvironment;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.EditText;

public class AddRoomActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_add_room);
		
		String roomHelp = "Room";
		String player1Help = "Player 1";
		
		EditText roomName = (EditText) findViewById(R.id.room_name);
		roomName.setHint(roomHelp);
		EditText player1 = (EditText) findViewById(R.id.player1);
		player1.setHint(player1Help);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.add_room, menu);
		return true;
	}
	
	
	public void addPlayer(View v) {
		//add new EditText, move button down
	}

}
