function dmenu_dhinter_dsaves_options()
{
	var target_path = global.debug_selected_save_section;
	var found_desc = "No description available.";
	
	for (var i = 0; i < array_length(debug_save_sections); i++)
	{
		if (debug_save_sections[i] != target_path)
			continue;

		dhinter_text = debug_save_descriptions[i];
		break;
	}
}
