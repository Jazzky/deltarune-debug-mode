function dmenuback_update_keyboard()
{
	dutils_read_kb();
	if (dutils_cur_kb_key() == undefined)
		exit;

	dmenuback_handle_kb();

	var keyboard_func = dmenuback_get_keyboard_func();
	if (keyboard_func == undefined)
		exit;

	var kill_method = keyboard_func();
	if (kill_method == 0 || kill_method == undefined) // keep reading
		exit;

	dutils_clear_key(vk_enter);
	if (kill_method == 1) // keep text variables
	{
		dutils_toggle_kb(false);
		exit;
	}

	else if (kill_method == -1) // true reset
	{
		snd_play(snd_error);
		dmenu_reset_kb();
	}
}

function dmenuback_get_keyboard_func(arg0=dmenu_state)
{
	var state = arg0;

	switch (state)
	{
		case "warp_options":
			return (dmenuback_kb_warp_options);

		case "flag_categories":
			return (dmenuback_kb_flag_categories);

		case "globals_changer":
			return (dmenuback_kb_global_changer);

		default:
			return (dmenuback_default_kb);
	}
	return (undefined);
}

function dmenuback_handle_kb()
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
