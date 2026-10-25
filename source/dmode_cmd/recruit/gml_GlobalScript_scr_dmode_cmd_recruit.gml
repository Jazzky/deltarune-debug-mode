function scr_dmode_cmd_recruit(argc, argv)
{
	if (global.chapter == 1)
		return (1);

	var flags = scr_dmode_get_argv_flags(argv);
	argv = scr_dmode_remove_argv_flags(argv);
	argc = array_length(argv);

	var recruit_lst = []
	if (argc == 1)
		return (0);

	if (scr_dmode_flags_flag_used(flags, "all"))
	{
		recruit_lst = ds_map_values_to_array(global.recruits_id_map);
	}
	else if (scr_dmode_flags_flag_used(flags, "chap"))
	{
//TODO AAAAAAAAAAAA
		if (
		recruit_lst = 
	}
	
	return (0);
}
