package com.example.cardsagainsttheenvironment;

import java.util.List;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class RoomsActivity extends Activity {
	RoomsActivity ra = this;
	LinearLayout ll;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_rooms);
		
		ll = (LinearLayout)findViewById(R.id.LinearLayoutRooms);
		
		ParseQuery<ParseObject> query = ParseQuery.getQuery("Room");
		query.findInBackground(new FindCallback<ParseObject>() {
		    public void done(List<ParseObject> roomList, ParseException e) {
		        if (e == null) {
		        	if(roomList != null && roomList.size() > 0) {
						Log.d("Rooms", roomList.toString());
						
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
					        titleView.setText(roomList.get(i).getString("name"));
					        titleView.setOnClickListener(new OnClickListener() {
		                        @Override
		                        public void onClick(View arg0) {
		                          /*Intent browserIntent = 
		                            new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.howtosolvenow.com"));
		                            startActivity(browserIntent);*/
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
