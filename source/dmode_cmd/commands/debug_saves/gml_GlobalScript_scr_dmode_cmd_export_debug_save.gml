function dcmd_export_debug_save(argc, argv)
{
	var flags = dcmd_get_argv_flags(argv);
	argv = dcmd_remove_argv_flags(argv);
	argc = array_length(argv);

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
	if (dcmd_flags_flag_used(flags, "mode"))
		export_mode = dcmd_flags_get_value(flags, "mode");


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

	if (file_exists(export_path))
		file_delete(export_path);

	if (!(string_copy(source_file, string_length(source_file) - 4, 5) == ".save"))
	{
		file_copy(source_file, export_path);
	}
	else
	{
		var file_id = file_text_open_read(source_file);
		var json_string = "";

		while (!file_text_eof(file_id))
		{
			json_string += file_text_read_string(file_id);
			file_text_readln(file_id);

			if (!file_text_eof(file_id))
				json_string += "\n";
		}

		file_text_close(file_id);
		var parsed_data = -1;

		try
		{
			parsed_data = json_parse(json_string);
		}
		catch (e)
		{
		}

		if (is_struct(parsed_data) && variable_struct_exists(parsed_data, "save_file"))
		{
			var raw_content = parsed_data.save_file;
			var out_file = file_text_open_write(export_path);
			file_text_write_string(out_file, raw_content);
			file_text_close(out_file);
		}
	}
	scr_debug_print("'" + string("TODO") + "' exporté avec succès !");
	snd_play(snd_shineselect);
}

function _dcmd_export_debug(arg0)
{
	var source_file = arg0;
	var export_path = get_save_filename("Debug save (*.save)|*.save", string("TODO") + ".save");

	if (file_exists(export_path))
		file_delete(export_path);

	file_copy(source_file, export_path);
	scr_debug_print(dstr("Exported custom .save successfully!", "Fichier .save exporté avec succès !"));
	snd_play(snd_shineselect);
}
