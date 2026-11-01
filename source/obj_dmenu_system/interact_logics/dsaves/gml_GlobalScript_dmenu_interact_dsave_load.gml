function dmenu_interact_dsave_load()
{
	var check_name = selected_name;
	if (dmenu_interact_submenus(check_name))
		exit;

	if (string_ends_with(check_name, " v") || string_ends_with(check_name, " ^"))
		check_name = string_copy(check_name, 1, string_length(check_name) - 2);
	
	var target_sec = global.debug_selected_save_section;
	var target_name = global.debug_selected_save_name;
	
	if (check_name == dstr("Save", "Sauver"))
		dmenu_interact_dsave_save();

	else if (string_copy(check_name, 1, (global.dlang == "en") ? 4 : 7) == dstr("Load", "Charger"))
		dmenu_interact_dsave_load();

	else if (check_name == dstr("Delete", "Supprimer"))
		dmenu_interact_dsave_delete();

	else if (check_name == "- " + dstr("Debug mode save", "Sauvegarde mode debug"))
		dmenu_interact_dsave_export_dsave();

	else if (check_name == "- " + dstr("Default Deltarune save", "Sauvegarde Deltarune par défaut"))
		dmenu_interact_dsave_export_normal();

	else if (check_name == "- " + dstr("Rename", "Renommer") ||
			 check_name == "- " + dstr("Edit description", "Modifier description") ||
			 check_name == "- " + dstr("Change category", "Changer description")
	)
		dmenu_interact_dsave_update_metadata();
}
