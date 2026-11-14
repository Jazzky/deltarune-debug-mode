function dmenu_update_dsave_new_save()
{
	dmenu_title = "New debug save";
	dbuttons_2d = [
		[
			dmenu_makebt(dstr("Enter save name", "Entrer nom de sauvegarde"), 1)
		],
		[
			dmenu_makebt(dstr("Save", "Sauver")),
			dmenu_makebt(dstr("Cancel", "Annuler"))
		]
	];

	dmenu_set_bttype(dbuttons_2d[0][0], "keyboard");

	var ipt_text = dkeyboard_texts[0];
	if (ipt_text != "")
		dbuttons_2d[0][0].text = ipt_text;;
	
	var _max_width = 25;
	var boxed_string = dutils_boxbound_string(dbuttons_2d[0][0].text, _max_width);
	dbuttons_2d[0][0].text = boxed_string;

	var is_multiline = string_count("\n", boxed_string);
	dmenu_box = is_multiline ? 1 : 0;
	dbutton_layout = 3;
}
