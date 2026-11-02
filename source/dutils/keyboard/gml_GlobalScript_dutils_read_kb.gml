function dutils_read_kb_key()
{
	var cur_key = global.dcurrent_kb_key;

	global.dkeyboard_timing++;
	if (cur_key != undefined && keyboard_check(cur_key)) {
		if (global.dkeyboard_timing > 15)
			return (cur_key);
		return (undefined);
	}

	global.dkeyboard_timing = 0;
	if (keyboard_string == "") {
		global.dcurrent_kb_key = undefined;
		return (undefined);
	}

	global.dcurrent_kb_key = keyboard_string;
	scr_debug_print("Caca |" + keyboard_string + "|");
	keyboard_string = "";
	return (global.dcurrent_kb_key);
}

function dutils_read_kb()
{
	var pressed_key = dutils_read_kb_key();

	if (pressed_key == undefined)
		return (false);

	var cur_text = global.kb_text;
	var backspace_action = (pressed_key == vk_delete);
    if (backspace_action && cur_text != "")
		cur_text = string_delete(cur_text, string_length(cur_text), 1);
    else
        cur_text += pressed_key;
    
    global.kb_text = cur_text;
    return (true);
}
