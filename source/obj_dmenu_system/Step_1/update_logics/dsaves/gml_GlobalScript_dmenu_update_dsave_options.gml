function dmenu_update_dsave_metadata()
{
	if (dmenu_state == "dsave_edit_name")
		dmenu_title = dstr("Rename save", "Renommer sauvegarde");

	else if (dmenu_state == "dsave_edit_desc")
		dmenu_title = dstr("Edit description", "Modifier description");

	else if (dmenu_state == "dsave_edit_cat")
		dmenu_title = dstr("Change category", "Changer catégorie");
	
	dbuttons_2d = [
		[
			dmenu_makebt("", 1)
		],
		[
			dmenu_makebt(dstr("Save", "Sauver")),
			dmenu_makebt(dstr("Cancel", "Annuler"))
		]
	];

	dmenu_set_bttype(dbuttons_2d[0][0], "keyboard");

	var target_path = dload_options.target_path;
	var default_text = "";
	
	if (dmenu_state == "dsave_edit_name")
		default_text = dstr("Enter save name", "Entrer nom de sauvegarde");

	else if (dmenu_state == "dsave_edit_desc")
		default_text = dstr("Enter description", "Entrer description");

	else if (dmenu_state == "dsave_edit_cat")
		default_text = dstr("Enter category", "Entrer catégorie");
	

	var cur_btn = dkeyboard_texts[0];
	if (cur_btn == "")
		cur_btn = default_text;
	
	var _max_width = 25;
	var boxed_string = dutils_boxbound_string(dbuttons_2d[0][0].text, _max_width);
	dbuttons_2d[0][0].text = boxed_string;

	var is_multiline = string_count("\n", boxed_string);
	dmenu_box = is_multiline ? 1 : 0;
	dbutton_layout = 3;
}
