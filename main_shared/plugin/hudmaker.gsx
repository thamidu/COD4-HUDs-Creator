/* 	
	Call of Duty 4 HUD maker. 
	Created by MALAYA
	GitHub : https://github.com/thamidu/COD4-HUD-Maker
*/

//*****************************
//		   COMMANDS
//*****************************
/*

$addhud <hud_name> <x> <y> 							** X and Y positions are optional. Default X and Y positions are both 0. **
$deletehud <hud_name>								
$selecthHud <hud_name>
$currentHuds
$setshader <shader> <width> <height>  				** Width and Height are optional. Default Width and Height are both 100. **
$setText <text>
$movehud
$resizehud											** This command can be used for either Text HUDs and Shader HUDs. **
$sort <sort number>	
$setColor <color code> |Ex: $setColor 255 0 0| 		** You can choose a color code using MS paint or Adobe Photoshop. **
$opacity <opactiy FLOAT> 
$horzAlign <alignment> 								** The Options are Left, Center or Right. **
$vertalign <alignment>								** The Options are Top, Middle or Bottom. **
$saveHud <hud_name>
$saveAll

*/



init(){
	level thread onPlayerConnect();

	shaders = strTok(getdvar("cfg_shaders_list"), " ");

	for(i=0; i<shaders.size; i++)
		precacheShader(shaders[i]);
}

onPlayerConnect(){
	while(1){
		level waittill("connected", player);

		player.hud = [];
		player.selectedHud = undefined;
		player.currentHuds = "";
		player.selectedHud = "";
		player.first = true;	
	}
}

hudSettings(setting, argument){
	self endon("disconnect");

	if( !isDefined(setting) || setting == "" ){
		self iprintln("^1There is an error in processing command.");
		return;
	}

	if(setting == "addhud"){
		arg = strTok(argument, " ");

		self addHud(arg[0], arg[1], arg[2]);
	}
	else if(setting == "selecthud"){
		if(self CheckIn()){
			self switchHud(argument);
		}
	}
	else if(setting == "deletehud"){
		if(self CheckIn()){
	 		self destroyHud(argument);
	 	}
	}
	else if(setting == "setshader"){

		arg = strTok(argument," ");

		if(self CheckIn()){
	 		self addHudShader(arg[0],arg[1],arg[2]);
	 	}
	}
	else if(setting == "settext"){
		if(self CheckIn()){
	 		self addhudText(argument);
	 	}
	}
	else if(setting == "selectedhud"){
		if(!isDefined(self.selectedHud)){
			self iprintln("^1You haven't created any HUD. Please create a hud using $addhud command.");
			return;		
		}

		self iprintln("Selected HUD is [" +self.selectedHud +"]");
	}
	else if(setting == "currenthuds"){
		if(!isDefined(self.currentHuds) || self.currentHuds == ""){
			self iprintln("^1You haven't created any HUD. Please create a hud using $addhud command.");		
		}
		else{
			self iprintln("^2Current HUDs are: ^3" +self.currentHuds);
		}
	}
	else if(setting == "movehud"){
		if(self CheckIn()){
			self thread EditHudSetup("Move");
			self thread movehud();
			self thread hudCenterIndicator();
			self thread hudSettingsIndicator("move");
		}
	}	
	else if(setting == "resizehud"){
		if(self CheckIn()){
			self resizehud();
		}
	}
	else if(setting == "horzalign"){
		if(self CheckIn())
			self horzAlignHud(argument);
	}
	else if(setting == "vertalign"){
		if(self CheckIn())
			self vertAlignHud(argument);
	}
	else if(setting == "sort"){
		if(self CheckIn())
			self sortHud(argument);
	}
	else if(setting == "opacity"){
		if(self CheckIn())
			self setAlpha(argument);
	}
	else if(setting == "setcolor"){
		arg = strTok(argument," ");

		if(self CheckIn())
			self setColor(arg[0], arg[1], arg[2]);
	}
	else if(setting == "savehud"){
		arg = strTok(argument," ");

		if(self CheckIn()){
			self saveHud(arg[0], arg[1]);
		}
	}
	else if(setting == "saveall"){
		if(self CheckIn()){
			self saveAll(argument);
		}
	}
}

