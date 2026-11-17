dconsole_prefix = "[" + global.truename + "]: ";

if (!dconsole_active && keyboard_check_pressed(vk_f5) && !dutils_reading_kb())
{
	dconsole_active = true;
	global.interact = 1;
	sel_history_count = 0;
	dutils_toggle_kb(true);
}

dconsole_active &= global.interact;
if (!dconsole_active)
	exit;

if (keyboard_check_pressed(vk_escape))
{
	deactivate_menu(0);
	exit;
}

var _old_text = dinput_text;
dinput_text = dutils_get_kb_text();
if (dinput_text != _old_text)
	reset_blink();

if (mouse_wheel_up() || keyboard_check_pressed(vk_pageup))
{
	var _max_scroll = max(0, array_length(dconsole_log) - 1);
	dconsole_scroll = min(dconsole_scroll + 1, _max_scroll);
}

if (mouse_wheel_down() || keyboard_check_pressed(vk_pagedown))
	dconsole_scroll = max(dconsole_scroll - 1, 0);

if (dutils_key_pressed(vk_left) || dutils_key_pressed(vk_right))
{
	reset_blink();
}

if (keyboard_check_pressed(vk_enter))
{
	if (dinput_text != "")
	{
		array_push(dconsole_log, dconsole_prefix + dinput_text);
		array_push(dconsole_history, dinput_text);
		
		deactivate_menu();
		scr_dconsole_command(dinput_text);
		exit;
		dinput_text = "";
		sel_history_count = 0;
		dconsole_scroll = 0;
		reset_blink();
	}
}

if (dutils_key_pressed(vk_up) || dutils_key_pressed(vk_down))
{
	var _len = array_length(dconsole_history);
	var _to_add = dutils_key_pressed(vk_down) ? 1 : -1;
	
	sel_history_count += _to_add;
	if (sel_history_count < 0 || sel_history_count == _len)
		sel_history_count -= _to_add;
	else {
		var _entry = _len - sel_history_count;
		dinput_text = dconsole_history[_entry];
		dutils_set_kb_text(dinput_text);
		reset_blink();
	}
}

blink_timer++;
if (blink_timer > 30)
{
	draw_blink = !draw_blink;
	blink_timer = 0;
}

io_clear();
