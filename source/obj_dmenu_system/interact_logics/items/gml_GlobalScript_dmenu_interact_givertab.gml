function dmenu_interact_givertab()
{
	dremove_false_history();

	var real_index = dbutton_indices[dgiver_button_selected];
	if (dhorizontal_page == 0)
		dmenu_interact_givertab(dgiver_menu_state, real_index, dgiver_amount);
	else
		dmenu_interact_givertab_lw(dgiver_menu_state, real_index, dgiver_amount);
	dpop_history();
	dmenu_active = false;
	global.interact = 0;
}
