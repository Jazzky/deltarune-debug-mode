function dcmd_argv_respect_types()
{
	if (argument_count == 0)
	{
		scr_debug_print("Error: no argument passed to argv_respect_types");
		return (0);
	}
	else if (typeof(argument[0]) != "array")
	{
		scr_debug_print("Error: argv must be the first argument in argv_respect_types");
		return (0);
	}
	else if (argument_count == 1)
	{
		scr_debug_print("Error: no types nor check size passed in argv_start_respect_types");
		return (0);
	}

	var argv = argument[0];
	var n = array_length(argv) - 1;
	
	var types = [];
	for (var i = 0; i < n; i++)
		types[i] = argument[i + 1];

	for (var i = 0; i < n; i++)
	{
		var _respect = scr_string_respect_type(argv[i + 1], types[i], 0, 0);
		if (!_respect)
			return (0);
	}
	return (1);
}

function dcmd_argv_start_respect_types()
{
	if (argument_count == 0)
	{
		scr_debug_print("Error: no argument passed to argv_respect_types");
		return (0);
	}
	else if (typeof(argument[0]) != "array")
	{
		scr_debug_print("Error: argv must be the first argument in argv_respect_types");
		return (0);
	}
	else if (argument_count == 1)
	{
		scr_debug_print("Error: no types nor check size passed in argv_start_respect_types");
		return (0);
	}
	else if (typeof(argument[1]) != "int32")
	{
		scr_debug_print("Error: size passed in argv_start_respect_types isn't a int");
		return (0);
	}
	else if (argument_count == 2)
	{
		scr_debug_print("Error: no types passed in argv_start_respect_types");
		return (0);
	}

	var argv = argument[0];
	var n = argument[1];
	if (n == -1)
		n = array_length(argv) - 1;
	
	var types = [];
	for (var i = 0; i < n; i++)
		types[i] = argument[i + 2];

	for (var i = 0; i < n; i++)
	{
		var _respect = scr_string_respect_type(argv[i + 1], types[i], 0, 0);
		if (!_respect)
			return (0);
	}
	return (1);
}
