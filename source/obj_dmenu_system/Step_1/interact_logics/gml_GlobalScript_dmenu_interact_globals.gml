function dmenu_interact_globals()
{
	dremove_false_history();
	dmenu_skip_reindexing = true;
	
	var cmd = "setg";
	cmd += " " + dcustom_flag_text[0];

	var reading_double_flag = dvertical_index == 0;
	if (reading_double_flag)
		cmd += " " + dcustom_flag_text[1];

	dconsole_exec(cmd);
	if (dvertical_index == 0)
		dhorizontal_index = 0;
	
	set_keyboard_reader(global.dreading_kb ^ 1);
}