addHud(oname, x, y){
	if(!isDefined(oname) || oname == ""){
		self iprintln("^1A HUD should contain a name.");
		return;
	}

	name = toLower(oname);

	if(isSubstr(name," ")){
		self iprintln("^1HUD Names should not contain spaces.");
		return;
	}

	if(isDefined(self.hud[name])){
		self iprintln("^1You have already created a HUD by this Name");
		return;
	}

	if(isDefined(self.selectedHud) && self.selectedHud != ""){
		if(self.hud[self.selectedHud].isEditing){
			self iprintln("^1The HUD [" +self.selectedHud +"] is currently editing. Please finish that first before procceed.");
			return;
		}
	}

	if(self.first){
		self thread hudOriginPointer();
		self.first = false;
	}

	self.hud[name] = NewClientHudElem(self);
	self.hud[name].x = 0;
	self.hud[name].y = 0;
	self.hud[name].horzAlign = "center";
	self.hud[name].vertAlign = "middle";
	self.hud[name].alignX = "left";
	self.hud[name].alignY = "top";
	self.hud[name].alpha = 1;
	self.hud[name].fontScale = 1.4;
	self.hud[name].hidewheninmenu = true;
	self.hud[name].isEditing = false;
	self.hud[name].shader = "";
	self.hud[name].text = "";

	if(isDefined(x) && x != "")
		self.hud[name].x = int(x);

	if(isDefined(y) && y != "")
		self.hud[name].y = int(y);

	self.currentHuds = self.currentHuds +name +" ";

	self.selectedHud = name;

	self iprintln("^2A HUD has been created as [" +name +"]");
}

switchHud(oname){
	if(!isDefined(oname) || oname == ""){
		self iprintln("^1Please enter a HUD name");
		return;		
	}

	name = toLower(oname);

	if(isDefined(self.hud[name])){
		self.selectedHud = name;
		self iprintln("^2The HUD ^3[" + name +"] ^2selected!");
	}
	else{
		self iprintln("^1Wrong HUD name. Please check again.");
		self iprintln("^3Current Active HUDs are: "+self.currentHuds);
	}
}

addHudShader(shader, width, height){
	if(isDefined(shader) && shader == ""){
		self iprintln("^1You need to define a shader name.");
		self iprintln("^3If you need to delete the shader use ^2$setText^3 command without any text. ");
		return;		
	}

	self.hud[self.selectedHud].height = 100;
	self.hud[self.selectedHud].width = 100;

	if(isDefined(width) && width != ""){
		if(int(width) > 1)
			self.hud[self.selectedHud].width = int(width);
		else
			self iprintln("^3The Width cannot set less than 1. So Width has set to default (100).");
	}

	if(isDefined(height) && height != ""){
		if(int(height) > 1)
			self.hud[self.selectedHud].height = int(height);
		else
			self iprintln("^3The Height cannot set less than 1. So Height has set to default (100).");
	}

	self.hud[self.selectedHud] setShader(shader, self.hud[self.selectedHud].width, self.hud[self.selectedHud].height);
	self.hud[self.selectedHud].shader = shader;
	self.hud[self.selectedHud].text = "";

	self iprintln("^2[" +self.selectedHud +"] Shader has successfully added");

}

addhudText(text){

	self.hud[self.selectedHud] setText(text);
	self.hud[self.selectedHud].shader = "";

	if(!isDefined(text) && text == "")
		self.hud[self.selectedHud].text = "";
	else
		self.hud[self.selectedHud].text = text;

	if(!isDefined(text) && text == "")
		self iprintln("^2[" +self.selectedHud +"] Text has successfully deleted");
	else	
		self iprintln("^2[" +self.selectedHud +"] Text has successfully set as {" +text +"^2}");
}

