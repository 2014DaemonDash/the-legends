package com.example.cardsagainsttheenvironment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.parse.FindCallback;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseException;
import com.parse.ParseUser;

public class RoomsActivity extends Activity {
	RoomsActivity ra = this;
	LinearLayout ll;
	List<ParseObject> globalRoomList;
	Map<LinearLayout, Integer> linearLayouts = new HashMap<LinearLayout,Integer>();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_rooms);
		
		ll = (LinearLayout)findViewById(R.id.LinearLayoutRooms);
		
		ParseQuery<ParseObject> query = ParseQuery.getQuery("Room");
		query.findInBackground(new FindCallback<ParseObject>() {
		    @Override
			public void done(List<ParseObject> roomList, ParseException e) {
		        if (e == null) {
		        	if(roomList != null && roomList.size() > 0) {
						Log.d("Rooms", roomList.toString());
						globalRoomList = roomList;
						
						for(int i = 0, size = roomList.size(); i < size; i++) {
							
							//create room entries
							LinearLayout newRoom = new LinearLayout(ra);
							newRoom.setOrientation(LinearLayout.VERTICAL);
							
							LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(300, 100);
							params.setMargins(0, 0, 0, 30);
							newRoom.setLayoutParams(params);
							newRoom.setGravity(Gravity.CENTER);
							newRoom.setBackgroundColor(Color.LTGRAY);
							
							TextView titleView = new TextView(ra);
					        titleView.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
					        titleView.setClickable(true);
					        titleView.setText(globalRoomList.get(i).getString("name"));
					        
					        linearLayouts.put(newRoom, i);
					        
					        newRoom.setOnClickListener(new OnClickListener() {
		                        @Override
		                        public void onClick(View arg0) {
		                        	Log.d("Clicked", arg0.toString());
		                        	LinearLayout l = (LinearLayout)arg0;
		                        	
		                        	Intent i = new Intent(ra, RoomViewActivity.class);
		                        	Log.d("linearLayout", linearLayouts.get(l) + "");
		                        	
		                        	ParseUser currentUser = ParseUser.getCurrentUser();
		                        	if (currentUser != null) {
		                        		String currJudge = globalRoomList.get(linearLayouts.get(l)).getString("currentJudge");
			                        	Log.d("currJudge in room", currJudge);
			                        	
			                        	boolean isJudge = currJudge.equals(currentUser.getUsername());
			                        	Log.d("isJudge", isJudge + "");
			                        	
			                        	i.putExtra("isJudge", isJudge);
			                        	
			                        	Log.d("id?", globalRoomList.get(linearLayouts.get(l)).getObjectId());
			                        	i.putExtra("roomId", globalRoomList.get(linearLayouts.get(l)).getObjectId());

			                            startActivity(i);
		                        	} else {
		                        		Log.d("Error", "");
		                        	}
		                        	
		                        }
					        });
					        
					        newRoom.addView(titleView);
					        ll.addView(newRoom);
						}
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
		getMenuInflater().inflate(R.menu.rooms, menu);
		return true;
	}
	
	public void addRoom(View v) {
		Intent i = new Intent(RoomsActivity.this, AddRoomActivity.class);
		startActivity(i);
	}

}
