# blabber
A collaborative undergrad WIP project by two students. 
Combined effort of github.com/noavba and github.com/jrmlegere

## NOTICE 
MAKE SURE TO ACCEPT MICROPHONE PERMISSION OR THE APP WILL NOT WORK AT ALL. IT WILL THROW AN ERROR AND 
YOU WILL HAVE TO RESTART AND ACCEPT IT. 

## How to run blabber

1. Download the Zip File
2. Extract said zip file
3. Open it in an IDE that allows flutter development, android studio/visual studio code, etc.
4. Ensure you have flutter, dart and android SDKs installed.
5. Navigate to Blabber/Lib/main.dart
6. Ensure you have an android emulator device selected to run the app with
7. Click run on the file
8. After some time, the app should open on the android device.
9. Enjoy blabbing!

KNOWN BUGS: 

When listening to audio on the home page, the page flickers, this is due to the UI of waiting for connection between database and phone app, but since
its constant then it will always buffer while doing something actively. (overuse of await async )
But we can't remove that waiting text because then it will look like its frozen and thats not a very good look. so atleast it's doing something
