{

importGroup.QueueAppend("gml_Object_obj_encounterbasic_Create_0",
"global.dfight_opt_target_all = false");

if (chapter == 1 || chapter == 2 || chapter == 5)
{

importGroup.QueueFindReplace("gml_Object_obj_heroparent_Alarm_1",
"global.monsterhp[global.chartarget[myself]] -= damage;",
@"caster = myself;
dutils_damage_enemy(global.chartarget[myself], damage);
global.hittarget[global.chartarget[myself]] -= 1;
");

}

else if (chapter == 3 || chapter == 4)
{

importGroup.QueueFindReplace("gml_Object_obj_heroparent_Step_0",
"scr_damage_enemy(global.chartarget[myself], damage);",
"dutils_damage_enemy(global.chartarget[myself], damage);"
);

}

importGroup.QueueFindReplace("gml_Object_obj_rudebuster_bolt_Step_0",
"scr_damage_enemy(star, damage);",
"dutils_damage_enemy(star, damage);"
);

importGroup.QueueFindReplace("gml_GlobalScript_scr_spell",
"scr_damage_enemy(star, damage);",
"dutils_damage_enemy(star, damage);"
);


if (chapter > 1)
{

importGroup.QueueFindReplace("gml_Object_obj_icespell_Draw_0",
"scr_damage_enemy(star, damage);",
"dutils_damage_enemy(star, damage);"
);

}


}
