function dmenu_interact_flag_categories()
{
	if (dvertical_index == 0)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		dutils_toggle_kb(true);
		dhorizontal_index = 0;
		keyboard_string = "";
		exit;
	}

	dother_options = [];
	var real_index = dbutton_indices[dvertical_index];
	
	for (var i = 0; i < array_length(dother_all_options); i++)
	{
		options = dother_all_options[i];
		
		if (options[0] == real_index)
			array_push(dother_options, options);
	}
	
	dmenu_skip_reindexing = true;
	dmenu_state = "flag_misc";
	dmenu_start_index = 0;
	dvertical_index = 0;
	dhorizontal_index = find_subarray_index(dother_options[0][2], dother_options[0][3]);
}

function dmenu_interact_flags()
{
	dremove_false_history();
	dmenu_skip_reindexing = true;
}
