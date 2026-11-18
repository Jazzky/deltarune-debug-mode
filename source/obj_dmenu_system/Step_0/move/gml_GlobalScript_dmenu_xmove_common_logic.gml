function dmenu_xmove_default_logic()
{
	if (cur_btn.category != undefined) {
		var expand = true;
		if (left_pressed)
			expand = false;

		dmenu_toggle_category(dvertical_index, expand);
		dmenu_set_reindex(true);
		return (2);
	}
	var left_limit = cur_btn.xranges[0];
	var right_limit = cur_btn.xranges[1];

	var left_requierement = (dhorizontal_index > left_limit) ? left_held : left_pressed;
	var right_requierement = (dhorizontal_index < right_limit) ? right_held : right_pressed;

	if (!left_requierement && !right_requierement)
		return (2);

	var invalid_movement = 0;
	if (left_requierement)
	{
		if (dhorizontal_index == left_limit)
			invalid_movement = 1;
		else
			dhorizontal_index--;
	}
	if (right_requierement)
	{
		if (dhorizontal_index == right_limit)
			invalid_movement = 1;
		else
			dhorizontal_index++;
	}
	return (invalid_movement);
}

function dmenu_xmove_common_2d()
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

function dmenu_xmove_textbox_type()
{
	if (!left_pressed && !right_pressed)
		exit;

	var row_len = array_length(dbuttons_2d[dvertical_index]);
	var to_add = (left_pressed) ? -1 : 1;

	dhorizontal_index += to_add;

	if (dhorizontal_index == -1)
		dhorizontal_index = row_len - 1;
	else if (dhorizontal_index == row_len)
		dhorizontal_index = 0;
}

function dmenu_xmove_common_logic()
{
	var callfunc = undefined;

	switch (dbutton_layout) {
		case 0:
			callfunc = dmenu_xmove_common_2d;
			break;

		case 1:
		case 2:
			callfunc = dmenu_xmove_default_logic;
			break;

		case 3:
			callfunc = dmenu_xmove_textbox_type;
			break;
	}

	if (callfunc == undefined)
		return (1);

	var invalid_movement = callfunc();
	return (invalid_movement);
}
