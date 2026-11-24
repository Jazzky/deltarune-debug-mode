function dmenu_state_interact_init_warps()
{
	drooms_options.target_plot = global.plot;
	drooms_options.target_is_darkzone = global.darkzone;
}

function dmenu_state_interact_init_fight_menu()
{
	dfight_menu.enemies = [];
	dfight_menu.nb_enemies = 0;
	dfight_menu.selected_enemy = 0;
	dfight_menu.encounterno = global.encounterno;
}

function dmenu_state_interact_main_menu()
{
	dvertical_index = 0;
	
	dmenu_state = cur_btn.data;

	if (dmenu_state == "warp")
		dmenu_state_interact_init_warps();

	else if (dmenu_state == "recruits")
		dhorizontal_page = 0;

	else if (dmenu_state == "debug_save")
		scr_get_debug_save_list();

	else if (dmenu_state == "fight_menu")
		dmenu_state_interact_init_fight_menu();
}
