function scr_dmode_get_argv_flags(arg0, arg1="--")
{
	var argv = arg0;
	var argc = array_length(argv);

	var flags = []
	var flag_index = 0;

	var flag_suffix = arg1;
	var flag_suf_len = string_length(flag_suffix);

	for (var i = 1; i < argc; i++)
	{
		var arg = argv[i];
		
		if (arg == flag_suffix)
			break;
		
		var arg_len = string_length(arg);
		if (arg_len >= 2 && (string_copy(arg, 1, flag_suf_len) == flag_suffix))
			flags[flag_index++] = string_copy(arg, 1 + flag_suf_len, arg_len - flag_suf_len);
	}

	return (flags);
}

function scr_dmode_remove_argv_flags(arg0, arg1="--")
{
	var argv = arg0;
	var argc = array_length(argv);

	var flags_saw = 0;
	var flag_suffix = arg1;
	var flag_suf_len = string_length(flag_suffix);

	for (var i = 1; i < argc; i++)
	{
		var arg = argv[i];
		
		if (arg == flag_suffix)
		{
			flags_saw++;
			break;
		}
		
		var arg_len = string_length(arg);
		if (arg_len >= 2 && (string_copy(arg, 1, flag_suf_len) == flag_suffix))
		{
			flags_saw++;
			for (var j = i; j < (argc - flags_saw); j++)
				argv[j] = argv[j + 1];
		}
	}
	array_resize(argv, argc - flags_saw);
	return (argv);
}

function scr_dmode_flags_flag_used(arg0, arg1, arg2="=")
{
	var flag_list = arg0;

	var target = arg1;
	var target_len = string_length(target);

	var value_sep = arg2;
	var value_sep_len = string_length(value_sep);

	for (var i = 0; i < array_length(flag_list); i++)
	{
		var cur_flag = flag_list[i];
		if (string_copy(cur_flag, 1, target_len) != target)
			continue;

		if (string_length(cur_flag) == target_len)
			return (1);

		if (string_copy(cur_flag, 1 + target_len, value_sep_len) == value_sep)
			return (1);
	}
	return (0);
}

function scr_dmode_flags_get_value(arg0, arg1, arg2="=")
{
	var flag_list = arg0;

	var target = arg1;
	var target_len = string_length(target);

	var value_sep = arg2;
	var value_sep_len = string_length(value_sep);

	for (var i = 0; i < array_length(flag_list); i++)
	{
		var cur_flag = flag_list[i];
		if (string_copy(cur_flag, 1, target_len) != target)
			continue;

		if (string_length(cur_flag) == target_len)
			return ("");

		if (string_copy(cur_flag, 1 + target_len, value_sep_len) == value_sep)
			return (string_copy(cur_flag, 1 + target_len + value_sep_len, string_length(cur_flag) - target_len - value_sep_len));
	}
	return ("");
}
