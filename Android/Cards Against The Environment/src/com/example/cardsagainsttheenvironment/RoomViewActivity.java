package com.example.cardsagainsttheenvironment;

import java.util.List;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseException;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;

public class RoomViewActivity extends Activity {
	ParseObject room;
	Button choose;
    Button judge;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_room_view);
		
		Intent sender = getIntent();
        boolean isJudge = sender.getExtras().getBoolean("isJudge");
        Log.d("isJudge", isJudge + "");
        
        choose = (Button) findViewById(R.id.choose_button);
        judge = (Button) findViewById(R.id.judge_button);
        if (isJudge) {
        	choose.setEnabled(false);
        	judge.setEnabled(false);
        }
        else
        {
        	choose.setEnabled(true);
        	judge.setEnabled(false);
        }
        
        //select black card
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Room");
        query.whereEqualTo("playerName", "Dan Stemkoski");
        query.findInBackground(new FindCallback<ParseObject>() {
            public void done(List<ParseObject> roomList, ParseException e) {
                if (e == null) {
                    Log.d("score", "Retrieved " + roomList.size() + " scores");
                } else {
                    Log.d("score", "Error: " + e.getMessage());
                }
            }
        });
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.room_view, menu);
		return true;
	}
	
	
	public void launchWhiteCardScreen(View v) {
		Intent i = new Intent(RoomViewActivity.this, PickWhiteActivity.class);
		startActivity(i);
	}

}
