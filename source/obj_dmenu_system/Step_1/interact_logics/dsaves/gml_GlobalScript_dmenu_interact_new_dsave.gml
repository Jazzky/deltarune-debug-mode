function dmenu_interact_new_dsave()
{
	if (dvertical_index == 0)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		dutils_toggle_kb(true);
		keyboard_string = "";
		dkeyboard_input = "";
		dmenu_state_update();
		exit;
	}

	var _created = (dvertical_index == 1 && dhorizontal_index == 0);
	if (_created)
	{
		var target_name = dstr("Untitled", "Sans titre");
		if (dkeyboard_input != "")
			target_name = dkeyboard_input;
	
		var cmd = "save_dsave \"" + target_name + "\"";
		dconsole_exec(cmd);
	}

	dkeyboard_input = "";
	dmenu_popup_launch = 0;
	dmenu_state = "debug";
	dbutton_layout = 0;
	dbutton_options = dbutton_options_original;
	dmenu_state_history = [];
	dmenu_vertical_index_history = [];
	dvertical_index = 0;
	dmenu_active = false;
	global.interact = 0;
}
