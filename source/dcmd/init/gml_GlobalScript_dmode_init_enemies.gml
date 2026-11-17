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

function dmode_init_get_all_enemies()
{
	var enemy_lst = [];

	var _lower_bound = 2;
	var _upper_bound = 200;

	myself = 0;
	for (var _id = _lower_bound; _id < _upper_bound; _id++)
	{
		enemy_lst[_id] = "";
		global.monstertype[myself] = _id;
		global.monstername[myself] = "";
		scr_monstersetup();
		var name = global.monstername[myself];
		if (name == "" || name == "???")
			continue;

		enemy_lst[_id] = name;
	}
	global.monstertype[myself] = 0;

	if (global.chapter == 3) {
		enemy_lst[104] = dstr("Knight", "Chevalier");
	}
	else if (global.chapter == 4) {
		enemy_lst[106] = "Sound of Justice";
	}
	else if (global.chapter == 5) {
		enemy_lst[112] = "Aqua";
	}



	var res_lst = [];

	var _enc_lower_bound = 2;
	var _enc_upper_bound = 300;
	for (var _id = _enc_lower_bound; _id < _enc_upper_bound; _id++)
	{
		scr_encountersetup(_id);
		for (var i = 0; i < 3; i++) {
			var _enemy_id = global.monstertype[i];
			var _object_id = global.monsterinstancetype[i];

			if (_enemy_id <= 1 || _object_id <= 1)
				break;

			var _cur_enemy_name = enemy_lst[_enemy_id];
			if (_cur_enemy_name == "")
				continue;

			array_push(res_lst, {
				enemy_id: _enemy_id,
				object_id: _object_id,
				enemy_name: _cur_enemy_name
			});
			enemy_lst[_enemy_id] = "";
		}
	}

	return (res_lst);
}

function dmode_init_enemies_id_map()
{
	var emap = ds_map_create();
	var all_enemies = dmode_init_get_all_enemies();
	var nb_enemies = array_length(all_enemies);

	for (var i = 0; i < nb_enemies; i++) {
		var _enemy = all_enemies[i];
		var _enemy_name = _enemy.enemey_name;

		ds_map_add(emap, _enemy_name, _enemy);
		ds_map_add(emap, dutils_normalize_id(_enemy_name), _enemy);
	}

	return (emap);
}