EditHudSetup(edit){
	self endon("disconnect");

	if(isDefined(edit) && edit != "")
		self iprintln("^2[" +self.selectedHud +"] " +edit +" Started");
	else
		self iprintln("^2[" +self.selectedHud +"] Edit Started");

	self.hud[self.selectedHud].isEditing = true;

	self SetMoveSpeedScale(0);

	while(1){
		if( self meleeButtonPressed() && self useButtonPressed() ){
			self notify("editdone");
			break;
		}

		wait .05;
	}

	self SetMoveSpeedScale(1);

	self thread hideindicators();

	if(isDefined(edit) && edit != "")
		self iprintln("^2[" +self.selectedHud +"] " +edit +" Done");
	else
		self iprintln("^2[" +self.selectedHud +"] Edit Done");

	self.hud[self.selectedHud].isEditing = false;
}

movehud(){
	self endon("disconnect");
	self endon("editdone");

	while(1){ 

		while( (self forwardButtonPressed() && self backButtonPressed()) || (self moveLeftButtonPressed() && self moveRightButtonPressed()))
			wait .05;

		if(self forwardButtonPressed()){
			self.hud[self.selectedHud].y -= 1;
		}
		if(self backButtonPressed()){
			self.hud[self.selectedHud].y += 1;
		}	
		if(self moveLeftButtonPressed()){
			self.hud[self.selectedHud].x -= 1;
		}
		if(self moveRightButtonPressed()){
			self.hud[self.selectedHud].x += 1;
		}

		if(self reloadButtonPressed())
			wait 0.15;
		else
			wait .05;

		while(!self forwardButtonPressed() && !self backButtonPressed() && !self moveLeftButtonPressed() && !self moveRightButtonPressed())
			wait .05;
	}
}
resizehud(){
	if(self hasShader()){
		self thread EditHudSetup("Resize");
		self thread resizeShaderSize();
		self thread hudSettingsIndicator("shader");
	}
	else if(self hasText()){
		self thread EditHudSetup("Font Resize");
		self thread resizeFontScale();
		self thread hudSettingsIndicator("text");
	}
	else{
		self iprintln("^1This HUD doesn't have a Shader or Text. Nothing to resize.");
	}
}

resizeShaderSize(){
	self endon("disconnect");
	self endon("editdone");

	while(1){ 

		while( (self forwardButtonPressed() && self backButtonPressed()) || (self moveLeftButtonPressed() && self moveRightButtonPressed()))
			wait .05;

		if(self forwardButtonPressed()){
			if(self.hud[self.selectedHud].height > 1){
				self.hud[self.selectedHud].height -= 1;
			}
			else{
				self iprintln("^3Shader Height cannot be Less than 1.");

				while(self forwardButtonPressed())
					wait .05;
			}
		}
		if(self backButtonPressed()){
			self.hud[self.selectedHud].height += 1;
		}	
		if(self moveLeftButtonPressed()){
			if(self.hud[self.selectedHud].width > 1){
				self.hud[self.selectedHud].width -= 1;
			}
			else{
				self iprintln("^3Shader Width cannot be Less than 1.");

				while(self moveLeftButtonPressed())
					wait .05;
			}
		}
		if(self moveRightButtonPressed()){
			self.hud[self.selectedHud].width += 1;
		}

		if(self reloadButtonPressed())
			wait 0.15;
		else
			wait .05;

		self.hud[self.selectedHud] setShader(self.hud[self.selectedHud].shader, self.hud[self.selectedHud].width, self.hud[self.selectedHud].height);

		while(!self forwardButtonPressed() && !self backButtonPressed() && !self moveLeftButtonPressed() && !self moveRightButtonPressed())
			wait .05;
	}	
}

