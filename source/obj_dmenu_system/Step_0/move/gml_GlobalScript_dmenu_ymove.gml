function dmenu_get_ymove_callfunc(arg0=dmenu_state)
{
	var state = arg0;
	return (undefined);
}

function dmenu_ymove()
{
	if (!up_held && !down_held)
		exit;

	var invalid_movement = dmenu_ymove_common_logic();
	if (invalid_movement) // 0 = no error
	{
		if (invalid_movement == 1) // 1 = play sound
			snd_play(snd_error);
		exit;
	}

	var callfunc = dmenu_get_ymove_callfunc();
	if (callfunc == undefined)
		exit;

	callfunc();
}
