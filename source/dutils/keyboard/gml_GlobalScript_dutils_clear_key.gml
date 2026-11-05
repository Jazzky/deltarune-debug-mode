function _dutils_set_key(arg0, arg1)
{
	var key = arg0;
	var value = arg1;

	var ipt_type = typeof(key);

	if (ipt_type == "string")
		key = ord(key);
	else if (ipt_type != "number")
		scr_debug_print("Input type = " + ipt_type);

	var _control_limit = 10;
	var _game_idx = -1;
	for (var i = 0 i < _control_limit; i++) {
		if (global.input_k[i] != key)
			continue;

		_game_idx = i;
		break;
	}

	if (value == 0)
		keyboard_clear(key);
	else
		keyboard_press(key);

	if (_game_idx != -1) {
		global.input_held[_game_idx] = value;
		global.input_pressed[_game_idx] = value;
	}
}

function dutils_clear_key(arg0)
{
	_dutils_set_key(arg0, 0);
}

function dutils_press_key(arg0)
{
	_dutils_set_key(arg0, 1);
}
