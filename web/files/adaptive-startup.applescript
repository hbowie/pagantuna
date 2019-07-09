(*
  Adaptive Startup Applescript
  Cobbled together by Herb Bowie
  Blogging at PaganTuna.com
  
  Updated for Mountain Lion (OS X 10.8) on Aug 2, 2012
  - Changed 'iCal' to 'Calendar'
  
  This script is designed to be saved as an application, and then added to 
  System Preferences / Accounts / Login Items so that it is launched at
  startup. It will then launch your other applications, but with a number
  of conditional tests that make it more useful than launching all of these 
  apps directly from your login items. 
  
  This script combines several useful features:
  
  * Gives the user a chance to bail out if they don't want their normal 
    apps to launch.
  * Continues with normal startup after 30 seconds if left unattended. 
  
  Note that the following subroutine handlers have been defined at
  the bottom of the script.
 
  * launchApp - Launches the specified application and optionally hides it.
  * writeLogLine - Writes a log message to an output log file.
  * deleteOldFilesFromFolder - Delete older files from a designated folder. 
*)

-- Define these variables as globals so that they can be referenced
-- from the subroutine handlers. 
global logFilePath
global logFile
global lf

set lf to (ASCII character 10) as string
set logFilePath to (path to desktop as string) & "Adaptive Startup Log.txt" as string

-- Delete the log file if it already exists
tell application "System Events"
	set logExists to exists file "Adaptive Startup Log.txt" of desktop folder
end tell
if logExists then
	set logFileAlias to logFilePath as alias
	tell application "Finder" to delete logFileAlias
end if

-- Open the log file so that it's ready for use
set logFile to open for access logFilePath with write permission

-- Now bring this startup script back to the front
activate

-- Now give the user a chance to abort the rest of the script. 

-- Start with a verbal announcement
say "Startup sequence about to begin"

-- Now pop up a dialog box, giving the user 30 seconds to respond
set go to true
try
	display dialog "Startup sequence about to begin" buttons {"Cancel", "Choices", "OK"} default button "OK" giving up after 30
	set selectedButton to button returned of the result
	if selectedButton = "OK" or selectedButton = "Choices" or gave up of the result = true then
		set go to true
	else
		set go to false
	end if
on error errStr
	if the errStr contains "User canceled" then
		-- User cancelled
		set go to false
	else
		set go to true
	end if
end try

set choice to "My Usual Apps"
if go then
	if selectedButton = "Choices" then
		choose from list {"My Usual Apps", "My Writing Apps"}
		if result is false then
			set go to false
		else
			set choices to result
			set choice to item 1 of choices
		end if
	end if
end if

