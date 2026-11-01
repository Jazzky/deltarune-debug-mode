function dmenu_update_flag_categories()
{
	dmenu_title = dstr("Flags");
	dbutton_options = [];
	dbutton_indices = [-1];
	categories_len = array_length(dother_categories);
	var max_len = 40;
	
	if (!global.dreading_custom_flag)
		array_push(dbutton_options, dstr("Custom"));
	else
		array_push(dbutton_options, "global.flag[" + dcustom_flag_text[0] + "] = |" + dcustom_flag_text[1] + "|");
	
	for (var i = 0; i < categories_len; i++)
	{
		if (dflag_categories_len[i] == 0)
			continue;
		
		array_push(dbutton_options, dother_categories[i]);
		array_push(dbutton_indices, i);
	}
	
	dmenu_box = 1;
	dbutton_layout = 1;
}

function dmenu_update_flag()
{
	dmenu_title = dstr("Flags");
	dbutton_options = [];
	dbutton_indices = [];
	other_len = array_length(dother_options);
	var max_len = 40;
	
	for (var i = 0; i < other_len; i++)
	{
		cur_option = dother_options[i];
		flag_number = global.flag[cur_option[2]];
		var combined = cur_option[1] + " - " + dstr("problem lol", "problème lol");
		
		if (i == dvertical_index)
			option_index = dhorizontal_index;
		else
			option_index = find_subarray_index(cur_option[2], cur_option[3]);
		
		combined = cur_option[1] + " -  " + cur_option[3][option_index][0];
		
		if (string_length(combined) > max_len)
			combined = string_copy(combined, 1, max_len - 3) + "...";
		
		array_push(dbutton_options, combined);
		array_push(dbutton_indices, i);
	}
	
	dmenu_box = 2;
	dbutton_layout = 1;
}
