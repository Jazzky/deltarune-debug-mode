function dmenu_update_dsave_load()
{
	dmenu_title = dstr("Options: ", "Options : ") + string(global.debug_selected_save_name);
	dbuttons = [
			dmenu_makebt(dstr("Load", "Charger"), "load", [0, 1]),
			dmenu_makebt(dstr("Save", "Sauver"), "save"),
			dmenu_makebt(dstr("Export", "Exporter"), -1),
			dmenu_makebt(dstr("Save management", "Gestion sauvegardes"), -1),
			dmenu_makebt(dstr("Delete", "Supprimer"), "delete")
	];

	var subs = [
			dmenu_makebt(dstr("Debug mode save", "Sauvegarde mode debug"), "export_debug"),
			dmenu_makebt(dstr("Default Deltarune save", "Sauvegarde Deltarune par défaut"), "export_vanilla")
	];
	dmenu_create_category(2, subs);

	subs = [
			dmenu_makebt(dstr("Rename", "Renommer"), "rename"),
			dmenu_makebt(dstr("Edit description", "Modifier description"), "desc"),
			dmenu_makebt(dstr("Change category", "Changer catégorie"), "cate")
	];
	dmenu_create_category(3, subs);

	var load_options = [" (Normal)", dstr("  (Current inventory)", "  (Inventaire actuel)")];
	dbuttons[0].text += load_options[dload_options.target_keep_inv];

	dmenu_box = 1;
	dbutton_layout = 1;
}
