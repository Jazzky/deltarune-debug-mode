function dmenu_interact_globals()
{
	var cmd = "setg";
	var reading_double_flag = (dvertical_index == 0);

	var global_name = "";
	var global_value = "";
	
	if (!reading_double_flag) {
		var cur_glob = dglobal_changer_options[dvertical_index];
		global_name = cur_glob[0];
		if (cur_glob[1] != -1)
			global_name += "[" + string(dhorizontal_index) + "]";

		global_value = dkeyboard_texts[0];
	}
	else {
		global_name = dkeyboard_texts[0];
		global_value = dkeyboard_texts[1];
	}

	cmd += " " + global_name + " \"" + global_value + "\"";

	dconsole_exec(cmd);
	if (reading_double_flag)
		dhorizontal_index = 0;
}
