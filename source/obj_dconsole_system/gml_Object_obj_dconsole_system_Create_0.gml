dconsole_active = false;
dinput_text = "";

dconsole_history = [];
dconsole_log = [];

dconsole_height = 200;
dconsole_max_lines = floor((dconsole_height - 65) / 20) + 1;

draw_blink = true;
blink_timer = 0;
sel_history_count = 0;
dconsole_scroll = 0;

deactivate_menu = function(arg0=0)
{
	global.interact = arg0;
	dconsole_active = false;
	dutils_toggle_kb(false);
	io_clear();
}

reset_blink = function()
{
	draw_blink = true;
	blink_timer = 0;
}
