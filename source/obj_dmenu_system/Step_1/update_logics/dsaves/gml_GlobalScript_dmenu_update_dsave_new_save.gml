function dmenu_update_dsave_new_save()
{
	dmenu_title = "New debug save";
	dbuttons_2d = [
		[dstr("Enter save name", "Entrer nom de sauvegarde")],
		[dstr("Save", "Sauver"), dstr("Cancel", "Annuler")]
	];

	var cur_btn = dstr("Enter save name", "Entrer nom de sauvegarde");
	if (dutils_reading_kb())
	{
		cur_btn = dkeyboard_texts[0];
		dbuttons_2d[0][0] = cur_btn;
	}
	
	var mono_spacing = (global.darkzone == 1) ? 15 : 8;
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

	is_multiline |= (max_width > 0 && (cursor_x + (str_len * mono_spacing) - text_x) > max_width);
	dmenu_box = is_multiline ? 1 : 0;
	dbutton_layout = 3;
}
