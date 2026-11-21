function dcmd_fight(argc, argv, flags)
{
	if (argc == 1)
		return (0);

	enemy_lst = _dcmd_fight_fetch_enemies(argc, argv);	
	if (enemy_lst == undefined)
		return (1);

	nb_enemies = array_length(enemy_lst);

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
	_dcmd_parse_flags(flags);
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

function _dcmd_parse_flags(arg0)
{
	var flags = arg0;

	if (dcmd_flag_used(flags, "hit-all"))
		global.dfight_opt_target_all = true;

	if (dcmd_flag_used(flags, "music")) {
		var _try_music = dcmd_get_flag(flags, "music");
		snd_free(global.batmusic[0]);
		global.batmusic[0] = snd_init(_try_music);
	}
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
		instance_create(0, 0, obj_encounterbasic);
		for (var i = 0; i < nb_enemies; i++) {
			global.monstertype[i] = 0;
		}
	}

	for (var i = 0; i < max(nb_enemies, array_length(global.monstertype)); i++) {
		global.monster[i] = 0;
		global.monstertype[i] = 0;
		global.monsterinstancetype[i] = 0;
	}

	global.batmusic[0] = snd_init(_dcmd_fight_set_music());
}

function _dcmd_fight_set_music()
{
	for (var i = 0; i < nb_enemies; i++) {
		var _enn = enemy_lst[i].enemy_id;

		if (global.chapter == 1) {
			if (_enn == 20)
				return ("joker.ogg");
			if (_enn == 25)
				return ("kingboss.ogg");
			if (_enn == 10 || _enn == 21)
				return ("checkers.ogg");
			if (_enn == 2 || _enn == 12 || _enn == 18 || _enn == 19)
				return ("lancerfight.ogg");
		}
		else if (global.chapter == 2) {
			if (_enn == 50)
				return ("spamton_neo_mix_ex_wip.ogg");
			if (_enn == 43 || _enn == 46) {
				if (_enn == 46 && scr_sideb_get_phase() >= 2)
					return ("berdly_battle_heartbeat_true.ogg");
				return ("berdly_chase.ogg");
			}
			if (_enn == 48)
				return ("queen_boss.ogg");
			if (_enn == 49)
				return ("spamton_battle.ogg");
			if (_enn == 45)
				return ("rouxls_battle.ogg");
			if (_enn == 37 || _enn == 38 || _enn == 39)
				return (TODO);
			if (_enn == 51)
				return ("boxing_boss.ogg");
		}
		else if (global.chapter == 3) {
			if (_enn == 104)
				return ("knight.ogg");
			if (_enn == 103)
				return ("tenna_battle.ogg");
			if (_enn == 55 && global.encounterno == 111)
				return ("rudebuster_boss.ogg");
			if (_enn == 58)
				return ("battle_vapor.ogg");
			if (_enn == 60 || _enn == 61 || _enn == 106 || _enn == 107)
				return ("rudebuster_boss.ogg");
			if (_enn == 102)
				return ("rouxls_battle.ogg");
			if (_enn == 105)
				return ("board_4_challenge.ogg");
		}
		else if (global.chapter == 4) {
			if (_enn == 105)
				return ("ch4_extra_boss.ogg");
			if (_enn == 108)
				return ("titan_battle.ogg");
			if (_enn == 107)
				return ("pumpkin_boss.ogg");
			if (_enn == 109)
				return ("titan_spawn.ogg");
			if (_enn == 106)
				return ("statue_level1.ogg");
		}
		else if (global.chapter == 5) {
			if (_enn >= 112 && _enn <= 117)
				return ("miniboss_new_section_idea_wip.ogg");
			if (_enn == 119)
				return ("Flowerman_Arrangement.ogg");
			if (_enn == 118)
				return ("pink.ogg");
			if (_enn == 121)
				return ("inappropriate_recycling.ogg");
		}
	}
	if (global.chapter == 4)
		return ("ch4_battle.ogg");
	if (global.chapter == 5)
		return ("rakuichi_buster_wip.ogg");
	return ("battle.ogg");
}

enum e__VW
{
    XView,
    YView
}
