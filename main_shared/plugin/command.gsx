/* 	
	Call of Duty 4 HUD maker. 
	Created by MALAYA
	GitHub : https://github.com/thamidu/COD4-HUD-Maker
*/

init(){
	addScriptCommand("addhud", 		1);
	addScriptCommand("selecthud", 	1);
	addScriptCommand("deletehud", 	1);
	addScriptCommand("setshader", 	1);
	addScriptCommand("settext", 	1);
	addScriptCommand("currenthuds",	1);
	addScriptCommand("selectedhud",	1);
	addScriptCommand("movehud",		1);
	addScriptCommand("resizehud",	1);
	addScriptCommand("savehud",		1);
	addScriptCommand("saveall",		1);
	addScriptCommand("sort",		1);
	addScriptCommand("opacity",		1);
	addScriptCommand("setcolor",	1);
	addScriptCommand("horzalign",	1);
	addScriptCommand("vertalign",	1);

}

Callback_ScriptCommand(command , arguments){
	waittillframeend;

	cmd = toLower(command);

	if(isDefined(self.name)){
		self thread plugin\hudmaker::hudSettings(cmd, arguments);
	}
}