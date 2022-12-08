# Bubbie the VIth
You are a former adventurer who, after cashing in big on a previous adventure, has settled down to live a peaceful life. However, you're starting to feel lonely and unfulfilled as you realize that you haven't spent any time developing social skills and that money can't buy you the excitement of adventure. One day, your cute neighbour, Besty, comes to you looking for help! Her pet duck, Bubbie, has wandered off into the sewers by accident! Motivated by your post-retirement crisis and desire for a connection with Besty, you agree to look for Bubbie, leading you into the sewers which spiral down into the depths of the earth far further than you anticipated. As the dangers grow, the deeper you track Bubbie, the question burns in your mind: "How the hell did that damn duck make it this far?"

## Game Compilation
Execute the command `make` in this directory to compile the game. The game will be generated in bin/ as 'bubbie.prg'  
Note: You will need to change the compiler path in the Makefile to match your setup.  

**Important: Three directories are required to compile the game, this current directory, 'justinLib/', and 'lib/'.** (I'd assume this won't be a problem, as you've pulled the entire repository.)

## Playing the Game
Once the game is compiled, you can run it in your favorite emulator.  

When you start the game, you will be presented with a title screen. Press any key to start the game (Due to how the input loop is designed, to allow us to play music on the title screen, you'll need to hold the key down for ~0.2 second before the game will start).

## Game Objective
The objective is to find and collect 7 duckies, a duck will appear right above the health of the main character.
There are ladders spawn randomly around where you move to them you can go underground and move to the next level.

## Game Controls
* **W** - Move Up
* **A** - Move Left
* **S** - Move Down
* **D** - Move Right

## Game Actions
* **Attack** - To attack the enemey you must face the direction the enemy is in and move towards them.

## Known Bugs
The enemy will damage you before you can attack them as they parallelly move based on your direction.
An enemy spawns sometimes when we move and the main character overlaps them.
Enemy sometimes move into main character location but doesnt attack.
Enemy can phase through the map walls and for a single iteration second the wall block they moved through disappears and returns at the beginning of the next iteration.

## Credits
Not Enough Memory, 2022  
Justin Parker, Emmett Collings, Ricky Bhatti, Abdelhak Khalfallah