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
			dmenu_makebt("")
		],
		[
			dmenu_makebt(dstr("Save", "Sauver")),
			dmenu_makebt(dstr("Cancel", "Annuler"))
		]
	];

	dmenu_set_bttype(dbuttons_2d[0][0], "keyboard");

	var target_path = global.debug_selected_save_section;
	var default_text = "";
	
	if (dmenu_state == "dsave_edit_name")
		default_text = dstr("Enter save name", "Entrer nom de sauvegarde");

	else if (dmenu_state == "dsave_edit_desc")
		default_text = dstr("Enter description", "Entrer description");

	else if (dmenu_state == "dsave_edit_cat")
		default_text = dstr("Enter category", "Entrer catégorie");
	

	for (var i = 0; i < array_length(debug_save_sections); i++)
	{
		if (debug_save_sections[i] == target_path)
		{
			if (dmenu_state == "dsave_edit_name")
				default_text = debug_save_names[i];
			else if (dmenu_state == "dsave_edit_desc")
				default_text = debug_save_descriptions[i];
			else if (dmenu_state == "dsave_edit_cat")
				default_text = debug_save_categories[i];
			
			break;
		}
	}
	
	var cur_btn = dkeyboard_texts[0];
	if (cur_btn == "")
		cur_btn = default_text;
	
	dbuttons_2d[0][0].text = cur_btn;
	var mono_spacing = (global.darkzone == 1) ? 15 : 8;
	var text_x = x_start + x_padding + xx;
	var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
	var max_width = box_right_edge - text_x;
	var cursor_x = text_x;
	var is_multiline = false;
	var current_word = "";
	var str_len = string_length(cur_btn);
	
	for (var i = 1; i <= str_len; i++)
	{
		var _char = string_char_at(cur_btn, i);
		
		if (_char != " " && _char != "\n")
			current_word += _char;
		
		if (_char == " " || _char == "\n" || i == str_len)
		{
			var _word_width = string_length(current_word) * mono_spacing;
			
			if (max_width > 0 && ((cursor_x + _word_width) - text_x) > max_width)
			{
				if (cursor_x != text_x)
					is_multiline = true;
			}
			
			cursor_x = string_length(current_word) * mono_spacing;
			if (max_width > 0 && ((cursor_x + mono_spacing) - text_x) > max_width)
				is_multiline = true;
			
			current_word = "";
			
			if (_char == " ")
				cursor_x += mono_spacing;
			else if (_char == "\n")
				is_multiline = true;
		}
	}
	
	dmenu_box = is_multiline ? 1 : 0;
	dbutton_layout = 3;
}
