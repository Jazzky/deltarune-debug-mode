function dcmd_save_debug_save(argc, argv, flags)
{
	if (argc > 2)
		return (1);

	var target_name = "Untitled";
	if (argc == 2)
		target_name = argv[1];

	global.debug_saving = 1;
	target_name = target_name + ".save";
	scr_debug_save(target_name);
	scr_debug_print(dstr("Save created: ", "Sauvegarde créée : ") + target_name);
	snd_play(snd_save);                                                              
}
