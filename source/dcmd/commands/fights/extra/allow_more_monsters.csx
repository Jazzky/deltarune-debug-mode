{

if (chapter > 1)
{

importGroup.QueueFindReplace("gml_Object_obj_battlecontroller_Create_0",
@"for (i = 0; i < 3; i += 1)
{
    scr_monster_statreset(i);
}
for (i = 0; i < 3; i += 1)
{
    if (global.monstertype[i] > 0)
    {
        scr_monster_makeinstance(i);
    }
}
",
@"var _nb_monsters = max(array_length(global.monstertype), 3);
for (i = 0; i < _nb_monsters; i++)
{
	scr_debug_print(""caca"" + string(i));
    scr_monster_statreset(i);
	if (global.monstertype[i] == 0)
		continue;

	scr_monster_makeinstance(i);
	_dmode_add_enemies_fixes(i);
}
");

importGroup.QueueFindReplace("gml_GlobalScript_scr_battle",
"for (__ien = 0; __ien < 3; __ien++)",
"for (__ien = 0; __ien < array_length(global.monstertype); __ien++)");

}

}
