# achievements-static-solver
Simple portable application created in order to easily track achievement for a game. The aim of the app is to have a simple executable and human readable save file.

### Why use Godot
Godot can create easily portable app than can be de-compiled without too much trouble, I also want to learn more about UI logic and the engine.

### How to install
Download the corresponding executable for your operating system from the [release page](https://github.com/Giitto/achievements-static-solver/releases) and place it where you want.
You can use the app as is, but since A.S.S is portable it is better to put the executable in a specific folder and create a shortcut for quick access. I also recommend doing this because the app doesn't create a copy or cache of achievement image for the moment and the save file use complete path to find the image.

### How to use

I don't know a thing on UX et UI design, the app is crude and though with my habit in mind, if you have suggestion you can send them to me.

At the top of the windows there is 3 button, the first create a new achievement bloc, the second is the option menu and loading and the third toggle on and off the edit mode.
##### Add achievement
Straight forward, add an achievement
##### Option
There is two option save and load, both of these option will open a window in order to load or save **.ass** file.
**.ass** is just plain text using JSON logic, here is a example file :

    [
	    {
	    	"description": "Yep, you just created an achievement pressing the button",
	    	"guide_text": "",
	    	"is_achievement_done": true,
	    	"is_folded": false,
	    	"path_to_icon": "**PATH_FORMAT_CORRESPONDING_TO_YOUR_OPERATING_SYSTEM**",
	    	"title": "Create an achievement"
	    },
	    {
	    	"description": "You should not see this, do it.",
	    	"guide_text": "Click the button over the icon to fold the achievement block",
	    	"is_achievement_done": false,
	    	"is_folded": false,
	    	"path_to_icon": "**PATH_FORMAT_CORRESPONDING_TO_YOUR_OPERATING_SYSTEM**",
	    	"title": "Mark as done and fold"
	    },
	    {
	    	"description": "You should not see this",
	    	"guide_text": "This should not be visible because it was loaded as folded",
	    	"is_achievement_done": true,
	    	"is_folded": true,
	    	"path_to_icon": "",
	    	"title": "Load as folded abd done"
	    }
    ]

##### Edit mode
You can toggle on and off the edit mode a with the last button at the right. This mode enable the possibility to edit all text and the icon of the achievement. Clicking the image on edit mode will open a window to select an image to put in achievement icon, the type compatible with Godot are already filtered. You don't need to be in edit mode to mark and Achievement as done.
