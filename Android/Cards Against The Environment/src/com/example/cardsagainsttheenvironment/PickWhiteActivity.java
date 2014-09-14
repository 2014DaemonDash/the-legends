package com.example.cardsagainsttheenvironment;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.widget.Button;

public class PickWhiteActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_pick_white);
		
		Button play = (Button) findViewById(R.id.play_card_button);
		play.setEnabled(false);
		
		//select white cards
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.pick_white, menu);
		return true;
	}

}
