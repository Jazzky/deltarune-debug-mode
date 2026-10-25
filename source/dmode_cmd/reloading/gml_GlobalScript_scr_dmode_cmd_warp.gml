function _scr_dmode_cmd_get_room_id(arg0)
{
	var arg = arg0;

	if (scr_string_respect_type(arg, "uint") && room_exists(real(arg)))
		return (real(arg));

	var cur_room = room_first;
	while (cur_room != -1)
	{
		var cur_room_name = room_get_name(cur_room)
		if (cur_room_name == arg0)
			return (cur_room);

		cur_room = room_next(cur_room);
	}
	scr_debug_print("Error, room " + arg + " not found, defaulting to current room");
	return (-1);
}

function scr_dmode_cmd_warp(argc, argv)
{
	var flags = scr_dmode_get_argv_flags(argv);
	argv = scr_dmode_remove_argv_flags(argv);
	argc = array_length(argv);

	var _room_index = room;
	if (argc != 1)
	{
		_room_index = _scr_dmode_cmd_get_room_id(argv[1]);
		if (_room_index == -1)
			_room_index = room;
	}

	if (!room_exists(_room_index))
	{
		scr_debug_print("Error, room id " + string(_room_index) + " doesn't exist");
		return (1);
	}

	if (argc > 2)
	{
		var team_str = "";
		for (var i = 2; i < argc; i++)
			team_str += argv[i] + " ";

		scr_dmode_parse_cmd("setteam --noreload " + team_str);
	}

	if (scr_dmode_flags_flag_used(flags, "plot"))
		global.plot = real(scr_dmode_flags_get_value(flags, "plot"));

	if (scr_dmode_flags_flag_used(flags, "lw"))
		global.darkzone = 0;

	if (scr_dmode_flags_flag_used(flags, "dw"))
		global.darkzone = 1;

	room_goto(_room_index);
	return (0);
}
