function dmenu_update_globals()
{
	dmenu_title = dstr("Global changer", "Changeur de global");
	dbuttons = [];

	dmenu_box = 1;
	dbutton_layout = 1;
	reading_double_flag = dvertical_index == 0 && dutils_reading_kb();
	
	set_derror_print(false);
	for (var i = 0; i < array_length(dglobal_changer_options); i++)
	{
		name = dglobal_changer_options[i][0];
		limit = dglobal_changer_options[i][2];
		
		text = name;
		var global_value = "";

		if (i > 0 || reading_double_flag)
		{
			if (i == 0) {
				name = dkeyboard_texts[0];
				text = "global." + name;
			}

			global_value = _dcmd_get_global_string(name);
			if (global_value == undefined)
				global_value = "";
		}

		if (dutils_reading_kb() && i == dvertical_index)
		{
			var _keyboard_text = dkeyboard_texts[reading_double_flag];
			if (_keyboard_text != "")
				global_value = _keyboard_text;
		}
		
		text += (" = |" + string(global_value) + "|");
		array_push(dbuttons, dmenu_makebt(text, i));
	}
	dmenu_set_bttype(dbuttons[0], "keyboard");
	set_derror_print(true);
}
