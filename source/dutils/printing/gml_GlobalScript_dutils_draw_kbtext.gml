function dutils_draw_kbtext(arg0, arg1, arg2=true, arg3=c_white)
{
	var _x = arg0;
	var _y = arg1;
	var _draw_cursor = arg2;
	var _draw_color = arg3;

	var kb_text = dutils_get_kb_text();

	var _char_offset = 2;
	if (_draw_cursor)
	{
		var _cursor_pos = dutils_get_kb_cursor();
		var _text_before_cursor = string_copy(kb_text, 1, _cursor_pos);

		draw_set_color(c_white);
		draw_set_alpha(1);

		var _cursor_x = _x + string_width(_text_before_cursor);
		var _cursor_y_start = _y - _char_offset
		var _cursor_y_end = _y + string_height("|") + _char_offset

		draw_line(_cursor_x, _cursor_y_start, _cursor_x, _cursor_y_end);
	}

	var _selected_ranges = dutils_get_kb_selection_range();
	if (_selected_ranges != undefined)
	{
		var _selec_start = _selected_ranges[0];
		var _selec_end = _selected_ranges[1];

		var _text_before_selec = string_copy(kb_text, 1, _selec_start);
		var _selec_text = string_copy(kb_text, _selec_start, _selec_end - _selec_start);

		draw_set_color(c_blue);
		draw_set_alpha(0.6);

		var _start_x = _x + string_width(_text_before_selec);
		var _end_x = _start_x + string_width(_selec_text);
		var _left_y = _y - _char_offset;
		var _right_y = _y + string_height("|") + _char_offset;

		draw_rectangle(_start_x, _left_y, _end_x, _right_y, false);
	}

	draw_set_color(_draw_color);
	draw_set_alpha(1);
	draw_text(_x, _y, dutils_get_kb_text());
}
