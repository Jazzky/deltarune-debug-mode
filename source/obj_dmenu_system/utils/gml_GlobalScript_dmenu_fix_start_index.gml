function dmenu_fix_start_index()
{
	var y_limit = array_length(dbuttons);
	var drawn_elements = min(5, y_limit); //TODO check if a variable exist
	var middle_elements = ceil(drawn_elements / 2);

	var new_draw_y = dmenu_start_index;
	if (dvertical_index < middle_elements)
		new_draw_y = dvertical_index;

	else if (dvertical_index >= (y_limit - middle_elements))
		new_draw_y = drawn_elements - (y_limit - dvertical_index);

	dmenu_start_index = new_draw_y;
}
