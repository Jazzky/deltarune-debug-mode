function dcmd_load_debug_save(argc, argv, flags)
{
	if (argc != 2)
		return (1);

	var target_path = argv[1];
	var exist = file_exists(target_path);
	if (exist)
	{
		var keep_inv = dcmd_flag_used(flags, "keepinv");
		scr_debug_load(target_path, keep_inv);
	}
	else
	{
		snd_play(snd_error);
		scr_debug_print(dstr("Error: Save file '", "Erreur : Le fichier de sauvegarde '") + target_name + dstr("' could not be found on disk", "' n'a pu être trouvé"));
	}
	return (exist == 0);
}
