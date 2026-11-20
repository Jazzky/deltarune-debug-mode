function scr_monster_add(arg0, arg1)
{
	var _enemy_id = arg0;
	var _enemy_obj = arg1;

    __returnid = -1;

	var nb_monsters = array_length(global.monstertype);
    for (__mopenslot = 0; __mopenslot < nb_monsters; __mopenslot++)
    {
        if (global.monster[__mopenslot] != 0)
			continue;

		__returnid = __mopenslot;
		break;
    }

    if (__returnid == -1)
	{
        __returnid = nb_monsters;
		_dmode_create_monster(__returnid);
	}

	global.monstertype[__returnid] = _enemy_id;
	global.monsterinstancetype[__returnid] = _enemy_obj;

	_dmode_add_monster_instances_fixes(__returnid);
    return __returnid;
}

function _dmode_add_enemies_fixes(arg0)
{
	var _id = arg0;
	var inst = global.monsterinstance[_id];

	inst.myself = _id;
	inst.rtimer = 0;
	global.monsterdialoguedone[_id] = true;
}

function _dmode_create_monster(arg0)
{
	global.monster[arg0] = 0;
	global.monstertype[arg0] = 0;
	global.monsterinstance[arg0] = 0;
	global.monsterinstancetype[arg0] = 228;

	global.monstermakex[arg0] = 500;
	global.monstermakey[arg0] = 240;

	global.monstername[arg0] = "";
	global.monsterattackname[arg0] = " ";

	global.monstermaxhp[arg0] = 20;
	global.monsterhp[arg0] = 20;

	global.monsterat[arg0] = 3;
	global.monsterdf[arg0] = 2;
	global.sparepoint[arg0] = 0;
	global.monsterstatus[arg0] = 0;
}
