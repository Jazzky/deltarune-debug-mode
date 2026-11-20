function dcmd_fight(argc, argv, flags)
{
	if (argc == 1)
		return (0);

	for (var i = 0; i < array_length(global.monstertype); i++) {
		global.monster[i] = 0;
		global.monstertype[i] = 0;
		global.monsterinstancetype[i] = 0;
	}

	var enemy_lst = _dcmd_fight_fetch_enemies(argc, argv);	
	if (enemy_lst == undefined)
		return (1);

	var nb_enemies = array_length(enemy_lst);

	var _camx = __view_get(e__VW.XView, 0);
	var _camy = __view_get(e__VW.YView, 0);

	var _lower_y_bound = _camy + 40;
	var _upper_y_bound = _camy + 260;
	var _even_x_pos = _camx + 510;
	var _odd_x_pos = _camx + 460;

	var _enemy_y = _lower_y_bound;
	var _enemy_y_step = ((_upper_y_bound - _lower_y_bound) / nb_enemies);
	if (nb_enemies == 1)
		_enemy_y += _enemy_y_step / 2;

	_dcmd_start_battle_back();
	for (myself = 0; myself < nb_enemies; myself++) {
		var _cur_enemy = enemy_lst[myself];
		var _enemy_id = _cur_enemy.enemy_id;
		var _enemy_obj = _cur_enemy.object_id;

		global.monstertype[myself] = _enemy_id;
		global.monsterinstance[myself] = _enemy_obj;
		global.monsterinstancetype[myself] = _enemy_obj;

		var _new_x = _odd_x_pos;
		if (myself % 2)
			_new_x = _even_x_pos;

		var _new_y = _enemy_y;
		_enemy_y += _enemy_y_step;

		_new_y -= sprite_get_height(object_get_sprite(_enemy_obj)) / 2;

		global.monstermakex[myself] = _new_x;
		global.monstermakey[myself] = _new_y;
	}
	global.interact = 1;
	return (0);
}

function _dcmd_fight_fetch_enemy(arg0)
{
	var enemy_name = string_lower(arg0);
	var enemy_id = 0;

	var enemy_map = global.enemies_id_map;
	var looking_id = false;

	if (dutils_isuint(enemy_name)) {
		enemy_id = real(enemy_name);
		looking_id = true;
	}

	var size = ds_map_size(enemy_map);
	var _temp_key = ds_map_find_first(enemy_map);
	for (var i = 0; i < size; i++)
	{
		var _try_enemy = ds_map_find_value(enemy_map, _temp_key)

		if (looking_id && _try_enemy.enemy_id == enemy_id)
			return (_try_enemy);

		if (!looking_id && string_lower(_try_enemy.enemy_name) == enemy_name)
			return (_try_enemy);

		_temp_key = ds_map_find_next(enemy_map, _temp_key);
	} 

	if (looking_id)
		scr_derror_print("Error, no enemy found with ID " + string(enemy_id));
	else
		scr_derror_print("Error, no enemy found with name " + string(enemy_name));
	return (undefined);
}

function _dcmd_fight_fetch_enemies(argc, argv)
{
	var res_lst = [];
	for (var i = 1; i < argc; i++) {
		var _new_enemy = _dcmd_fight_fetch_enemy(argv[i]);

		if (_new_enemy == undefined)
			return (undefined);

		array_push(res_lst, _new_enemy);
	}
	return (res_lst);
}

function _dcmd_start_battle_back()
{
	if (global.chapter > 1)
	{
		scr_battle(0, 0, 0, 0, 0);
	}
	else
	{
		global.batmusic[0] = snd_init("joker.ogg");
		instance_create(0, 0, obj_encounterbasic);
		for (var i = 0; i < 3; i++) {
			global.monstertype[i] = 0;
		}
	}
}

enum e__VW
{
    XView,
    YView
}
