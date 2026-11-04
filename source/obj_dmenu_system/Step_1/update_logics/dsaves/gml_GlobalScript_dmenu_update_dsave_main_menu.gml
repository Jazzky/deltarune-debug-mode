function dmenu_update_dsave_main_menu()
{
	dmenu_title = "Debug save";
	dbuttons = [
		dmenu_makebt(dstr("New save", "Nouvelle sauvegarde"), -2),
		dmenu_makebt(dstr("Search", "Recherche"), -2)
	];

	var subs = [];
	var save_substr = dkeyboard_texts[0];
	if (dutils_reading_kb() || save_substr != "")
		dbuttons[1].text = dstr("Contains: ", "Contient : ") + save_substr;
	
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
			
			for (var j = 0; j < array_length(dbuttons); j++)
			{
				if (dbuttons[j].text == s_cat)
				{
					cat_index = j;
					break;
				}
			}
			
			if (cat_index == -1)
			{
				cat_index = array_length(dbuttons);
				array_push(dbuttons, dmenu_makebt(s_cat));
				subs[cat_index] = [];
				subs[cat_index + 1000] = [];
			}
			
			array_push(subs[cat_index], s_name);
			array_push(subs[cat_index + 1000], i);
		}
		else
			array_push(dbuttons, dmenu_makebt(s_name, i));
	}
	
	dmenu_dsave_process_submenus(subs, save_substr);
	dmenu_box = 1;
	dbutton_layout = 1;
}
