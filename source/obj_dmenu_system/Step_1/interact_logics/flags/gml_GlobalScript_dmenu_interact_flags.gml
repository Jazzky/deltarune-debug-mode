function dmenu_interact_flag_categories()
{
	dother_options = [];
	var real_index = dbuttons[dvertical_index].data;
	
	for (var i = 0; i < array_length(dother_all_options); i++)
	{
		options = dother_all_options[i];
		
		if (options[0] == real_index)
			array_push(dother_options, options);
	}
	
	dmenu_state = "flag_misc";
}

function dmenu_interact_flags()
{
	exit;
}
