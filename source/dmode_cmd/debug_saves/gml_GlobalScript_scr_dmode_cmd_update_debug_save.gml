function scr_dmode_cmd_update_debug_save(argc, argv)
{
	var flags = scr_dmode_get_argv_flags(argv);
	argv = scr_dmode_remove_argv_flags(argv);
	argc = array_length(argv);

	if (argc != 2)
		return (1);

	var target_sec = argv[1];
	var update_key_lst = [
		["savename", "SaveName"],
		["description", "Description"],
		["category", "Category"]
	];
	var update_lst = [];

	for (var i = 0; i < array_length(update_key_lst); i++)
	{
		var target_flag = update_key_lst[i][0];
		var target_ini_key = update_key_lst[i][1];
		if (scr_dmode_flags_flag_used(target_flag))
			array_push(update_lst, [target_ini_key, scr_dmode_flags_get_value(flags, target_flag)]);
	}
	
	var new_path = scr_debug_save_modify_info(target_sec, update_lst);
	return (new_path);
}
