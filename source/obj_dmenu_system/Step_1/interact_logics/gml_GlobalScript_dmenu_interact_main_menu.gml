function dmenu_interact_init_warps()
{
	drooms_options.target_plot = global.plot;
	drooms_options.target_is_darkzone = global.darkzone;
}

function dmenu_interact_main_menu()
{
	dvertical_index = 0;
	
	dmenu_state = cur_btn.data;

	if (dmenu_state == "warp")
		dmenu_interact_init_warps();

	else if (dmenu_state == "recruits")
		dhorizontal_page = 0;

	else if (dmenu_state == "debug_save")
		scr_get_debug_save_list();
}
