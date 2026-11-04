function dmenu_move_sideway_flag_misc()
{
	cur_options = dother_options[dvertical_index];
	
	global.flag[cur_options[2]] = cur_options[3][dhorizontal_index][1];
	scr_debug_print(
		dstr("Updated ", "Mise à jour de ") +
		"global.flag[" + string(cur_options[2]) + "]" +
		dstr(" to ", " à ") + "|" + 
		string(cur_options[3][dhorizontal_index][1]) + "|"
	);
}
