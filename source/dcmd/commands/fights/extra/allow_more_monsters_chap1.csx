{
importGroup.QueueFindReplace("gml_Object_obj_battlecontroller_Create_0",
@"for (i = 0; i < 3; i += 1)
{
    global.monster[i] = 0;
    global.monsterx[i] = 0;
    global.monstery[i] = 0;
    global.monstername[i] = "" "";
    global.monsterat[i] = 0;
    global.monsterdf[i] = 0;
    global.monsterhp[i] = 0;
    global.monstermaxhp[i] = 0;
    global.monsterinstance[i] = 12913921839;
    global.monstergold[i] = 0;
    global.monsterexp[i] = 0;
    global.sparepoint[i] = 0;
    global.hittarget[i] = 0;
    global.mercymod[i] = 0;
    global.mercymax[i] = 0;
    global.monstercomment[i] = "" "";
    global.monsterstatus[i] = 0;
    for (j = 0; j < 6; j += 1)
    {
        global.act[i][j] = 0;
        global.canact[i][j] = 0;
        global.actname[i][j] = "" "";
        global.acttype[i][j] = 0;
        global.actspell[i][j] = 0;
        global.actactor[i][j] = 1;
        global.actdesc[i][j] = "" "";
        global.actcost[i][j] = 0;
    }
}
global.monstergold[3] = 0;
global.monsterexp[3] = 0;
for (i = 0; i < 3; i += 1)
{
    if (global.monstertype[i] > 0)
    {
        global.monster[i] = 1;
        global.monsterinstance[i] = instance_create(global.monstermakex[i], global.monstermakey[i], global.monsterinstancetype[i]);
        global.monsterinstance[i].myself = i;
        with (global.monsterinstance[i])
        {
            event_user(12);
        }
    }
}
",
@"var _nb_monsters = max(array_length(global.monstertype), 3);
for (i = 0; i < _nb_monsters; i += 1)
{
    global.monster[i] = 0;
    global.monsterx[i] = 0;
    global.monstery[i] = 0;
    global.monstername[i] = "" "";
    global.monsterat[i] = 0;
    global.monsterdf[i] = 0;
    global.monsterhp[i] = 0;
    global.monstermaxhp[i] = 0;
    global.monsterinstance[i] = 12913921839;
    global.monstergold[i] = 0;
    global.monsterexp[i] = 0;
    global.sparepoint[i] = 0;
    global.hittarget[i] = 0;
    global.mercymod[i] = 0;
    global.mercymax[i] = 0;
    global.monstercomment[i] = "" "";
    global.monsterstatus[i] = 0;
    for (j = 0; j < 6; j += 1)
    {
        global.act[i][j] = 0;
        global.canact[i][j] = 0;
        global.actname[i][j] = "" "";
        global.acttype[i][j] = 0;
        global.actspell[i][j] = 0;
        global.actactor[i][j] = 1;
        global.actdesc[i][j] = "" "";
        global.actcost[i][j] = 0;
    }
}
global.monstergold[_nb_monsters] = 0;
global.monsterexp[_nb_monsters] = 0;
for (i = 0; i < _nb_monsters; i += 1)
{
    if (global.monstertype[i] == 0)
		continue;

	global.monster[i] = 1;
	global.monsterinstance[i] = instance_create(global.monstermakex[i], global.monstermakey[i], global.monsterinstancetype[i]);
	global.monsterinstance[i].myself = i;
	with (global.monsterinstance[i])
	{
		event_user(12);
    }
	_dmode_add_enemies_fixes(i);
}
");
}
