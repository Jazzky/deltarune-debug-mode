{

importGroup.QueueFindReplace("gml_Object_obj_dbulletcontroller_Step_0",
"if (instance_exists(obj_growtangle))",
@"if (!instance_exists(obj_growtangle))
{
	instance_create(__view_get(e__VW.XView, 0) + 320, __view_get(e__VW.YView, 0) + 170, obj_growtangle);
}
if (!instance_exists(obj_moveheart) && !instance_exists(obj_heart))
{
	scr_moveheart();
}
if (instance_exists(obj_growtangle))
");

if (chapter == 1)
{

importGroup.QueueAppend("gml_Object_obj_wavechain_Destroy_0", "snd_stop(wavenoise);");
importGroup.QueueFindReplace("gml_Object_obj_wavechain_Step_0",
@"    with (obj_chainking)
    {
        instance_destroy();
    }
    instance_destroy();
",
@"    with (obj_chainking)
    {
        instance_destroy();
    }
    instance_destroy(obj_wavechain);
");


importGroup.QueueFindReplace("gml_Object_obj_finalchain_Step_0",
@"        global.turntimer = 3;
        instance_destroy();
",
@"        global.turntimer = 3;
        instance_destroy(obj_finalchain);
");

}
else if (chapter == 3)
{

importGroup.QueueAppend("gml_Object_obj_knight_enemy_Create_0", "difficulty = 0;");

importGroup.QueueFindReplace("gml_Object_obj_knight_enemy_Step_0",
"if (createballoon)",
@"if (!createballoon)
{
	createballoon = true;
	msgset(0, "" %%"");
}
if (createballoon)
"
);

importGroup.QueueFindReplace("gml_Object_obj_knight_enemy_Step_0",
"event_user(0);",
@"with (obj_knight_enemy)
{
	event_user(0);
}
");

}

else if (chapter == 4)
{

importGroup.QueueFindReplace("gml_Object_obj_mizzle_enemy_Create_0",
"global.hittarget[global.chartarget[myself]] += 1;",
"global.hittarget[global.chartarget[myself % 3]] += 1;");
}

}
