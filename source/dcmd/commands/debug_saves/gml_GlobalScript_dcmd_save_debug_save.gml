function dcmd_save_debug_save(argc, argv, flags)
{
	if (argc > 2)
		return (1);

	var target_name = "Untitled";
	var base_folder = "debug_save/ch" + string(global.chapter) + "/";
	if (argc == 2)
		target_name = argv[1];

	if (!string_starts_with(target_name, base_folder))
		target_name = base_folder + target_name;

	if (!string_ends_with(target_name, ".save"))
		target_name += ".save";

	scr_debug_save(target_name);
	scr_debug_print(dstr("Save created: ", "Sauvegarde créée : ") + target_name);
	snd_play(snd_save);                                                              
}