if go then
	
	-- Open an output log file so we can tell the user what happened.
	-- Store the log file on the desktop.
	
	set eof of logFile to 0
	writeLogLine("Adaptive Startup launching at " & (current date))
	writeLogLine(" ")
	
	-- Let's clear out some old backups from our backup folders
	
	set the homeFolder to path to home folder as string
	set the backupsFolder to the homeFolder & "Backups:"
	
	set the pruneFolder to the backupsFolder & "Bento Backups:"
	set the pruneAlias to the pruneFolder as alias
	deleteOldFilesFromFolder(pruneAlias, false, 5)
	
	set the pruneFolder to the backupsFolder & "iWisdom Backups:"
	set the pruneAlias to the pruneFolder as alias
	deleteOldFilesFromFolder(pruneAlias, true, 5)
	
	set the pruneFolder to the backupsFolder & "Moneydance Backups:"
	set the pruneAlias to the pruneFolder as alias
	deleteOldFilesFromFolder(pruneAlias, true, 5)
	
	set the pruneFolder to the backupsFolder & "OmniFocus Backups:"
	set the pruneAlias to the pruneFolder as alias
	deleteOldFilesFromFolder(pruneAlias, true, 20)
	
	set the pruneFolder to the backupsFolder & "Two Due Backups:"
	set the pruneAlias to the pruneFolder as alias
	deleteOldFilesFromFolder(pruneAlias, true, 5)
	
	set the pruneFolder to the backupsFolder & "UMSeattle Backups:"
	set the pruneAlias to the pruneFolder as alias
	deleteOldFilesFromFolder(pruneAlias, true, 5)
	
	set the pruneFolder to the backupsFolder & "URL Union Backups:"
	set the pruneAlias to the pruneFolder as alias
	deleteOldFilesFromFolder(pruneAlias, true, 5)
	
	writeLogLine(" ")
	
	-- Clearing out my Downloads folder and then taking out the trash is a good daily housekeeping routine
	set myDownloadFolder to (path to downloads folder)
	tell application "Finder"
		delete items of myDownloadFolder
		empty trash
	end tell
	writeLogLine("Downloads folder thrown in the trash")
	writeLogLine("Trash emptied")
	writeLogLine(" ")
	
	-- Now let's see if we're connected to the Internet
	set internet_status to 1 -- variable that is assigned status of internet connection (1 is on, 0 is off)
	try
		do shell script "curl --connect-timeout 5 http://www.amazon.com"
	on error
		set internet_status to 0 -- on error, the status is set to off (0)
	end try
	
	-- Now report on the Internet status
	if (internet_status = 1) then
		writeLogLine("Internet is available")
	else
		writeLogLine("Internet is not available")
	end if
	
	-- Check for presence of an exteral drive
	-- If found, then assume we're at home with normal setup
	set extdrives to 0
	set file_server_status to 0
	tell application "Finder"
		if "HB HD Spring Clone" exists then
			set extdrives to 1
		end if
	end tell
	
	-- Now launch any apps dependent on external drive(s)
	if (extdrives = 1) then
		writeLogLine("External drives are available")
		tell application "Finder"
			try
				mount volume "afp://10.0.1.1" as user name "Herb Bowie" with password "password"
				set file_server_status to 1
			on error
				set file_server_status to 0
			end try
		end tell
		
		-- If it mounted successfully, then launch iTunes and any related apps
		if (file_server_status = 1) then
			writeLogLine("Mounted Home Media Drive")
			-- launchApp("iTunes", true)
		end if
		-- launchApp("ChronoSync", false)
	else
		writeLogLine("External drives are not available")
	end if
	
	writeLogLine(" ")
	
	writeLogLine("Launching " & choice)
	
	-- Let's start with applications we always want to launch
	-- In my case, that would be "LaunchBar"
	launchApp("LaunchBar", false)
	
	if choice = "My Usual Apps" then
		if (extdrives = 1) then
			launchApp("ChronoSync", true)
		end if
		
		-- Now let's launch all the usual daily workhorses
		launchApp("PowerTunes", true)
		tell application "PowerTunes"
			open library "iTunes"
		end tell
		launchApp("Calendar", true)
		launchApp("OmniFocus", true)
		launchApp("BBEdit", true)
		launchApp("TextMate", true)
		launchApp("Two Due", false)
		
		-- Now launch apps dependent on the Internet
		if (internet_status = 1) then
			launchApp("Mail", true)
			-- launchApp("Safari", false)
			launchApp("App Store", true)
			launchApp("MacUpdate Desktop", true)
			-- launchApp("Reeder", true)
			-- launchApp("Messages", true)
			launchApp("URL Union", true)
			
			-- Now let's open our favorite Web pages
			-- open location "http://my.yahoo.com"
			-- open location "http://facebook.com"
			-- open location "http://www.swackett.com/app/"
		end if
		
		-- NetBeans is a hefty Java app, and the activate will time out,
		-- so let's wrap it in a try block and ignore any purported error
		try
			tell application "NetBeans 7.1.2"
				activate
			end tell
		end try
		
		delay 10
		
		-- And then hide it as well
		tell application "Finder"
			set visible of process "NetBeans" to false
		end tell
		writeLogLine("Application " & "NetBeans" & " launched and hidden")
		
		-- Now open Active Projects files
		set the projects_folder to path to home folder as string
		set the projects_folder to the projects_folder & "Active Projects:"
		set the projects_folder to the projects_folder as alias
		
		set the apps_folder to path to applications folder as string
		set omni_outliner to the apps_folder & "OmniOutliner Professional.app"
		set omni_outliner to the omni_outliner as alias
		
		tell application "System Events" to get every disk item of the projects_folder whose visible is true
		set projects_files to result
		repeat with projects_file in projects_files
			tell application "System Events" to get name extension of projects_file
			if result is "oo3" then
				tell application "Finder"
					open projects_file using omni_outliner
				end tell
			else
				tell application "Finder"
					open projects_file
				end tell
			end if
			tell application "System Events" to get displayed name of projects_file
			writeLogLine("Opened file " & result)
		end repeat
	end if
	
	if choice = "My Writing Apps" then
		launchApp("TextMate", false)
		launchApp("Dictionary", false)
		launchApp("Two Due", false)
	end if
	
	writeLogLine(" ")
	writeLogLine("Adaptive Startup finishing at " & (current date))
	
	close access logFile
	tell application "Finder"
		open logFilePath
	end tell
else
	close access logFile
end if

-- Subroutines
on launchApp(appName, hide)
	try
		activate application ((path to applications folder as text) & appName & ".app")
		-- Let's pause for a few seconds, to give our app a chance to launch before we try to hide it
		delay 5
		
		if hide then
			tell application "Finder"
				set visible of process appName to false
			end tell
			writeLogLine("Application " & appName & " launched and hidden")
		else
			writeLogLine("Application " & appName & " launched")
		end if
	on error
		writeLogLine("Application " & appName & " could not be launched")
	end try
end launchApp

on deleteOldFilesFromFolder(pth, sortByDate, filesToKeep)
	writeLogLine("Reviewing files in " & (pth))
	tell application "Finder"
		activate
		set filelist to files in pth
		if sortByDate then
			set filelist1 to (sort filelist by modification date)
		else
			set filelist1 to the reverse of (sort filelist by name)
		end if
	end tell
	set fileCount to 0
	repeat with oneFile in filelist1
		tell application "System Events" to get displayed name of oneFile
		set oneFileName to result
		tell application "System Events" to get modification date of oneFile
		set modDate to result
		set fileCount to fileCount + 1
		if fileCount ² filesToKeep then
			-- writeLogLine("Keeping " & modDate & " " & oneFileName)
		else
			writeLogLine("Deleting " & modDate & " " & oneFileName)
			tell application "Finder" to delete oneFile
		end if
	end repeat
end deleteOldFilesFromFolder

on writeLogLine(logLine)
	write logLine & lf to logFile
end writeLogLine