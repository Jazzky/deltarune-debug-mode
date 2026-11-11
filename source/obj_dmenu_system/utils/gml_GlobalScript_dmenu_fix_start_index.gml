function dmenu_fix_start_index()
{
	var y_limit = array_length(dbuttons);
	var drawn_elements = min(dbutton_max_visible, y_limit);
	var middle_elements = drawn_elements / 2;
	var ceiled_mid = ceil(middle_elements)

	var new_draw_y = dmenu_start_index;
	if (dvertical_index < ceiled_mid)
		new_draw_y = dvertical_index;

	else if (dvertical_index >= (y_limit - ceiled_mid))
		new_draw_y = drawn_elements - (y_limit - dvertical_index);

	dmenu_start_index = new_draw_y;
}
