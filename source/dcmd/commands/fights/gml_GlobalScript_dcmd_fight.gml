function dcmd_fight(argc, argv, flags)
{
	if (argc == 1 && 0)
		return (0);

	var enemy_lst;

	enemy_lst = [
		{
			enemy_id: 50,
			object_id: obj_spamton_neo_enemy
		},
		{
			enemy_id: 48,
			object_id: obj_queen_enemy
		}
	];

	if (argc != 1) {
		enemy_lst = _dcmd_fight_fetch_enemies(argc, argv);	
		if (enemy_lst == undefined)
			return (1);
	}

	var nb_enemies = array_length(enemy_lst);

	var _camx = __view_get(e__VW.XView, 0);
	var _camy = __view_get(e__VW.YView, 0);

	var _lower_y_bound = _camy + 40;
	var _upper_y_bound = _camy + 260;
	var _even_x_pos = _camx + 470;
	var _odd_x_pos = _camx + 420;

	var _enemy_y = _upper_y_bound;
	var _enemy_y_step = ((_upper_y_bound - _lower_y_bound) / nb_enemies);
	if (nb_enemies == 1)
		_enemy_y = _enemy_y_step / 2;

	scr_battle(0, 0, 0, 0, 0);
	for (i = 0; i < nb_enemies; i++) {
		var _cur_enemy = enemy_lst[i];
		var _enemy_id = _cur_enemy.enemy_id;
		var _enemy_obj = _cur_enemy.object_id;

		myself = i;
		if (i < 3) {
			global.monstertype[myself] = _enemy_id;
			global.monsterinstancetype[myself] = _enemy_obj;
		}

		else {
			scr_monster_add(_enemy_id, _enemy_obj);
		}

		var _new_x = _odd_x_pos;
		if (i % 2)
			_new_x = _even_x_pos;

		var _new_y = _enemy_y;
		_enemy_y -= _enemy_y_step;

		global.monstermakex[myself] = _new_x;
		global.monstermakey[myself] = _new_y;

		if (i < 3)
			continue;

		var _monster_ref = global.monsterinstance[myself];
		_monster_ref.x = camerax() + 800;
		_monster_ref.y = _new_y;
		with (_monster_ref)
		{
			scr_move_to_point_over_time(_new_x, _new_y, 10);
		}
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

enum e__VW
{
    XView,
    YView
}
