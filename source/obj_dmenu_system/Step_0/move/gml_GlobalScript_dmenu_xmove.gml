function dmenu_get_xmove_callfunc(arg0=dmenu_state)
{
	var state = arg0;

	switch (state)
	{
		case "flag_misc":
			return (dmenu_xmove_flag_misc);

		case "warp_options":
			return (dmenu_xmove_warp_options);

		case "recruits":
			return (dmenu_xmove_recruits);

		case "debug_save_options":
			return (dmenu_xmove_dsave_options);
	}
	return (undefined);
}

function dmenu_xmove()
{
	if (!left_held && !right_held)
		exit;

	var invalid_movement = dmenu_xmove_common_logic();
	if (invalid_movement) // 0 = no error
	{
		if (invalid_movement == 1) // 1 = play sound
			snd_play(snd_error);
		exit;
	}

	var callfunc = dmenu_get_xmove_callfunc();
	if (callfunc == undefined)
		exit;

	callfunc();
}
