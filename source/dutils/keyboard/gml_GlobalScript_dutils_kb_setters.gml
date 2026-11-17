function dutils_reading_kb()
{
	return (obj_dkeyboard_system.reading_kb);
}

function dutils_get_kb_text()
{
	return (obj_dkeyboard_system.get_text());
}

function dutils_set_kb_text(arg0)
{
	obj_dkeyboard_system.set_text(arg0);
}


function dutils_get_kb_cursor()
{
	return (obj_dkeyboard_system.cursor_pos);
}

function dutils_set_kb_cursor(arg0)
{
	var new_cursor_x = arg0;
	obj_dkeyboard_system.set_cursor_pos(new_cursor_x);
}

function dutils_get_kb_selection_range()
{
	if (!obj_dkeyboard_system.is_selecting)
		return (undefined);

	return (obj_dkeyboard_system.selected_ranges);
}

function dutils_cur_kb_key()
{
	return (obj_dkeyboard_system.current_key);
}


function dutils_toggle_kb(arg0=undefined, arg1="")
{
	obj_dkeyboard_system.toggle_kb(arg0);
	dutils_set_kb_text(arg1);
}

function dutils_key_pressed(arg0)
{
	return (obj_dkeyboard_system.key_pressed(arg0));
}
