function scr_dmode_cmd_delete_debug_save(argc, argv)
{
	if (argc != 2)
		return (1);

	var target_path = argv[1];
	
    if (!file_exists(target_path))
    {
        scr_debug_print(dstr("Error: File already missing", "Erreur : Fichier déjà manquant"));
		return (1);
	}

	file_delete(target_path);
	scr_debug_cleanup_folder(target_path);
	scr_debug_print(dstr("Save file permanently deleted", "Fichier de sauvegarde supprimé"));
	snd_play(snd_badexplosion);
	scr_get_debug_save_list();
	return (0);
}
