{

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

}

else if (chapter == 4)
{

importGroup.QueueFindReplace("gml_Object_obj_mizzle_enemy_Create_0",
"global.hittarget[global.chartarget[myself]] += 1;",
"global.hittarget[global.chartarget[myself % 3]] += 1;");
}

}
