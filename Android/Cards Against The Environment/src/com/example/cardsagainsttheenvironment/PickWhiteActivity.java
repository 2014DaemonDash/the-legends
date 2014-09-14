package com.example.cardsagainsttheenvironment;

import java.util.List;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.Parse;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class PickWhiteActivity extends Activity {
	ParseObject roomObj;
	boolean isJudge;
	ParseUser currentUser;
	RelativeLayout selectedCard;
	Button play;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_pick_white);
		
		Parse.initialize(this, "KfRZwxhtH70yJC1aUGr7kaS53UO7rRjXBuLukpb4", "UP8vGfiIB6kIRrursaeE1A7r59YGYUpWUluTeRoR");
		
		play = (Button) findViewById(R.id.play_card_button);
		play.setEnabled(false);
		
		currentUser = ParseUser.getCurrentUser();
		if (currentUser == null)
			return;
		
		Intent i = getIntent();
        
        String roomId = i.getExtras().getString("roomId");
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
            	
                if (isJudge) {
                	play.setVisibility(0);
                	play.setClickable(false);
                }
                else
                {
                	play.setClickable(true);
                }
                
                Log.d("List", roomObj.get("whiteDeck").toString());
                
        		//select white cards
                List<Integer> whiteCards = (List<Integer>)roomObj.get("whiteDeck");
               
                int[] randArr = new int[7];
                
                for(int n = 0; n < randArr.length; n++) {
                	randArr[n] = (int)(Math.random() * (whiteCards.size() - 1));
                	Log.d("cardId", randArr[n] + "");
                	int id = whiteCards.get(randArr[n]);
                	
                	
                } 
                
                
                ParseQuery<ParseObject> cardQuery1 = ParseQuery.getQuery("WhiteCards");
                cardQuery1.whereEqualTo("cardId", randArr[0]);
                cardQuery1.findInBackground(new FindCallback<ParseObject>() {
                    public void done(List<ParseObject> cardList, ParseException e) {
                        if (e == null) {
                            if (cardList != null && cardList.size() > 0) {
                            	Log.d("CardText", cardList.get(0).getString("cardContent"));
                            	
                            	TextView curr = (TextView) findViewById(R.id.Card1card);
                            	
                            	curr.setText(cardList.get(0).getString("cardContent"));
                            }
                        } else {
                            Log.d("CardText", "Error: " + e.getMessage());
                        }
                    }
                });
                
                ParseQuery<ParseObject> cardQuery2 = ParseQuery.getQuery("WhiteCards");
                cardQuery2.whereEqualTo("cardId", randArr[1]);
                cardQuery2.findInBackground(new FindCallback<ParseObject>() {
                    public void done(List<ParseObject> cardList, ParseException e) {
                        if (e == null) {
                            if (cardList != null && cardList.size() > 0) {
                            	Log.d("CardText", cardList.get(0).getString("cardContent"));
                            	
                            	TextView curr = (TextView) findViewById(R.id.Card2card);
                            	
                            	curr.setText(cardList.get(0).getString("cardContent"));
                            }
                        } else {
                            Log.d("CardText", "Error: " + e.getMessage());
                        }
                    }
                });
                
                ParseQuery<ParseObject> cardQuery3 = ParseQuery.getQuery("WhiteCards");
                cardQuery3.whereEqualTo("cardId", randArr[2]);
                cardQuery3.findInBackground(new FindCallback<ParseObject>() {
                    public void done(List<ParseObject> cardList, ParseException e) {
                        if (e == null) {
                            if (cardList != null && cardList.size() > 0) {
                            	Log.d("CardText", cardList.get(0).getString("cardContent"));

                            	TextView curr = (TextView) findViewById(R.id.Card3card);
                            	
                            	curr.setText(cardList.get(0).getString("cardContent"));
                            }
                        } else {
                            Log.d("CardText", "Error: " + e.getMessage());
                        }
                    }
                });
                
                ParseQuery<ParseObject> cardQuery4 = ParseQuery.getQuery("WhiteCards");
                cardQuery4.whereEqualTo("cardId", randArr[3]);
                cardQuery4.findInBackground(new FindCallback<ParseObject>() {
                    public void done(List<ParseObject> cardList, ParseException e) {
                        if (e == null) {
                            if (cardList != null && cardList.size() > 0) {
                            	Log.d("CardText", cardList.get(0).getString("cardContent"));

                            	TextView curr = (TextView) findViewById(R.id.Card4card);
                            	
                            	curr.setText(cardList.get(0).getString("cardContent"));
                            }
                        } else {
                            Log.d("CardText", "Error: " + e.getMessage());
                        }
                    }
                });
                
                ParseQuery<ParseObject> cardQuery5 = ParseQuery.getQuery("WhiteCards");
                cardQuery5.whereEqualTo("cardId", randArr[4]);
                cardQuery5.findInBackground(new FindCallback<ParseObject>() {
                    public void done(List<ParseObject> cardList, ParseException e) {
                        if (e == null) {
                            if (cardList != null && cardList.size() > 0) {
                            	Log.d("CardText", cardList.get(0).getString("cardContent"));

                            	TextView curr = (TextView) findViewById(R.id.Card5card);
                            	
                            	curr.setText(cardList.get(0).getString("cardContent"));
                            }
                        } else {
                            Log.d("CardText", "Error: " + e.getMessage());
                        }
                    }
                });
                
                ParseQuery<ParseObject> cardQuery6 = ParseQuery.getQuery("WhiteCards");
                cardQuery6.whereEqualTo("cardId", randArr[5]);
                cardQuery6.findInBackground(new FindCallback<ParseObject>() {
                    public void done(List<ParseObject> cardList, ParseException e) {
                        if (e == null) {
                            if (cardList != null && cardList.size() > 0) {
                            	Log.d("CardText", cardList.get(0).getString("cardContent"));

                            	TextView curr = (TextView) findViewById(R.id.Card6card);
                            	
                            	curr.setText(cardList.get(0).getString("cardContent"));
                            }
                        } else {
                            Log.d("CardText", "Error: " + e.getMessage());
                        }
                    }
                });
                
                ParseQuery<ParseObject> cardQuery7 = ParseQuery.getQuery("WhiteCards");
                cardQuery7.whereEqualTo("cardId", randArr[6]);
                cardQuery7.findInBackground(new FindCallback<ParseObject>() {
                    public void done(List<ParseObject> cardList, ParseException e) {
                        if (e == null) {
                            if (cardList != null && cardList.size() > 0) {
                            	Log.d("CardText", cardList.get(0).getString("cardContent"));

                            	TextView curr = (TextView) findViewById(R.id.Card7card);
                            	
                            	curr.setText(cardList.get(0).getString("cardContent"));
                            }
                        } else {
                            Log.d("CardText", "Error: " + e.getMessage());
                        }
                    }
                });
                
                
            } else {
            	Log.d("Error", e.getMessage());
            }
          }
        });
        
        
        
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.pick_white, menu);
		return true;
	}

}
