function dmenu_state_update_modify_enemy()
{
	var _enemy = dfight_menu.enemies[dfight_menu.selected_enemy];
	var _enemy_name = _enemy.enemy_name;

	dmenu_title = dstr("Modify: " + _enemy_name, "Modifier : " + _enemy_name);
	dbuttons = [
		dmenu_makebt(dstr("Remove enemy", "Retirer ennemi"), "remove_enemy"),
		dmenu_makebt(dstr("Duplicate enemy", "Dupliquer ennemi"), "dup_enemy"),
		dmenu_makebt(dstr("Change enemy", "Changer ennemi"), "change_enemy")
	];
}
