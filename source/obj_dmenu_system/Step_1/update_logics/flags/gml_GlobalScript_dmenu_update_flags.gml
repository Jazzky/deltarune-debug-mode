function dmenu_update_flag_categories()
{
	dmenu_title = dstr("Flags");
	dbuttons = [
		dmenu_makebt(dstr("Custom"))
	];

	categories_len = array_length(dother_categories);
	var max_len = 40;
	
	if (dutils_reading_kb())
		dbuttons[0].text = ("global.flag[" + dkeyboard_texts[0] + "] = |" + dkeyboard_texts[1] + "|");
	
	for (var i = 0; i < categories_len; i++)
	{
		if (dflag_categories_len[i] == 0)
			continue;
		
		array_push(dbuttons, dmenu_makebt(dother_categories[i], i));
	}
	
	dmenu_box = 1;
	dbutton_layout = 1;
}

function dmenu_update_flag()
{
	dmenu_title = dstr("Flags");
	dbuttons = [];

	other_len = array_length(dother_options);
	var max_len = 40;
	
	for (var i = 0; i < other_len; i++)
	{
		var cur_option = dother_options[i];
		var flag_number = global.flag[cur_option[2]];
		var nb_options = array_length(cur_option[3]);

		var combined = cur_option[1] + " - " + dstr("problem lol", "problème lol");
		option_index = find_subarray_index(cur_option[2], cur_option[3]);
		
		combined = cur_option[1] + " -  " + cur_option[3][option_index][0];
		
		if (string_length(combined) > max_len)
			combined = string_copy(combined, 1, max_len - 3) + "...";
		
		array_push(dbuttons, dmenu_makebt(combined, i, nb_options));
	}
	
	dmenu_box = 2;
	dbutton_layout = 1;
}
