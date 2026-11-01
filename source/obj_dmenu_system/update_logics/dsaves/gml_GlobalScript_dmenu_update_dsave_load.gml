function dmenu_update_dsave_load()
{
	dmenu_title = dstr("Options: ", "Options : ") + string(global.debug_selected_save_name);
	dbutton_options = [
			dstr("Load", "Charger"),
			dstr("Save", "Sauver"),
			dstr("Export", "Exporter"),
			dstr("Save management", "Gestion sauvegardes"),
			dstr("Delete", "Supprimer")
	];

	dbutton_indices = [-2, -2, -1, -1, -2];
	var subs = array_create(array_length(dbutton_options), 0);
	subs[2] = [
			dstr("Debug mode save", "Sauvegarde mode debug"),
			dstr("Default Deltarune save", "Sauvegarde Deltarune par défaut")
	];

	subs[3] = [
			dstr("Rename", "Renommer"),
			dstr("Edit description", "Modifier description"),
			dstr("Change category", "Changer catégorie")
	];

	dmenu_process_submenus(subs, "");
	if (!variable_global_exists("dload_cur_inv"))
		global.dload_cur_inv = 0;
	
	var load_options = [" (Normal)", dstr("  (Current inventory)", "  (Inventaire actuel)")];
	dbutton_options[0] += load_options[global.dload_cur_inv];
	dmenu_box = 1;
	dbutton_layout = 1;
}
