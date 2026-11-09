function dmenu_interact_globals()
{
	var cmd = "setg";
	cmd += " " + cur_btn.data;

	var reading_double_flag = (dvertical_index == 0);
	cmd += " " + dkeyboard_texts[reading_double_flag];

	dconsole_exec(cmd);
	if (reading_double_flag)
		dhorizontal_index = 0;
}
