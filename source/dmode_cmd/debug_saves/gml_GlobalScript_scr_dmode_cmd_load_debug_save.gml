function scr_dmode_cmd_load_debug_save(argc, argv)
{
	var flags = scr_dmode_get_argv_flags(argv);
	argv = scr_dmode_remove_argv_flags(argv);
	argc = array_length(argv);

	if (argc != 2)
		return (1);

	var target_path = argv[1];
	var exist = file_exists(target_path);
	if (exist)
	{
		var keep_inv = scr_dmode_flags_flag_used(flags, "keepinv");
		global.dload_cur_inv = keep_inv;
		scr_debug_load(target_path);
		global.dload_cur_inv = 0;
	}
	else
	{
		snd_play(snd_error);
		scr_debug_print(dstr("Error: Save file '", "Erreur : Le fichier de sauvegarde '") + target_name + dstr("' could not be found on disk", "' n'a pu être trouvé"));
	}
	return (exist == 0);
}
