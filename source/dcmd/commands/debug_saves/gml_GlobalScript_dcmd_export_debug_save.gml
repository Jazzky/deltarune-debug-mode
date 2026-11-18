function dcmd_export_debug_save(argc, argv, flags)
{
	if (argc != 2)
		return (1);

	var source_file = argv[1];
	if (!file_exists(source_file))
	{
		scr_debug_print(dstr("Error: Base save file not found", "Erreur : Fichier de sauvegarde de base introuvable"));
		snd_play(snd_error);
		return (1);
	}

	var export_mode = "normal";
	if (dcmd_flag_used(flags, "mode"))
		export_mode = dcmd_get_flag(flags, "mode");


	if (export_mode == "normal")
		_dcmd_export_normal(source_file);

	else if (export_mode == "debug")
		_dcmd_export_debug(source_file);

	else
	{
		scr_debug_print(dstr("Error: unrecognized export format", "Erreur : format d'export inconnu"));
		snd_play(snd_error);
		return (1);
	}
	return (0);
}

function _dcmd_export_normal(arg0)
{
	var source_file = arg0;

	var _route_suffix = "";
	if (variable_global_exists("filechoice_route"))
		_route_suffix = string(global.filechoice_route);

	var suggested_name = "filech" + string(global.chapter) + "_0" + _route_suffix;
	var export_path = get_save_filename("Deltarune Save|*", suggested_name);

	if (export_path == "")
	{
		scr_debug_print(dstr("Export cancelled", "Exportation annulée"));
		exit;
	}

	var _save = dsaves_get_file_info(source_file);
	dsave_export_savedata(_save, export_path)

	scr_debug_print("'" + _save.SaveName + "' exporté avec succès !");
	snd_play(snd_shineselect);
}

function _dcmd_export_debug(arg0)
{
	var source_file = arg0;
	var filename = filename_name(source_file);
	var export_path = get_save_filename("Debug save (*.save)|*.save", filename);

	if (file_exists(export_path))
		file_delete(export_path);

	file_copy(source_file, export_path);
	scr_debug_print(dstr("Exported custom .save successfully!", "Fichier .save exporté avec succès !"));
	snd_play(snd_shineselect);
}
