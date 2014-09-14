package com.example.cardsagainsttheenvironment;

import java.util.List;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseException;
import com.parse.ParseUser;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class RoomViewActivity extends Activity {
	ParseObject roomObj;
	Button choose;
    Button judge;
    ParseUser currentUser;
    TextView card;
    boolean isJudge;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_room_view);
		
		currentUser = ParseUser.getCurrentUser();
		if (currentUser == null)
			return;
		
		card = (TextView) findViewById(R.id.blackCard);
		
		Intent sender = getIntent();
        
        String roomId = sender.getExtras().getString("roomId");
        Log.d("roomId", roomId);
        
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Room");
        query.getInBackground(roomId, new GetCallback<ParseObject>() {
          public void done(ParseObject room, ParseException e) {
            if (e == null) {
            	roomObj = room;
            	int currBlackCardId = roomObj.getInt("currentBlackCard");
            	
            	String currJudge = (String)roomObj.get("currentJudge");
            	Log.d("currJudge in room", currJudge);
            	
            	isJudge = currJudge.equals(currentUser.getUsername());
            	Log.d("isJudge", isJudge + "");
            	
            	choose = (Button) findViewById(R.id.choose_button);
                judge = (Button) findViewById(R.id.judge_button);
                if (isJudge) {
                	judge.setEnabled(false);
                	choose.setText("Begin Next Round");
                	
                	if (currBlackCardId == -1) {
                		choose.setEnabled(true);
                	} else {
                		choose.setEnabled(false);
                	}
                	
                }
                else
                {
                	choose.setText("Choose Card");
                	choose.setEnabled(true);
                	judge.setVisibility(0);
                }
                
            } else {
            	Log.d("Error", e.getMessage());
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
	
	
	public void chooseButtonClicked(View v) {
		if (isJudge) {
			//select black card
            List<Integer> blackCards = (List<Integer>)roomObj.get("blackDeck");
            int rand = (int)(Math.random() * (blackCards.size() - 1));
            int selectedCardId = blackCards.get(rand);
            Log.d("cardId", selectedCardId + "");
            
            ParseQuery<ParseObject> query = ParseQuery.getQuery("BlackCards");
            query.whereEqualTo("cardId", selectedCardId);
            query.findInBackground(new FindCallback<ParseObject>() {
                public void done(List<ParseObject> cardList, ParseException e) {
                    if (e == null) {
                        if (cardList != null && cardList.size() > 0) {
                        	Log.d("CardText", cardList.get(0).getString("cardContent"));
                        	card.setText(cardList.get(0).getString("cardContent"));
                        	choose.setEnabled(false);
                        }
                    } else {
                        Log.d("CardText", "Error: " + e.getMessage());
                    }
                }
            });
		} else {
			Intent i = new Intent(RoomViewActivity.this, PickWhiteActivity.class);
			i.putExtra("roomId", roomObj.getObjectId());
			startActivity(i);
		}
	}

}
