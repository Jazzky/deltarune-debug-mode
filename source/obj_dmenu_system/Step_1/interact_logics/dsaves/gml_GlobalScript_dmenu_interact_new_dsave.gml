function dmenu_interact_new_dsave()
{
	if (dvertical_index == 0)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		dutils_toggle_kb(true);
		dmenu_state_update();
		exit;
	}

	var _created = (dvertical_index == 1 && dhorizontal_index == 0);
	if (_created)
	{
		var entered_text = dkeyboard_texts[0];
		var target_name = dstr("Untitled", "Sans titre");
		if (entered_text != "")
			target_name = entered_text;
	
		var cmd = "save_dsave \"" + target_name + "\"";
		dconsole_exec(cmd);
	}

	dmenu_reset_menu();
}
