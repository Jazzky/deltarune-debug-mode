{

importGroup.QueueFindReplace("gml_GlobalScript_scr_monster_actreset",
"global.actnamesus",
@"global.monsterdialoguedone[arg0] = true;
global.actnamesus"
);

importGroup.QueueFindReplace("gml_GlobalScript_scr_endturn",
@"global.monsterattackname[i] = "" "";",
@"global.monsterattackname[i] = "" "";
global.monsterdialoguedone[i] = true;"
);

importGroup.QueueFindReplace("gml_GlobalScript_scr_enemyblcon",
"if (arg2 == 0)",
@"global.monsterdialoguedone[myself] = false;
if (arg2 == 0)
");

importGroup.QueueAppend("gml_GlobalScript_scr_blconskip",
@"function scr_end_monsterdial()
{
	global.monsterdialoguedone[myself] = true;

	for (var i = 0; i < 3; i++) {
		if (global.monsterdialoguedone[i] == false)
			exit;
	}

	global.mnfight = 2;
}
");

importGroup.QueueFindReplace("gml_GlobalScript_scr_blconskip",
"global.mnfight = 2;",
"scr_end_monsterdial();"
);

}
