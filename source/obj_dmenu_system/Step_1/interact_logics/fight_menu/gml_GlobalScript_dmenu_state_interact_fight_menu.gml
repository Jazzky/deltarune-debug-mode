function _dmenu_state_inteact_back_add_enemy(arg0, arg1)
{
	var _enemy = arg0;
	var _new_id = arg1;

	if (_new_id == -1) {
		_new_id = dfight_menu.nb_enemies++;
		dfight_menu.selected_enemy = _new_id;
	}

	dfight_menu.enemies[_new_id] = _enemy;
}

function dmenu_state_interact_add_enemy()
{
	var _enemy = cur_btn.data;

	_dmenu_state_inteact_back_add_enemy(_enemy, dfight_menu.selected_enemy);
	dpop_history();
}

function dmenu_state_interact_modify_enemy()
{
	var _id = cur_btn.data;
	var _selected_enemy_x = dfight_menu.selected_enemy;
	var _base_enemy = dfight_menu.enemies[_selected_enemy_x];

	if (_id == "dup_enemy") {
		_dmenu_state_inteact_back_add_enemy(_base_enemy, -1);
	}

	else if (_id == "change_enemy") {
		dmenu_state = "add_enemy";
	}

	else if (_id == "remove_enemy") {
		array_delete(dfight_menu.enemies, _selected_enemy_x, 1);
		if (_selected_enemy_x != 0)
			dfight_menu.selected_enemy--;
		dfight_menu.nb_enemies--;
	}

	dpop_history();
}

function dmenu_state_interact_fight_menu()
{
	var _id = cur_btn.data;

	if (_id == "fight") {
		var cmd = "fight";
		for (var i = 0; i < dfight_menu.nb_enemies; i++)
			cmd += " \"" + string(dfight_menu.enemies[i].enemy_id) + "\"";

		dmenu_reset_menu();
		dconsole_exec(cmd);
		exit;
	}

	if (_id == "enemy_list") {
		if (dfight_menu.nb_enemies == 0) {
			snd_play(snd_error);
			exit;
		}
		dfight_menu.selected_enemy = dhorizontal_index;
		dmenu_state = "modify_enemy";
		exit;
	}

	if (_id == "add_enemy") {
		dfight_menu.selected_enemy = -1;
		dmenu_state = "add_enemy";
		exit;
	}
}