resizeFontScale(){
	self endon("disconnect");
	self endon("editdone");

	while(1){

		while( self forwardButtonPressed() && self backButtonPressed() )
			wait .05;

		if(self forwardButtonPressed()){
			if(self.hud[self.selectedHud].fontScale <= 4.4){
				self.hud[self.selectedHud].fontScale += 0.1;
			}
			else{
				self iprintln("^3Font Scale cannot set more than 4.5");
				while(self forwardButtonPressed())
					wait .05;
			}
		}
		if(self backButtonPressed()){
			if(self.hud[self.selectedHud].fontScale > 1.4){
				if(self.hud[self.selectedHud].fontScale == 1.5)
					self.hud[self.selectedHud].fontScale = 1.4;
				else
					self.hud[self.selectedHud].fontScale -= 0.1;
			}
			else{
				self iprintln("^3Font Scale cannot set less than 1.4");
				while(self backButtonPressed())
					wait .05;
			}
		}	

		if(self reloadButtonPressed())
			wait 0.2;
		else
			wait .1;

		while(!self forwardButtonPressed() && !self backButtonPressed() )
			wait .05;
	}	
}

destroyHud(oname){
	if( !isDefined(oname) || oname == "" ){
		self iprintln("^1Please enter a hud name");
		return;		
	}	

	name = toLower(oname);

	if(!self CheckIn(name)){
		return;
	}

	self.hud[name] destroy();
	self.hud[name] = undefined;

	hudList = strTok(self.currentHuds, " ");
	self.currentHuds = "";

	for(i=0; i<hudList.size; i++){
		if(hudList[i] != name)
			self.currentHuds = self.currentHuds + hudList[i] + " ";
	}

	self iprintln("^2The HUD [" +name +"] has successfully deleted.");

	if(name == self.selectedHud){
		hudListUpdated = strTok(self.currentHuds, " ");

		if(hudListUpdated.size > 0){
			self.selectedHud = hudListUpdated[hudListUpdated.size - 1];
			self iprintln("^2The HUD [" +self.selectedHud +"] has Selected.");
		}
		else{
			self.selectedHud = "";
			self iprintln("^2No HUD has selected because the HUD ["+name +"] was the only one avaiable.");
		}
	}
}

sortHud(sort){
	if(!isDefined(sort) || sort == ""){
		self iprintln("^1You need to enter sort number.");
		return;
	}

	self.hud[self.selectedHud].sort = int(sort);

	self iprintln("^2The HUD has successfully sorted to ["+sort+"].");
}

setColor(red , green, blue){
	if(!isDefined(red) || red == ""){
		self iprintln("^1You need to define Color code. Define as 0 if some color code is Zero.");
		return;
	}
	else if(!isDefined(green) || green == ""){
		self iprintln("^1You need to define Green and Blue code. Define as 0 if some color code is Zero.");
		return;
	}
	else if(!isDefined(blue) || blue == ""){
		self iprintln("^1You need to define Blue code. Define as 0 if it is Zero.");
		return;	
	}

	if(int(red) > 255 || int(green) > 255 || int(blue) > 255 || int(red) < 0 || int(green) < 0 || int(blue) < 0){
		self iprintln("^1The color code must be between 0 - 255");
		return;
	}

	red 	= int(red) / 255;
	green 	= int(green) / 255;
	Blue 	= int(blue) / 255;

	self.hud[self.selectedHud].color =	(red, green, blue);
	self iprintln("^2The color has successfully set.");
}

setAlpha(alpha){
	if(!isDefined(alpha) || alpha == ""){
		self iprintln("^1You need to define Opacity. Opacity can be any float number between 0 - 1");
		return;		
	}

	if(float(alpha) > 1 || float(alpha) < 0){
		self iprintln("^1Opacity level cannot be more than 1 or less than 0");
		return;
	}

	self.hud[self.selectedHud].Alpha = float(alpha);

	self iprintln("^2The HUD [" +self.selectedHud +"]'s Opactiy has set as "+alpha);
}

horzAlignHud( x ){
	if( !isDefined(x) || x == "" ){
		self iprintln("^1You should define an alignment.");
		self iprintln("^3Horizontal Alignments are left, center or right.");
		return;
	}

	x = toLower(x);

	if(x != "left" && x != "center" && x != "right"){
		self iprintln("^3Horizontal Align can be left, center or right.");
		return;
	}

	self.hud[self.selectedHud].AlignX = x;
}

