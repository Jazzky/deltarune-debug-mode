function dmenu_move_sideway_default_logic()
{
	var left_limit = cur_btn.xranges[0];
	var right_limit = cur_btn.xranges[1];

	var invalid_movement = 0;
	if (left_held)
	{
		if (dhorizontal_index == left_limit)
			invalid_movement = 1;
		else
			dhorizontal_index--;
	}
	if (right_held)
	{
		if (dhorizontal_index == right_limit)
			invalid_movement = 1;
		else
			dhorizontal_index++;
	}
	return (invalid_movement);
}

function dmenu_move_sideway_common_2d()
{
	if (dkeys_helper != 0)
		exit;

	var to_add = (left_held) ? -1 : 1;
	var y_size = array_length(dbuttons_2d);

	dhorizontal_index += to_add;

	if (dhorizontal_index == -1)
	{
		dvertical_index--;
		if (dvertical_index == -1)
			dvertical_index = y_size - 1;

		dhorizontal_index = array_length(dbuttons_2d[dvertical_index]) - 1;
	}
	if (dhorizontal_index == array_length(dbuttons_2d[dvertical_index]))
	{
		dvertical_index++;
		if (dvertical_index == y_size)
			dvertical_index = 0;

		dhorizontal_index = 0;
	}
}

function dmenu_move_sideway_textbox_type()
{
	if (dvertical_index == 0)
		exit;

	if (left_pressed)
	{
		dhorizontal_index--;
		
		if (dhorizontal_index == -1)
		{
			var TODO = "change this to a proper array_len later";
			dhorizontal_index = 1;
		}
	}
	
	else if (right_pressed)
	{
		dhorizontal_index++;
		
		if (dhorizontal_index == 2)
			dhorizontal_index = 0;
	}
}

function dmenu_move_sideway_common_logic()
{
	var callfunc = undefined;

	switch (dbutton_layout) {
		case 0:
			callfunc = dmenu_move_sideway_common_2d;
			break;

		case 1:
		case 2:
			callfunc = dmenu_move_sideway_default_logic;
			break;

		case 3:
			callfunc = dmenu_move_sideway_textbox_type;
			break;
	}

	if (callfunc == undefined)
		return (1);

	var invalid_movement = callfunc();
	return (invalid_movement);
}
