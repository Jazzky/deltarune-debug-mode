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

function _dcmd_check_access_lst(arg0, arg1)
{
	var lst = arg0;
	var len = arg1;

	for (var i = 1; i < len; i++) {
		if (!dutils_isuint(lst[i]))
			return (undefined);

		lst[i] = real(lst[i]);
	}
	return (lst);
}

function _dcmd_set_global(arg0, arg1, arg2) // screw you gms2
{
	var access_lst = arg0;
	var access_lst_len = arg1;
	var end_value = arg2;

	access_lst = _dcmd_check_access_lst(access_lst, access_lst_len);
	if (access_lst == undefined)
		return (1);

	var glob_name = access_lst[0];
	var glob_value = variable_global_get(glob_name);

	var lst = access_lst;
	if (access_lst_len == 1) {
		glob_value = end_value;
	}
	else if (access_lst_len == 2) {
		glob_value[lst[1]] = end_value;
	}
	else if (access_list_len == 3) {
		glob_value[lst[1]][lst[2]] = end_value;
	}
	else if (access_list_len == 4) {
		glob_value[lst[1]][lst[2]][lst[3]] = end_value;
	}
	else if (access_list_len == 5) {
		glob_value[lst[1]][lst[2]][lst[3]][lst[4]] = end_value;
	}
	else if (access_list_len == 6) {
		glob_value[lst[1]][lst[2]][lst[3]][lst[4]][lst[5]] = end_value;
	}

	variable_global_set(glob_name, glob_value);
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

	var res = _dcmd_set_global(access_list, access_list_len, end_value);
	return (res);
}
