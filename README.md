# Call of Duty 4 2D Head Up Displays(HUD) Maker

This tool is for Call of Duty 4 Server Admins which makes it easier to create simple 2D HUDs. By this you can create simple 2D HUDs **In-Game** which makes it easier and time saving for you.

## Features 

* Allows you to create and edit HUDs by using in-game custom commands.
* HUDs can easily Move, Resize, Sort and Recolor etc.
* Allows you to save the C script for the HUD after you create and edit HUDs. 

## Requirements

* Latest CoD4X Server version. Website:  [cod4x.me](https://cod4x.me)

## Installation

* Copy the main_shared folder to your `cod4directory/` folder. Use [this](https://cod4x.me/index.php?/forums/topic/8-how-to-install-server-side-scripts/) thread for more info.
* Copy 'server.cfg' in main folder to your `cod4directory/main/` folder.
* Edit the 'server.cfg' file. *Instructions are in that file*.
* Start the server with `+exec server.cfg` parameter.

## Available Commands

* *All arguments in Italics are OPTIONAL.*

* **$addhud [hud_name STRING] *[x INT]* *[y INT]***
  > This command will add a new HUD. You can define custom X and Y postion while creating a hud. Default will be 0 for both X axis and Y axis.

* **$selecthud [hud_name STRING]**
	>This command can select HUDs which you have already created. If you need to edit one of HUDs you have created, first you need to use this command to select that HUD. 

* **$deletehud [hud_name STRING]**
	>By this command, you can delete HUDs which you have created using $addhud command.

* **$currentHuds**
	>This command allows you to see the HUD names which you have created using $addhud command.
	
* **$selectedhud**
	>This command allows you to see the name of the HUD which you are currently editing.

* **$setshader [shader_name STRING] *[width INT]* *[height INT]***
	>This command allows you to set Shader to the HUD which you have selected. Width and Height are optional. Default Width and Height are both 100.

* **$setText [text STRING]**
	>This command can add Text to the HUD which you have selected.
	
* **$movehud**
	>This command allows you to move a HUD easily.
* **$resizehud**
	>This command allows you to resize both text and shader HUDs easily.

* **$sort [sort_value INT]**
	>This command will sort the HUD which you have selected. The HUD which have the hightest sort value, It will be on the front of other HUDs. The HUD which have the lowest sort value, it will be on the back of other HUDs. *sort value can be minus too*. 
	
* **$setcolor [red INT]** **[green INT]** **[blue INT]**
	>This command allows you to change the color of a HUD. *Ex: $setcolor 255 0 150* This example code will color the HUD as Pink. Just pick a RGB color code from an app such as Adobe photoshop, Ms paint etc.

* **$opacity [opacity_value FLOAT]**
	>This command allows you to set the opactiy of a HUD. The opacity can be any float value between 0 to 1.
	
* **$horzalign [alignment STRING]**
	>This command allows you to adjust the Horizontal Alignment (hud.AlignX) of a HUD. *The options avaiable for this command are **Left, Center and Right.***
	
* **$vertalign [alignment STRING]**
	>This command allows you to adjust the Vertical Alignment (hud.AlignY) of a HUD. *The options avaiable for this command are **Top, Middle and Bottom.***
	
* **$savehud [hud_name STRING] *[level? BOOLEAN]***
	>This command will save the C script for the defined HUD in a .txt file. It will be saved in `cod4directory/main/saves` folder. Set level as 1 if you need to set HUD as a Global HUD (Level). Default, it will be saved as Player HUD (self).
	
* **$saveall *[level? BOOLEAN]***
	>This command will save every HUD you have created in a .txt file. It will be saved in `cod4directory/main/saves` folder. Set level as 1 if you need to set all HUDs as a Global HUDs (Level). Default, they will be saved as Player HUDs (self).
	
## Guide

* If you have successfully created the server, first you need to connect to that server as a normal player and join to a team. Now you can do all the HUD editing stuff. 

* After the first step you need to use $addhud < hud_name > command to add a HUD. You can use any name without spaces for the HUD. *If you created a HUD using $addhud command, that HUD will be selected as the currently editing HUD.*

* When you create a HUD, there will be small red DOT at the middle of the screen. That is the HUD origin indicator and it will point the HUD which you are currently working on.

* If you have 2 or more HUDs and you need to edit some other HUD you have created; For that you must select the HUD which you need to edit. To select you have to use $selecthud < hud_name > command. 
