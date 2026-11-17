function dcmd_fight(argc, argv, flags)
{
	if (argc == 1 && 0)
		return (0);

	var test = [
		{
			enemy_id: 50,
			object_id: obj_spamton_neo_enemy
		},
		{
			enemy_id: 48,
			object_id: obj_queen_enemy
		}
	];

	var nb_enemies = array_length(test);

	var _camx = __view_get(e__VW.XView, 0);
	var _camy = __view_get(e__VW.YView, 0);

	var _lower_y_bound = _camy + 20;
	var _upper_y_bound = _camy + 220;
	var _even_x_pos = _camx + 470;
	var _odd_x_pos = _camx + 420;

	var _enemy_y = _lower_y_bound;
	var _enemy_y_step = ((_upper_y_bound - _lower_y_bound) / nb_enemies);
	if (nb_enemies == 1)
		_enemy_y = _enemy_y_step / 2;

	scr_battle(0, 0, 0, 0, 0);
	for (myself = 0; myself < nb_enemies; myself++) {
		var _cur_enemy = test[myself];

		scr_monstersetup();

		global.monstertype[myself] = _cur_enemy.enemy_id;
		global.monsterinstancetype[myself] = _cur_enemy.object_id;

		if (myself % 2)
			global.monstermakex[myself] = _even_x_pos;
		else
			global.monstermakex[myself] = _odd_x_pos;

		global.monstermakey[myself] = _enemy_y;
		_enemy_y += _enemy_y_step;
	}
	global.interact = 1;
	return (0);
}

enum e__VW
{
    XView,
    YView
}
