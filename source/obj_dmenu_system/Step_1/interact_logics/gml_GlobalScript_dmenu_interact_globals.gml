function dmenu_interact_globals()
{
	var cmd = "setg";
	cmd += " " + dkeyboard_texts[0];

	var reading_double_flag = (dvertical_index == 0);
	if (reading_double_flag)
		cmd += " " + dkeyboard_texts[1];

	dconsole_exec(cmd);
	if (dvertical_index == 0)
		dhorizontal_index = 0;
}
