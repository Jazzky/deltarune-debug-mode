function dutils_key_pressed(arg0)
{
	var key = arg0;
	var ipt_type = typeof(key);

	if (ipt_type == "string")
		key = ord(key);
	else if (ipt_type != "number")
		scr_debug_print("Input type = " + ipt_type);

	if (!keyboard_check(key))
		return (false);

	var timing = global.dkeyboard_timing;
	return (timing >= 15);
}

function dutils_read_kb_key()
{
	var cur_key = global.dcurrent_kb_key;
	var cur_key_pressed = false;

	if (cur_key != undefined)
		cur_key_pressed = keyboard_check(cur_key, false);

	if (cur_key_pressed) {
		if (dutils_key_pressed(cur_key))
			return (cur_key);
		return (undefined);
	}

	global.dkeyboard_timing = 0;

	var special_keys = [vk_left, vk_right, vk_up, vk_down, vk_backspace];
	for (var i = 0; i < array_length(special_keys); i++) {
		var key = special_keys[i];
		if (!keyboard_check_pressed(key))
			continue;

		global.dcurrent_kb_key = key;
		return (key);
	}

	if (keyboard_string == "") {
		global.dcurrent_kb_key = undefined;
		return (undefined);
	}

	global.dcurrent_kb_key = ord(keyboard_string);
	keyboard_string = "";
	return (global.dcurrent_kb_key);
}

function dutils_read_kb()
{
	var pressed_key = dutils_read_kb_key();

	if (pressed_key == undefined)
		return (undefined);

	var cur_text = global.kb_text;

	var is_char = true;
	var special_keys = [vk_left, vk_right, vk_up, vk_down, vk_backspace];
	for (var i = 0; i < array_length(special_keys); i++) {
		if (pressed_key != special_keys[i])
			continue;
		is_char = false;
		break;
	}

    if (pressed_key == vk_backspace && cur_text != "")
		cur_text = string_delete(cur_text, string_length(cur_text), 1);
    else if (is_char)
        cur_text += chr(pressed_key);
    
    global.kb_text = cur_text;
    return (pressed_key);
}
