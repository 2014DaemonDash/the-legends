package com.example.cardsagainsttheenvironment;

import java.io.Serializable;
import java.util.HashMap;

import android.util.Log;

import com.parse.ParseObject;
import com.parse.ParseUser;

public class ParseObjectWrapper implements Serializable {
	private static final long serialVersionUID = 1L;
	private HashMap<String, Object> values = new HashMap<String, Object>();
 
	public HashMap<String, Object> getValues() {
		return values;
	}
 
	public void setValues(HashMap<String, Object> values) {
		this.values = values;
	}
	
	public ParseObjectWrapper(ParseObject object) {
		
		// Loop the keys in the ParseObject
		for(String key : object.keySet()) {
			@SuppressWarnings("rawtypes")
			Class classType = object.get(key).getClass();
			/*if(classType == byte[].class || classType == String.class || 
					classType == Integer.class || classType == Boolean.class) {
				values.put(key, object.get(key));
			} else */if(classType == ParseUser.class) {
				ParseObjectWrapper parseUserObject = new ParseObjectWrapper((ParseObject)object.get(key));
				values.put(key, parseUserObject);
			} else {
				Log.d(key, object.get(key).toString());
				values.put(key, object.get(key));
				// You might want to add more conditions here, for embedded ParseObject, ParseFile, etc.
			}
		}
	}
	
	public String getString(String key) {
		if(has(key)) {
			return (String) values.get(key);
		} else {
			return "";
		}
	}
	
	public int getInt(String key) {
		if(has(key)) {
			return (Integer)values.get(key);
		} else {
			return 0;
		}
	}
	
	public Boolean getBoolean(String key) {
		if(has(key)) {
			return (Boolean)values.get(key);
		} else {
			return false;
		}
	}
	
	public byte[] getBytes(String key) {
		if(has(key)) {
			return (byte[])values.get(key);
		} else {
			return new byte[0];
		}
	}	
	
	public ParseObjectWrapper getParseUser(String key) {
		if(has(key)) {
			return (ParseObjectWrapper) values.get(key);
		} else {
			return null;
		}
	}
	
	public Boolean has(String key) {
		return values.containsKey(key);
	}
}
