init_kb = function ()
{
	// Main stuff
	text = "";
	text_len = 0;
	reading_kb = false;
	current_key = undefined;
	pressing_special = false;


	// Not that important stuff
	key_timing = 0;
	key_timing_threshold = 10;
	cursor_pos = 0;
	is_selecting = false;
	selected_range_origin = 0;
	selected_ranges = [0, 0];


	// Shortcut stuff
	back_clipboard = "";


	// Settings
	allow_movement = true;
	special_keys = [
		vk_left, vk_right, vk_up, vk_down,
		vk_backspace, vk_delete,
		vk_enter, vk_escape
	];
	nb_special_keys = array_length(special_keys);
}

init_kb();


// General Functions
move_cursor = function(arg0, arg1)
{
	var _left = arg0;
	var _right = arg1;

	if ((!_left && !_right) || (_left && _right))
		exit;

	var _new_cursor_pos;

	var update_ranges = keyboard_check_direct(vk_shift);
	if (!is_selecting && update_ranges) {
		selected_range_origin = cursor_pos;
		reset_selected_ranges();
	}

	if (!update_ranges && is_selecting)
		_new_cursor_pos = selected_ranges[_right];

	else {
		_new_cursor_pos = get_next_cursor_pos(_left ? -1 : 1);
		if (update_ranges) {
			if (_new_cursor_pos <= selected_range_origin)
				selected_ranges = [_new_cursor_pos, selected_range_origin];
			else
				selected_ranges = [selected_range_origin, _new_cursor_pos];
		}
	}

	is_selecting = update_ranges;
	if (is_selecting && selected_ranges[0] == selected_ranges[1])
		is_selecting = false;

	cursor_pos = _new_cursor_pos;
}

add_text = function(arg0)
{
	var new_text = arg0;
	var new_len = string_length(new_text);

	if (is_selecting)
		erase_cursor();

	text = string_insert(new_text, text, cursor_pos + 1);

	cursor_pos += new_len;
	text_len += new_len;
}

erase_cursor = function()
{
	var _direction = 1;

	if (keyboard_check(vk_backspace)) //TODO use designated function for calling
		_direction = -1;

	var erase_start = cursor_pos;
	var erase_end = cursor_pos;
	if (is_selecting) {
		erase_start = selected_ranges[0];
		erase_end = selected_ranges[1];
		is_selecting = false;
	}
	else if (_direction == -1) {
		erase_start = get_next_cursor_pos(_direction);
	}
	else if (_direction == 1) {
		erase_end = get_next_cursor_pos(_direction);
	}

	if (erase_start == erase_end)
		exit;

	var nb_deleted = erase_end - erase_start;
	text = string_delete(text, erase_start + 1, nb_deleted);

	text_len -= nb_deleted;
	cursor_pos = erase_start;
}

set_pressed_key = function(arg0)
{
	var new_key = arg0;

	if (new_key != current_key) {
		current_key = new_key;
		key_timing = 0;
	}
	else {
		key_timing++;
	}
}

get_next_cursor_pos = function(arg0)
{
	var _incr = arg0;
	var new_pos = cursor_pos;

	var break_counter = 1;

	var ctrl_mode = keyboard_check_direct(vk_control);
	if (ctrl_mode) {
		if (_incr == -1 && dutils_iswhitespace(get_left_char()))
			break_counter = 2;
		else if (_incr == 1 && dutils_iswhitespace(get_right_char()))
			break_counter = 2;
	}

	while (1)
	{
		if (_incr == -1 && new_pos == 0)
			break;
		if (_incr == 1 && new_pos == text_len)
			break;

		if (break_counter == 0)
			break;

		new_pos += _incr;
		if (!ctrl_mode) {
			break_counter--;
		}

		else if (ctrl_mode) {
			var mychar = string_char_at(text, new_pos);
			var char_is_ws = dutils_iswhitespace(mychar);

			if (break_counter == 1 && char_is_ws)
				break_counter--;
			else if (break_counter == 2 && !char_is_ws)
				break_counter--;
		}
	}
	return (new_pos);
}

get_nchar = function(arg0, arg1=true)
{
	var pos = arg0;
	var get_after = arg1;

	if (!get_after && pos <= 0)
		return (undefined);
	if (get_after && pos >= text_len)
		return (undefined);

	var _charpos = pos + (get_after ? 1 : 0);
	return (string_char_at(text, _charpos));
}


timing_passed = function()
{
	return (key_timing == 0 || key_timing >= key_timing_threshold);
}

valid_key_input = function()
{
	if (current_key == undefined)
		return (false);
	return (timing_passed());
}


// Wrappers
move_cursor_left = function()
{
	move_cursor(true, false);
}

move_cursor_right = function()
{
	move_cursor(false, true);
}

get_left_char = function(arg0=cursor_pos)
{
	return (get_nchar(cursor_pos, false))
}

get_right_char = function(arg0=cursor_pos)
{
	return (get_nchar(cursor_pos, true))
}

reset_selected_ranges = function()
{
	set_selected_ranges(cursor_pos, cursor_pos);
}

// API Functions
key_pressed = function(arg0)
{
	var key = arg0;
	var ipt_type = typeof(key);

	if (ipt_type == "string")
		key = ord(key);

	if (!keyboard_check(key))
		return (false);

	return (valid_key_input());
}

kbcopy_text = function(arg0)
{
	var copied_text = arg0;

	back_clipboard = copied_text;
	clipboard_set_text(copied_text);
}

get_clipboard_text = function()
{
	if (clipboard_has_text())
		return (clipboard_get_text());
	return (back_clipboard);
};

get_selected_text = function()
{
	if (!is_selecting)
		return ("");

	var _selec_start = selected_ranges[0];
	var _selec_end = selected_ranges[1];
	return (string_copy(text, _selec_start, _selec_end - _selec_start));
};

set_selected_ranges = function(arg0, arg1)
{
	selected_ranges[0] = arg0;
	selected_ranges[1] = arg1;
};

toggle_kb = function(arg0=undefined)
{
	if (arg0 == undefined)
		reading_kb = !reading_kb;
	else
		reading_kb = arg0;

	text = "";
	keyboard_string = "";
};

set_cursor_pos = function(arg0=cursor_pos)
{
	cursor_pos = clamp(arg0, 0, text_len);
	selected_range_origin = cursor_pos;
}

get_text = function()
{
	return (text);
};

set_text = function(arg0)
{
	text = arg0;
	text_len = string_length(text);
	set_cursor_pos();
	keyboard_string = "";
};
