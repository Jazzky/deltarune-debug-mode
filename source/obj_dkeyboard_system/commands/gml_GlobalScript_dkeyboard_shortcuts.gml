function _dkeyboard_shortcut_ctrl_a()
{
	if (!text_len)
		exit;

	set_cursor_pos(0);
	set_selected_ranges(0, text_len);
	is_selecting = true;
}

function _dkeyboard_shortcut_ctrl_c()
{
	if (!is_selecting)
		exit;

	kbcopy_text(get_selected_text());
}

function _dkeyboard_shortcut_ctrl_x()
{
	if (!is_selecting)
		exit;

	_dkeyboard_shortcut_ctrl_c();
	erase_cursor();
}

function _dkeyboard_shortcut_ctrl_v()
{
	var clipboard_text = get_clipboard_text();
	add_text(clipboard_text);
}

function dkeyboard_check_shortcut()
{
	var ctrl = keyboard_check_direct(vk_control);
	var alt = keyboard_check_direct(vk_alt);
	var shift = keyboard_check_direct(vk_shift);

	var callfunc = undefined;

	if (ctrl && keyboard_check_pressed(ord("A")))
		callfunc = _dkeyboard_shortcut_ctrl_a;

	else if (ctrl && keyboard_check_pressed(ord("C")))
		callfunc = _dkeyboard_shortcut_ctrl_c();

	else if (ctrl && keyboard_check_pressed(ord("V")))
		callfunc = _dkeyboard_shortcut_ctrl_v();

	else if (ctrl && keyboard_check_pressed(ord("X")))
		callfunc = _dkeyboard_shortcut_ctrl_x();

	if (callfunc == undefined)
		return (false);

	callfunc();
	return (true);
}