vertAlignHud( y ){
	if( !isDefined(y) || y == "" ){
		self iprintln("^1You should define an alignment.");
		self iprintln("^3Vertical Alignments are top, middle or bottom.");
		return;
	}

	y = toLower(y);

	if(y != "top" && y != "middle" && y != "bottom"){
		self iprintln("^3Vertical Align can be top, middle or bottom.");
		return;
	}

	self.hud[self.selectedHud].AlignY = y;
}

saveHud(oname, global){
	if( !isDefined(oname) || oname == "" ){
		self iprintln("^1Please enter a hud name.");
		return;		
	}	

	name = toLower(oname);

	if(!self CheckIn(name)){
		return;
	}

	saveStr = [];

	if(isDefined(global) && global == "1")
		object = "level";
	else
		object = "self";

	if(isDefined(global) && global == "1")
		saveStr[saveStr.size] = object +"." +name +" = NewHudElem();";
	else
		saveStr[saveStr.size] = object +"." +name +" = NewClientHudElem(self);";

	saveStr[saveStr.size] = object +"." +name +".x = " +self.hud[name].x +";";
	saveStr[saveStr.size] = object +"." +name +".y = " +self.hud[name].y +";";
	saveStr[saveStr.size] = object +"." +name +".horzAlign = \"" +self.hud[name].horzAlign +"\";";
	saveStr[saveStr.size] = object +"." +name +".vertAlign = \"" +self.hud[name].vertAlign +"\";";
	saveStr[saveStr.size] = object +"." +name +".alignX = \"" +self.hud[name].alignX +"\";";
	saveStr[saveStr.size] = object +"." +name +".alignY = \"" +self.hud[name].alignY +"\";";
	saveStr[saveStr.size] = object +"." +name +".color = " +self.hud[name].color +";";
	saveStr[saveStr.size] = object +"." +name +".alpha = " +self.hud[name].alpha +";";

	if(self hasShader(name))
		saveStr[saveStr.size] =  object +"." +name +" setShader( \"" +self.hud[name].shader +"\", " +self.hud[name].width +", " +self.hud[name].height +" );";

	if(self hasText(name)){
		saveStr[saveStr.size] =  object +"." +name +" setText( \"" +self.hud[name].text +"\" );";
		saveStr[saveStr.size] =  object +"." +name +".fontScale = " +self.hud[name].fontScale  +";";
	}
	saveStr[saveStr.size] = object +"." +name +".hidewheninmenu = " +self.hud[name].hidewheninmenu +"; //Change this as 0 if you don't want to hide this when a menu is open.";

	timestr = getRealTime();
	fileName = name +"_" +timestr;

	file = FS_FOpen("saves/"+fileName+".txt", "append");

	for(i=0; i<saveStr.size; i++){
		FS_WriteLine(file, saveStr[i]);
	}

	FS_FClose(file);

	self iprintln("^2The script has successfully Saved in saves folder. FileName: " +fileName +".txt");
}

