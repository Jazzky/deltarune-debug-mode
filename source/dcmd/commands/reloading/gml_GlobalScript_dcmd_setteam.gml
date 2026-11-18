function _dcmd_arg_to_party_member(arg0)
{
	var arg = arg0;

	var is_id = dutils_isint(arg);
	if (is_id)
		return (real(arg));

	var low_arg = string_lower(arg);
	switch (low_arg)
	{
		case "k":
		case "kr":
		case "kri":
		case "kris":
			return (1);

		case "s":
		case "su":
		case "sus":
		case "susie":
			return (2);
		
		case "r":
		case "ra":
		case "ral":
		case "ralsei":
			return (3);

		case "n":
		case "no":
		case "noe":
		case "noelle":
		case "noëlle":
			return (4);
	}
	scr_debug_print("Unrecognized caracter " + string(arg) + ". Defaulting to empty");
	return (0);
}

function dcmd_setteam(argc, argv, flags)
{
	if (argc == 1)
		return (0);

	if (argc > 4)
	{
		scr_debug_print("Error: cannot have more than 3 party members");
		return (1);
	}

	var _char_index = (argc != 4)
	for (var i = 1; i < argc; i++)
	{
		global.char[_char_index++] = _dcmd_arg_to_party_member(argv[i]);
	}

	if (dcmd_flag_used(flags, "noreload") == 0)
	{
		snd_free_all();
		room_restart();
		global.interact = 0;
	}
	return (0);
}
