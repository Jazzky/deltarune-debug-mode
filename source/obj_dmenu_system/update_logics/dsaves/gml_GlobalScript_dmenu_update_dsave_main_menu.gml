function dmenu_update_dsave_main_menu()
{
	dmenu_title = "Debug save";
	dbutton_options = [
			dstr("New save", "Nouvelle sauvegarde"),
			dstr("Search", "Recherche")
	];
	dbutton_indices = [-2, -2];
	var subs = [];
	
	if (global.dreading_custom_flag || dkeyboard_input != "")
		dbutton_options[1] = dstr("Contains: ", "Contient : ") + dkeyboard_input;
	else
		dbutton_options[1] = dstr("Search", "Recherche") + dkeyboard_input;
	
	for (var i = 0; i < array_length(debug_save_names); i++)
	{
		var s_chap = debug_save_chapters[i];
		
		if (s_chap != -1 && s_chap != global.chapter)
			continue;
		
		var s_name = debug_save_names[i];
		var s_cat = debug_save_categories[i];
		
		if (s_cat != "")
		{
			var cat_index = -1;
			
			for (var j = 0; j < array_length(dbutton_options); j++)
			{
				if (dbutton_options[j] == s_cat)
				{
					cat_index = j;
					break;
				}
			}
			
			if (cat_index == -1)
			{
				cat_index = array_length(dbutton_options);
				array_push(dbutton_options, s_cat);
				array_push(dbutton_indices, -1);
				subs[cat_index] = [];
				subs[cat_index + 1000] = [];
			}
			
			array_push(subs[cat_index], s_name);
			array_push(subs[cat_index + 1000], i);
		}
		else
		{
			array_push(dbutton_options, s_name);
			array_push(dbutton_indices, i);
		}
	}
	
	dmenu_process_submenus(subs, dkeyboard_input);
	dmenu_box = 1;
	dbutton_layout = 1;
}
