function _read_kb_key()
{
	for (var i = 0; i < nb_special_keys; i++) {
		var key = special_keys[i];
		if (!keyboard_check_pressed(key))
			continue;

		pressing_special = true;
		return (key);
	}

	if (pressing_special) {
		if (keyboard_check(current_key))
			return (current_key);

		pressing_special = false;
	}

	var keyboard_strlen = string_length(keyboard_string);
	if (keyboard_strlen == 0) {
		return (undefined);
	}

	var newchar = ord(string_char_at(keyboard_string, 1));
	return (newchar);
}


var pressed_key = _read_kb_key();
keyboard_string = "";
set_pressed_key(pressed_key);

if (!reading_kb)
	exit;

if (scr_debug() && keyboard_check_pressed(vk_control))
{
	scr_debug_print("Text = " + text + ", len = " + string(text_len) + ", cursor_pos = " + string(cursor_pos));
}

if (dkeyboard_check_shortcut())
	exit;

if (!valid_key_input())
	exit;

var is_char = true;
for (var i = 0; i < nb_special_keys; i++) {
	if (pressed_key != special_keys[i])
		continue;

	is_char = false;
	break;
}

if (is_char)
	add_text(chr(pressed_key));

else if (pressed_key == vk_left)
	move_cursor_left();

else if (pressed_key == vk_right)
	move_cursor_right();

else if (pressed_key == vk_backspace || pressed_key == vk_delete)
	erase_cursor();
