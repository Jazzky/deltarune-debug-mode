function dmenu_xmove_fight_menu()
{
	var to_add = (left_held) ? -1 : 1;
	dfight_menu.selected_enemy += to_add;
}
