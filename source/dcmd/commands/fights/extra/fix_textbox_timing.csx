{

importGroup.QueueFindReplace("gml_GlobalScript_scr_endturn",
"if (global.charaction[i] == 1)",
@"global.monsterdialoguedone[i] = true;
if (global.charaction[i] == 1)"
);

importGroup.QueueFindReplace("gml_GlobalScript_scr_enemyblcon",
"if (arg2 == 0)",
@"global.monsterdialoguedone[myself] = false;
if (arg2 == 0)
");


string target_mnfight = (chapter <= 2) ? "2" : "1.5";

importGroup.QueueFindReplace("gml_GlobalScript_scr_blconskip",
$"global.mnfight = {target_mnfight};",
"scr_end_monsterdial();"
);

string check_dial_func = @"
function scr_everyone_talked()
{
	for (var i = 0; i < 3; i++) {
		if (global.monsterdialoguedone[i] == false)
			return (false);
	}
	return (true);
}

function scr_end_monsterdial()
{
	global.monsterdialoguedone[myself] = true;
	if (!scr_everyone_talked())
		exit;

	global.mnfight = TARGET_MBFIGHT;
}";
check_dial_func = check_dial_func.Replace("TARGET_MBFIGHT", target_mnfight);

importGroup.QueueAppend("gml_GlobalScript_scr_blconskip", check_dial_func);

}