saveAll(global){
	if(!isDefined(self.currenthuds) || self.currenthuds == ""){
		self iprintln("^1You haven't created any hud. Please create a hud using $addhud command.");	
		return;
	}

	saveStr = [];
	huds = strTok(self.currentHuds, " ");

	if(isDefined(global) && global == "1")
		object = "level";
	else
		object = "self";

	for(i=0; i<huds.size; i++){

		if(isDefined(global) && global == "1")
			saveStr[i][saveStr[i].size] = object +"." +huds[i] +" = NewHudElem();";
		else
			saveStr[i][saveStr[i].size] = object +"." +huds[i] +" = NewClientHudElem(self);";

		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".x = " +self.hud[huds[i]].x +";";
		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".y = " +self.hud[huds[i]].y +";";
		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".horzAlign = \"" +self.hud[huds[i]].horzAlign +"\";";
		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".vertAlign = \"" +self.hud[huds[i]].vertAlign +"\";";
		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".alignX = \"" +self.hud[huds[i]].alignX +"\";";
		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".alignY = \"" +self.hud[huds[i]].alignY +"\";";
		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".color = " +self.hud[huds[i]].color +";";
		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".alpha = " +self.hud[huds[i]].alpha +";";

		if(self hasShader(huds[i]))
			saveStr[i][saveStr[i].size] =  object +"." +huds[i] +" setShader( \"" +self.hud[huds[i]].shader +"\", " +self.hud[huds[i]].width +", " +self.hud[huds[i]].height +" );";

		if(self hasText(huds[i])){
			saveStr[i][saveStr[i].size] =  object +"." +huds[i] +" setText( \"" +self.hud[huds[i]].text +"\" );";
			saveStr[i][saveStr[i].size] =  object +"." +huds[i] +".fontScale = " +self.hud[huds[i]].fontScale  +";";
		}

		saveStr[i][saveStr[i].size] = object +"." +huds[i] +".hidewheninmenu = " +self.hud[huds[i]].hidewheninmenu +"; //Change this as 0 if you don't want to hide this when a menu is open.";
	}

	timestr = getRealTime();
	fileName = "All_" +timestr;

	file = FS_FOpen("saves/"+fileName+".txt", "append");

	for(i=0; i<saveStr.size; i++){
		for(f=0; f<saveStr[i].size; f++){
			FS_WriteLine(file, saveStr[i][f]);
		}
		FS_WriteLine(file," ");
	}

	FS_FClose(file);

	self iprintln("^2The script has successfully Saved in saves folder. FileName: " +fileName +".txt");
}

hudSettingsIndicator(setting){
	self endon("disconnect");
	self endon("editdone");

	if(!isDefined(self.tip)){
		self.tip = NewClientHudElem(self);
		self.tip.x = 30;
		self.tip.y = 135;
		self.tip.horzAlign = "center";
		self.tip.vertAlign = "middle";
		self.tip.alignX = "left";
		self.tip.alignY = "top";
		self.tip.hidewheninmenu = 1;
		self.tip.sort = -10;
		self.tip.fontScale = 1.4;
	}
	self.tip.alpha = 0.6;

	while(1){
		if(setting == "move"){
			TipText = "^2Move UP : ^3[[{+forward}]]\n^2Move Down : ^3[[{+back}]]\n^2Move Left : ^3[[{+moveleft}]]\n^2Move Right : ^3[[{+moveright}]]\n^2Save/Cancel: ^3[[{+melee}]] + [[{+activate}]]\n"+"^2X: ^3" +self.hud[self.selectedHud].x +"   ^2Y: ^3" +self.hud[self.selectedHud].y;
		}
		else if(setting == "shader"){
			TipText = "\n^2Change Width : ^3[[{+moveleft}]] ^2/ ^3[[{+moveright}]]\n^2Change Height : ^3[[{+forward}]] ^2/ ^3[[{+back}]]\n^2Save/Cancel: ^3[[{+melee}]] + [[{+activate}]]\n" +"^2Width: ^3" +self.hud[self.selectedHud].width +"   ^2Height: ^3" +self.hud[self.selectedHud].height;
		}
		else if(setting == "text"){
			TipText = "\n\n^2Change Font Size : ^3[[{+forward}]] ^2/ ^3[[{+back}]]\n^2Save/Cancel: ^3[[{+melee}]] + [[{+activate}]]\n" +"^2Font Scale: ^3" +self.hud[self.selectedHud].fontScale;
		}
		else{
			TipText = "";
		}

		self.tip setText( TipText );
		wait .05;
	}
}

hudOriginPointer(){
	self endon("disconnect");

	if(!isDefined(self.hudPointer)){
		self.hudPointer = NewClientHudElem(self);
		self.hudPointer.x = 0;
		self.hudPointer.y = 0;
		self.hudPointer.horzAlign = "center";
		self.hudPointer.vertAlign = "middle";
		self.hudPointer.alignX = "center";
		self.hudPointer.alignY = "middle";
		self.hudPointer setShader("white", 2, 2);
		self.hudPointer.color = (1,0,0);
		self.hudPointer.sort = 1000;
		self.hudPointer.hidewheninmenu = true;
	}

	while(1){
		while(self.selectedHud == "")
			wait .05;

		self.hudPointer.alpha = 1;

		while(self.selectedHud != ""){
			self.hudPointer.x = self.hud[self.selectedHud].x;
			self.hudPointer.y = self.hud[self.selectedHud].y;

			wait .05;		
		}
		self.hudPointer.alpha = 0;
		wait .05;
	}
}

