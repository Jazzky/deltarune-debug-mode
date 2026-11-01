function dmenu_update_globals()
{
	dmenu_title = dstr("Global changer", "Changeur de global");
	dbutton_options = [];
	dmenu_box = 1;
	dbutton_layout = 1;
	reading_double_flag = dvertical_index == 0 && global.dreading_custom_flag;
	
	for (var i = 0; i < array_length(dglobal_changer_options); i++)
	{
		array_push(dbutton_indices, i);
		name = dglobal_changer_options[i][0];
		limit = dglobal_changer_options[i][2];
		
		if (i == 0 && reading_double_flag)
		{
			name = dcustom_flag_text[0];
			is_good = parse_var_str(name, 0);
			
			if (is_good)
			{
				name = dtemp_text;
				limit = dtemp_num;
			}
		}
		
		text = name;
		
		if (i == 0 && reading_double_flag)
			text = "global." + name;
		
		cur_global_value = "";
		var_exist = variable_global_exists(name);
		
		if (var_exist)
			cur_global_value = variable_global_get(name);
		
		if (limit != -1)
		{
			lookup_index = 0;
			
			if (i == dvertical_index && i == 0)
				lookup_index = limit;
			else if (i == dvertical_index)
				lookup_index = dhorizontal_index;
			
			text += ("[" + string(lookup_index) + "]");
			
			if (typeof(cur_global_value) != "array")
				cur_global_value = dstr("(Not an array)", "(Pas un tableau)");
			else if (lookup_index >= array_length(cur_global_value))
				cur_global_value = dstr("(Index too high)", "(Index trop élevé)");
			else
				cur_global_value = cur_global_value[lookup_index];
		}
		
		if (global.dreading_custom_flag && i == dvertical_index)
		{
			if (i != 0 || dcustom_flag_text[1] != "" || !var_exist)
				cur_global_value = dcustom_flag_text[reading_double_flag];
		}
		
		if (!(i == 0 && dvertical_index == 0 && !global.dreading_custom_flag))
			text += (" = |" + string(cur_global_value) + "|");
		
		array_push(dbutton_options, text);
	}
}
