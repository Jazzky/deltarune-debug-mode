function dmenu_update_keyboard()
{
	dutils_read_kb();
	if (dutils_cur_kb_key() == undefined)
		exit;

	dmenu_set_reindex(true);
	dmenu_handle_kb();

	var keyboard_func = dmenu_get_keyboard_func();
	if (keyboard_func == undefined)
		exit;

	var kill_method = keyboard_func();
	if (kill_method == -1 || kill_method == undefined) // keep reading
		exit;

	snd_play(snd_menumove);
	dutils_clear_key(vk_enter);

	if (kill_method == 0) // success reading, reset variables
	{
		dmenu_reset_kb();
	}

	if (kill_method == 1) // an error occured
	{
		snd_play(snd_error);
		dmenu_reset_kb();
	}

	else if (kill_method == 2) // keep text variables
	{
		dutils_toggle_kb(false);
	}
}

function dmenu_get_keyboard_func(arg0=dmenu_state)
{
	var state = arg0;

	switch (state)
	{
		case "warp_options":
			return (dmenu_kb_warp_options);

		case "flag_categories":
			return (dmenu_kb_flag_categories);

		case "globals_changer":
			return (dmenu_kb_global_changer);

		default:
			return (dmenu_default_kb);
	}
	return (undefined);
}

function dmenu_handle_kb()
{
	var x_limit = 1;
    if (dmenu_state == "flag_categories" || (dmenu_state == "globals_changer" && dvertical_index == 0)) //TODO CHANGE FOR REAL
		x_limit = 2;

	var old_horizontal = dhorizontal_index;
	if (left_held && dhorizontal_index != 0)
		dhorizontal_index--;

	if (right_held && dhorizontal_index < x_limit)
		dhorizontal_index++;

	var kb_text = dkeyboard_texts[dhorizontal_index];
	if (old_horizontal != dhorizontal_index)
		dutils_set_kb_text(kb_text);

	dkeyboard_texts[dhorizontal_index] = dutils_get_kb_text();
}