hudCenterIndicator(){
	self endon("disconnect");
	self endon("editdone");

	alwaysShow =  getdvarint("cfg_ctrind_show");

	if(!isDefined(self.horzIndicator) && !isDefined(self.vertIndicator)){
		self.horzIndicator = NewClientHudElem(self);
		self.horzIndicator.x = 0;
		self.horzIndicator.y = 0;
		self.horzIndicator.horzAlign = "center";
		self.horzIndicator.vertAlign = "middle";
		self.horzIndicator.alignX = "center";
		self.horzIndicator.alignY = "middle";
		self.horzIndicator setShader("white", 1000, 1);
		self.horzIndicator.color = (0, 1, 0);
		self.horzIndicator.sort = -1;
		self.horzIndicator.hidewheninmenu = true;

		self.vertIndicator = NewClientHudElem(self);
		self.vertIndicator.x = 0;
		self.vertIndicator.y = 0;
		self.vertIndicator.horzAlign = "center";
		self.vertIndicator.vertAlign = "middle";
		self.vertIndicator.alignX = "center";
		self.vertIndicator.alignY = "middle";
		self.vertIndicator setShader("white", 1, 1000);
		self.vertIndicator.color = (0, 1, 0);
		self.vertIndicator.sort = -1;
		self.vertIndicator.hidewheninmenu = true;
	}

	if(alwaysShow){
		self.horzIndicator.alpha = 0.9;
		self.vertIndicator.alpha = 0.9;			
	}
	else{
		self.horzIndicator.alpha = 0;
		self.vertIndicator.alpha = 0;

		while(1){
			if(self.hud[self.selectedHud].x == 0){
				self.vertIndicator.alpha = 0.9;
			}
			else{
				self.vertIndicator.alpha = 0;
			}

			if(self.hud[self.selectedHud].y == 0){
				self.horzIndicator.alpha = 0.9;
			}
			else{
				self.horzIndicator.alpha = 0;
			}

			wait .05;	
		}		
	}
}

hideindicators(){
	if(isDefined(self.horzIndicator)) 	self.horzIndicator.alpha = 0;
	if(isDefined(self.vertIndicator)) 	self.vertIndicator.alpha = 0;	
	if(isDefined(self.tip)) 			self.tip.alpha = 0;
}


CheckIn(name){

	if(isDefined(name) && name != ""){
		if(!isDefined(self.hud[name])){
			self iprintln("^1Wrong Hud name. Please check again.");
			self iprintln("^3Current Active huds are: "+self.currentHuds);
			return false;	
		}

		if(self.hud[name].isEditing){
			self iprintln("^1The HUD [" +name +"] is currently editing. Please finish that first before procceed.");
			return false;
		}

	}
	else{
		if(!isDefined(self.selectedHud) || self.selectedHud == ""){
			self iprintln("^1You haven't created any hud. Please create a hud using $addhud command.");
			return false;
		}

		if(self.hud[self.selectedHud].isEditing){
			self iprintln("^1The HUD [" +self.selectedHud +"] is currently editing. Please finish that first before procceed.");
			return false;
		}
	}

	return true;
}

hasShader(name){
	if(isDefined(name) && name != ""){
		if(self.hud[name].shader == ""){
			return false;
		}	
	}
	else{
		if(self.hud[self.selectedHud].shader == ""){
			return false;
		}
	}
	return true;
}

hasText(name){
	if(isDefined(name) && name != ""){
		if(self.hud[name].text == ""){
			return false;
		}	
	}
	else{
		if(self.hud[self.selectedHud].text == ""){
			return false;
		}
	}
	return true;
}

float(n){
	setDvar("floatno",n);
	return GetDvarFloat("floatno");
}