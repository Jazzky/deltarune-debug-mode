function _dcmd_get_room_id(arg0)
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

function dcmd_warp(argc, argv)
{
	var flags = dcmd_get_argv_flags(argv);
	argv = dcmd_remove_argv_flags(argv);
	argc = array_length(argv);

	var _room_index = room;
	if (argc != 1)
	{
		_room_index = _dcmd_get_room_id(argv[1]);
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

		dconsole_exec("setteam --noreload " + team_str);
	}

	if (dcmd_flags_flag_used(flags, "plot"))
		global.plot = real(dcmd_flags_get_value(flags, "plot"));

	if (dcmd_flags_flag_used(flags, "lw"))
		global.darkzone = 0;

	if (dcmd_flags_flag_used(flags, "dw"))
		global.darkzone = 1;

	room_goto(_room_index);
	return (0);
}
