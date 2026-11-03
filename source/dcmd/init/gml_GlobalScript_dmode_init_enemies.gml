function dmode_init_recruits_id_map()
{
	var rmap = ds_map_create();
	if (global.chapter == 1)
		return (rmap);

	var _lower_bound = 2;
	var _upper_bound = 100;
	for (var i = _lower_bound; i < _upper_bound; i++)
	{
		scr_recruit_info(i);
		if (_chapter == 0)
			continue;

		ds_map_add(rmap, string_lower(_name), i);
	}
	return (rmap);
}

function dmode_init_enemies_id_map()
{
	emap = ds_map_create();

	var _lower_bound = 2;
	var _upper_bound = 200;

	myself = 0;
	for (var i = _lower_bound; i < _upper_bound; i++)
	{
		global.monstertype[myself] = i;
		global.monstername[myself] = "";
		scr_monstersetup();
		var name = global.monstername[myself];
		if (name == "")
			continue;

		ds_map_add(emap, string_lower(name), i);
	}

	if (global.chapter == 4)
		ds_map_add(emap, "sound of justice", 106);

	else if (global.chapter == 5)
		ds_map_add(emap, "aqua", 112);

	global.monstertype[myself] = 0;
	return (emap);
}
