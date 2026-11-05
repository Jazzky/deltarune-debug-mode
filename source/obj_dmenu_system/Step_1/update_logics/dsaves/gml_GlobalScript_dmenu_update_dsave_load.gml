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

	var subs = [
			dstr("Debug mode save", "Sauvegarde mode debug"),
			dstr("Default Deltarune save", "Sauvegarde Deltarune par défaut")
	];
	dmenu_create_category(2, subs);

	subs = [
			dstr("Rename", "Renommer"),
			dstr("Edit description", "Modifier description"),
			dstr("Change category", "Changer catégorie")
	];
	dmenu_create_category(3, subs);

	var load_options = [" (Normal)", dstr("  (Current inventory)", "  (Inventaire actuel)")];
	dbuttons[0].text += load_options[dload_options.target_keep_inv];

	dmenu_box = 1;
	dbutton_layout = 1;
}
