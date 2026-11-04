function dmenu_move_sideway_dsave_options()
{
	var new_setting = -1;
	
	if (left_pressed && global.dload_cur_inv != 0)
		new_setting = 0;
	else if (right_pressed && global.dload_cur_inv != 1)
		new_setting = 1;
	
	if (new_setting != -1)
		global.dload_cur_inv = new_setting;
}
