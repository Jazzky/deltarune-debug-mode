function dmenu_interact_dsave_main_menu()
{
	if (dvertical_index == 0)
	{
		dmenu_state = "new_debug_save";
		exit;
	}
	
	if (dvertical_index == 1)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		dutils_toggle_kb(true);
		dmenu_state_update();
		exit;
	}
	
	if (dmenu_dsave_interact_submenus(selected_name))
		exit;
	
	var real_index = dbuttons[dvertical_index].data;
	
	if (real_index >= 0)
	{
		global.debug_selected_save_section = debug_save_sections[real_index];
		global.debug_selected_save_name = debug_save_names[real_index];
		dmenu_state = "debug_save_options";
		dmenu_state_update();
	}
}
