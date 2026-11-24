function dmenu_state_update_add_enemy()
{
	dmenu_title = dstr("Enemy List", "Liste des ennemis");
	dbuttons = [
		dmenu_makebt(dstr("Search", "Recherche"))
	];
	dmenu_set_bttype(dbuttons[0], "keyboard");

	var enemy_substr = dkeyboard_texts[0];
	if (dutils_reading_kb() || enemy_substr != "") {
		dbuttons[0].text = dstr("Contains: ", "Contient : ");
		dbuttons[0].data = string_length(dbuttons[0].text);
		dbuttons[0].text += enemy_substr;
	}
	enemy_substr = string_lower(enemy_substr);

	var nb_enemies = array_length(dfight_menu.all_enemies);
	for (var i = 0; i < nb_enemies; i++)
	{
		var _enemy = dfight_menu.all_enemies[i];
		var _enemy_name = _enemy.enemy_name;

		if (!string_pos(enemy_substr, string_lower(_enemy_name)))
			continue;

		var _enemy_id = _enemy.enemy_id;
		var combined = _enemy_name + " (ID " + string(_enemy_id) + ")";
		array_push(dbuttons, dmenu_makebt(combined, _enemy));
	}
	
	dbutton_layout = 1;
	dmenu_box = 1;
}
