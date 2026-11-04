function dmenu_get_sideway_callfunc(arg0=dmenu_state)
{
	var state = arg0;

	switch (state)
	{
		case "flag_misc":
			return (dmenu_move_sideway_flag_misc);

		case "warp_options":
			return (dmenu_move_sideway_warp_options);

		case "recruits":
			return (dmenu_move_sideway_recruits);

		case "debug_save_options":
			return (dmenu_move_sideway_dsave_options);
	}
	return (undefined);
}

function dmenu_move_sideway()
{
	if (!left_held && !right_held)
		exit;

	var invalid_movement = dmenu_move_sideway_common_logic();
	if (invalid_movement) {
		snd_play(snd_error);
		exit;
	}

	var callfunc = dmenu_get_sideway_callfunc();
	if (callfunc == undefined)
		exit;

	callfunc();
}
