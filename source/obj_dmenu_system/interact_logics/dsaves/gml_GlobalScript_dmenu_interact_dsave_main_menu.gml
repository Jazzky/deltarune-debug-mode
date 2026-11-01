function dmenu_interact_dsave_main_menu()
{
	if (dvertical_index == 0)
	{
		keyboard_string = "";
		dkeyboard_input = "";
		dmenu_state = "new_debug_save";
		break;
	}
	
	if (dvertical_index == 1)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		global.dreading_custom_flag = 1;
		keyboard_string = "";
		dkeyboard_input = "";
		dmenu_state_update();
		break;
	}
	
	if (dmenu_interact_submenus(selected_name))
		break;
	
	var real_index = dbutton_indices[dvertical_index];
	
	if (real_index >= 0)
	{
		global.debug_selected_save_section = debug_save_sections[real_index];
		global.debug_selected_save_name = debug_save_names[real_index];
		dmenu_state = "debug_save_options";
		dmenu_state_update();
	}
}
