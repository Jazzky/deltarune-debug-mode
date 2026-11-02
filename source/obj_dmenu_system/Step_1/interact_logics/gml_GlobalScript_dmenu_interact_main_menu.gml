function dmenu_init_warps()
{
	dmenu_state = "warp";
	dhorizontal_index = 0;
	dkeyboard_input = "";
	drooms_options.target_plot = global.plot;
	drooms_options.target_is_darkzone = global.darkzone;
}

function dmenu_interact_main_menu()
{
	dvertical_index = 0;
	
	if (selected_name == dstr("Warps", "Sauts"))
		dmenu_init_warps();

	else if (selected_name == dstr("Items"))
		dmenu_state = "give";

	else if (selected_name == dstr("Recruits", "Recrues"))
	{
		dmenu_state = "recruits";
		dhorizontal_page = 0;
	}

	else if (selected_name == dstr("Flags"))
		dmenu_state = "flag_categories";

	else if (selected_name == "Globals")
		dmenu_state = "globals_changer";

	else if (selected_name == "Debug save")
	{
		scr_get_debug_save_list();
		dmenu_state = "debug_save";
	}
}
