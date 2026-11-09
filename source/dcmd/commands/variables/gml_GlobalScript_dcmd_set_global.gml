function _dcmd_get_global_string(arg0)
{
	var access_list = dutils_get_global_access_list(arg0);
	if (access_list == undefined)
		return ("");

	var access_len = darray_length(access_list);

	var global_name = access_list[0];
	if (!variable_global_exists(global_name))
		return ("");

	var glob_value = variable_global_get(global_name);
	if (access_len == 1)
		return (string(glob_value));

	for (var i = 1; i < access_len; i++) {
		var access_index_str = access_list[i];
		if (!dutils_isuint(access_index_str)) {
			scr_debug_print("Error: invalid number '" + access_index_str + "'");
			return (undefined);
		}

		var access_index = real(access_index_str);
		if (typeof(glob_value) != "array")
			return (dstr("(Not an array)", "(Pas un tableau)"));
		if (access_index >= array_length(glob_value))
			return (dstr("(Index too high)", "(Index trop élevé)"));

		if (i == (access_len - 1))
			return (string(glob_value[access_index]));
		glob_value = glob_value[access_index];
	}
	return ("");
}

function _dcmd_set_direct_global(arg0, arg1)
{
	var global_name = arg0;
	var end_value = arg1;

	var glob_exists = variable_global_exists(global_name);
	var glob_value = variable_global_get(global_name);
	if (!end_value == undefined) {
		if (!glob_exists)
			scr_debug_print("Global '" + global_name + "' doesn't exists");
		else
			scr_debug_print("Global '" + global_name + "' = " + string(glob_value));
	}
	else {
		variable_global_set(global_name, end_value)
		if (!glob_exists)
			scr_debug_print("Global '" + global_name + "' created!");
		else
			scr_debug_print("Global '" + global_name + "' updated!");
	}
	return (0);
}

function _dcmd_set_array_global(arg0, arg1, arg2)
{
	var global_name = arg0;
	var access_list = arg1;
	var end_value = arg2;

	var glob_exists = variable_global_exists(global_name);
	var glob_value = variable_global_get(global_name);
	var access_len = darray_length(access_list);

	for (var i = 1; i < access_len; i++) {
		var access_index_str = access_list[i];
		if (!dutils_isuint(access_index_str)) {
			scr_debug_print("Error: invalid number '" + access_index_str + "'");
			return (1);
		}

		var access_index = real(access_index_str);
		if (i == (access_len - 1))
			glob_value[access_index] = end_value;

		else
			glob_value = glob_value[access_index];
	}
	return (0);
}

function dcmd_set_global(argc, argv, flags)
{
	if (argc == 1)
		return (0);

	var global_str = argv[1];
	var end_value = undefined;
	var update_global = (argc == 3);
	if (update_global)
		end_value = dutils_parse_strvar(argv[argc - 1]);

	var access_list = dutils_get_global_access_list(argv[1]);
	if (access_list == undefined)
		return (1);

	var access_list_len = darray_length(access_list);
	var global_name = access_list[0];
	var res;
	if (access_list_len == 1)
		res = _dcmd_set_direct_global(global_name, end_value);
	else
		res = _dcmd_set_array_global(global_name, access_list, end_value);

	return (res);
}
