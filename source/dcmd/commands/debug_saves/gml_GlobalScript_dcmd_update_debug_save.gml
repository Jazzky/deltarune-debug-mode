function dcmd_update_debug_save(argc, argv, flags)
{
	if (argc != 2)
		return (1);

	var save_path = argv[1];
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
		if (dcmd_flag_used(flags, target_flag))
			array_push(update_lst, [target_ini_key, dcmd_get_flag(flags, target_flag)]);
	}
	
	scr_debug_save_modify_info(save_path, update_lst);
	return (0);
}
