function dmenu_update_dsave_load()
{
	dmenu_title = dstr("Options: ", "Options : ") + string(global.debug_selected_save_name);
	dbuttons = [
		dmenu_makebt(dstr("Load", "Charger"), -2, [0, 1]),
		dmenu_makebt(dstr("Save", "Sauver"), -2),
		dmenu_makebt(dstr("Export", "Exporter"), -1),
		dmenu_makebt(dstr("Save management", "Gestion sauvegardes"), -1),
		dmenu_makebt(dstr("Delete", "Supprimer"), -2)
	];

	var subs = array_create(array_length(dbuttons), 0);
	subs[2] = [
			dstr("Debug mode save", "Sauvegarde mode debug"),
			dstr("Default Deltarune save", "Sauvegarde Deltarune par défaut")
	];

	subs[3] = [
			dstr("Rename", "Renommer"),
			dstr("Edit description", "Modifier description"),
			dstr("Change category", "Changer catégorie")
	];

	dmenu_dsave_process_submenus(subs, "");
	if (!variable_global_exists("dload_cur_inv"))
		global.dload_cur_inv = 0;
	
	var load_options = [" (Normal)", dstr("  (Current inventory)", "  (Inventaire actuel)")];
	dbuttons[0].text += load_options[global.dload_cur_inv];

	dmenu_box = 1;
	dbutton_layout = 1;
}
