function dutils_get_kb_special_keys()
{
	return ([
		vk_left, vk_right, vk_up, vk_down,
		vk_backspace, vk_enter, vk_escape
	]);
}

function dutils_set_kb_text(arg0)
{
	keyboard_string = "";
	global.kb_text = arg0;
}

function dutils_get_kb_text()
{
	return (global.kb_text);
}

function dutils_cur_kb_key()
{
	return (global.dcurrent_kb_key);
}

function dutils_toggle_kb(arg0=undefined)
{
	if (arg0 == undefined)
		global.dreading_kb = !global.dreading_kb;
	else
		global.dreading_kb = arg0;

	global.kb_text = "";
	keyboard_string = "";
}

function dutils_reading_kb()
{
	return (global.dreading_kb);
}
