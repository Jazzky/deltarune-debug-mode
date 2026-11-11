function dmenu_interact_dsave_main_menu()
{
	if (dvertical_index == 0)
	{
		dmenu_state = "new_debug_save";
		exit;
	}
	
	var _save = dbuttons[dvertical_index].data;
	dload_options.target_name = _save.name;
	dload_options.target_path = _save.path;
	dload_options.target_section = _save.cat;

	dmenu_state = "debug_save_options";
}
