function dmenuback_kb_flag_categories()
{
	if (keyboard_check_pressed(vk_escape) || up_pressed || down_pressed)
		return (-1);

	var _exit = enter_pressed;
	if (!_exit)
		return (0);

	var flag_text = dkeyboard_texts[0];
	var value_text = dkeyboard_texts[1];

	if (!dutils_isuint(flag_text, true)) {
		snd_play(299);
		return (-1);
	}

	var flag = real(flag_text);
	var flag_value = string(global.flag[flag]);
	if (value_text == "") {
		scr_debug_print("global.flag[" + flag_text + "] = |" + flag_value + "|");
		return (-1);
	}

	var value = dutils_parse_strvar(value_text);
	global.flag[flag] = value;

	scr_debug_print("Updated global.flag[" + flag_text + "] from " +
		"|" + flag_value + "| to " +
		"|" + value_text + "|"
	);
}
