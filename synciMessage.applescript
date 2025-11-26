tell application "Messages"
	activate
end tell

delay 0.3

tell application "System Events"
	tell process "Messages"
		-- Open Settings... via the menu bar
		try
			click menu item "Settings…" of menu "Messages" of menu bar 1
		on error
			try
				-- For macOS Monterey and earlier
				click menu item "Preferences…" of menu "Messages" of menu bar 1
			on error
				display dialog "Could not open Settings or Preferences from the menu."
				return
			end try
		end try
		
		delay 0.3
		
		tell window 1
			-- Click the iMessage tab
			try
				click button "iMessage" of toolbar 1
			on error
				display dialog "Couldn't find the iMessage toolbar button."
				return
			end try
			
			delay 0.3
			
			-- Get all UI elements
			set allElements to entire contents
			set syncNowClicked to false
			
			repeat with elem in allElements
				try
					if (class of elem is button) and (name of elem is "Sync Now") then
						click elem
						set syncNowClicked to true
						exit repeat
					end if
				end try
			end repeat
			
			if not syncNowClicked then
				display dialog "Couldn't find the Sync Now button."
			end if
			display dialog "Finished Sync."
		end tell
	end tell
end tell
