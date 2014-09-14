package com.example.cardsagainsttheenvironment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

public class AddRoomActivity extends Activity {
	public int player = 1;
	public List<EditText> players = new ArrayList<EditText>();
	public List<Map> playerObjArr = new ArrayList<Map>();
	String playerName;
	int playerListCounter = 0;
	EditText roomName;
	ParseUser currentUser;
	List<Integer> blackCards;
	List<Integer> whiteCards;
	ParseObject newRoom;
	List<ParseUser> globalUserList = new ArrayList<ParseUser>();
	AddRoomActivity ara = this;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_add_room);
		
		Parse.initialize(this, "KfRZwxhtH70yJC1aUGr7kaS53UO7rRjXBuLukpb4", "UP8vGfiIB6kIRrursaeE1A7r59YGYUpWUluTeRoR");
		
		String roomHelp = "Room";
		String player1Help = "Player " + player;
		
		EditText roomName = (EditText) findViewById(R.id.room_name);
		roomName.setHint(roomHelp);
		EditText player1 = (EditText) findViewById(R.id.player1);
		player1.setHint(player1Help);
		
		players.add(player1);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.add_room, menu);
		return true;
	}
	
	
	public void addPlayer(View v) {
		//add new EditText, move button down
		EditText newPlayer = new EditText(this);
		player++;
		newPlayer.setHint("Player " + player);
		newPlayer.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
		
		LinearLayout layout = (LinearLayout)findViewById(R.id.LinearLayout01);
		layout.addView(newPlayer);
		
		players.add(newPlayer);
	}
	
	
	public void startGame(View v) {
		Log.d("Test", "Starting game creation testing...");
		roomName = (EditText) findViewById(R.id.room_name);
		currentUser = ParseUser.getCurrentUser();
		newRoom = new ParseObject("Room");
		
		Map firstPlayerObj = new HashMap();
		firstPlayerObj.put("userId", currentUser.get("username"));
		firstPlayerObj.put("cardsInHand", 0);
		firstPlayerObj.put("points", 0);
		playerObjArr.add(firstPlayerObj);
		
		Log.d("RoomName", roomName.getText().toString());
		
		if (currentUser != null && roomName.getText().toString() != "" && players != null && players.size() > 0) {
			Log.d("Test", "Has a list of players to test");
			for (int i = 0; i < players.size(); i++) {
				
				playerName = players.get(i).getText().toString();
				Log.d("Test", "Player Name to test: " + playerName);
				
				ParseQuery<ParseUser> query = ParseUser.getQuery();
				query.whereEqualTo("username", playerName);
				query.findInBackground(new FindCallback<ParseUser>() {
				  public void done(List<ParseUser> userList, ParseException e) {
				    if (e == null) {
			            if (userList != null && userList.size() > 0) {
			            	Map playerObj = new HashMap();
			            	for(ParseUser u: userList)
			            		Log.d("UserList", u.getUsername());
			            	globalUserList.addAll(userList);
			            	String name = userList.get(0).getUsername();
			            	Log.d("Has a valid player name", name);
			            	playerObj.put("userId", name);
			            	playerObj.put("cardsInHand", 0);
			            	playerObj.put("points", 0);
			            	playerObjArr.add(playerObj);
			            }
			            
			            playerListCounter++;
			            Log.d("counter", playerListCounter + "");
			            Log.d("Players size", players.size() + "");
			            if (playerListCounter == players.size()) {
			            	Log.d("Test", "making room");
			            	
			            	newRoom.put("name", roomName.getText().toString());
			            	newRoom.put("currentJudge", currentUser.get("username"));
			            	newRoom.put("currentPlayer", currentUser.get("username"));
			            	newRoom.put("players", playerObjArr);
			            	newRoom.put("currentBlackCard", -1);
			            	
			            	blackCards = new ArrayList<Integer>();
			            	ParseQuery<ParseObject> query = ParseQuery.getQuery("BlackCards");
			            	query.findInBackground(new FindCallback<ParseObject>() {
			            	    public void done(List<ParseObject> blackCardList, ParseException e) {
			            	        if (e == null) {
			            	            for (ParseObject o : blackCardList) {
			            	            	blackCards.add(o.getInt("cardId"));
			            	            }
			            	            
			            	            int[] blackCardsArr = new int[blackCards.size()];
			            	            for (int i = 0; i < blackCards.size(); i++)
			            	            	blackCardsArr[i] = blackCards.get(i);
			            	            
			            	            newRoom.put("blackDeck", blackCards);
			            	            
			            	            whiteCards = new ArrayList<Integer>();
			            	            ParseQuery<ParseObject> query = ParseQuery.getQuery("WhiteCards");
						            	query.findInBackground(new FindCallback<ParseObject>() {
						            	    public void done(List<ParseObject> whiteCardList, ParseException e) {
						            	        if (e == null) {
						            	            for(ParseObject o : whiteCardList) {
						            	            	whiteCards.add(o.getInt("cardId"));
						            	            }
						            	            int[] whiteCardsArr = new int[whiteCards.size()];
						            	            for (int i = 0; i < whiteCards.size(); i++)
						            	            	whiteCardsArr[i] = whiteCards.get(i);
						            	            
						            	            newRoom.put("whiteDeck", whiteCards);
						            	            Log.d("Test", "everything fine so far");
						            	            
						            	            ParseACL defaultACL = new ParseACL();
						            	            defaultACL.setPublicReadAccess(false);
						            	            
						            	            for (ParseUser user : globalUserList) {
						            	            	defaultACL.setReadAccess(user, true);
						            	            	defaultACL.setWriteAccess(user, true);  
						            	            }
						            	            defaultACL.setReadAccess(currentUser, true);
					            	            	defaultACL.setWriteAccess(currentUser, true);
						            	            	 
						            	            newRoom.setACL(defaultACL);
						            	            ParseACL.setDefaultACL(defaultACL, false);
						            	            Log.d("New Room",newRoom.toString());
						            	            newRoom.saveInBackground();
						            	            
						            	            Intent i = new Intent(ara, RoomViewActivity.class);
						            	            
						            	            Log.d("id?",newRoom.getObjectId());
						            	            i.putExtra("roomId", newRoom.getObjectId());
						            	            
						            	            startActivity(i);
						            	        } else {
						            	            Log.d("score", "Error: " + e.getMessage());
						            	        }
						            	    }
						            	});
			            	            
			            	        } else {
			            	            Log.d("score", "Error: " + e.getMessage());
			            	        }
			            	    }
			            	});
			            	
			            }
				    } else {
				    	Log.d("Error", e.getMessage());
				    }
				  }
				});
				
			}

		} else {
		  // show the signup or login screen
		}
		
		
		
	}

}
