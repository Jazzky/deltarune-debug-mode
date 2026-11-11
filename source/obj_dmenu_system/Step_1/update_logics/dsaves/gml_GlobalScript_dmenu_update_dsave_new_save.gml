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
	
	/*var mono_spacing = (global.darkzone == 1) ? 15 : 8;
	var text_x = x_start + x_padding + xx;
	var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
	var max_width = box_right_edge - text_x;
	var is_multiline = false;
	var str_len = string_length(cur_btn);
	
	for (var i = 1; i <= str_len; i++)
	{
		var _char = string_char_at(cur_btn, i);
		
		if (_char == "\n")
			is_multiline = true;
	}

	if (max_width != -1)
		is_multiline |= ((cursor_x + (str_len * mono_spacing) - text_x) > max_width);*/
	var is_multiline = 1;
	dmenu_box = is_multiline ? 1 : 0;
	dbutton_layout = 3;
}
