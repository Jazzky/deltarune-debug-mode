function dmenu_ymove_default_logic()
{
	var up = (dvertical_index == 0) ? up_pressed : up_held;
	var down = (dvertical_index == (nb_button - 1)) ? down_pressed : down_held;

	if (!up && !down)
		return (2);

	var old_y = dvertical_index;
	var new_y = old_y

	if (up)
		new_y--;

	if (down)
		new_y++;

	if (new_y == -1)
		new_y = nb_button - 1;
	else if (new_y == nb_button)
		new_y = 0;

	if (new_y == old_y)
		return (2);

	dvertical_index = new_y;

	var new_bt = dbuttons[dvertical_index];
	dhorizontal_index = clamp(dhorizontal_index, new_bt.xranges[0], new_bt.xranges[1]);
	return (0);
}

function dmenu_ymove_common_2d()
{
	if (dkeys_helper != 0)
		exit;

	var to_add = (down_held) ? -1 : 1;
	var y_size = array_length(dbuttons_2d);

	dvertical_index += to_add;
	if (dvertical_index == -1)
		dvertical_index = y_size - 1;

	else if (dvertical_index == y_size)
		dvertical_index = 0;

	var new_row_size = array_length(dbuttons_2d[dvertical_index]);
	dhorizontal_index = min(dhorizontal_index, new_row_size - 1);
}

function dmenu_ymove_textbox_type()
{
	if (dvertical_index == 0)
		exit;

	if (up_pressed || down_pressed)
		dvertical_index ^= 1;
}

function dmenu_ymove_common_logic()
{
	var callfunc = undefined;

	switch (dbutton_layout) {
		case 0:
			callfunc = dmenu_ymove_common_2d;
			break;

		case 1:
			callfunc = dmenu_ymove_default_logic;
			break;

		case 2:
			break;

		case 3:
			callfunc = dmenu_ymove_textbox_type;
			break;
	}

	if (callfunc == undefined)
		return (1);

	var invalid_movement = callfunc();
	return (invalid_movement);
}
