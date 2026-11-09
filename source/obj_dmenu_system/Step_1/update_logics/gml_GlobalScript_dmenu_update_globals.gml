function dmenu_update_globals()
{
	dmenu_title = dstr("Global changer", "Changeur de global");
	dbuttons = [];

	dmenu_box = 1;
	dbutton_layout = 1;
	reading_custom = dvertical_index == 0 && dutils_reading_kb();
	
	set_derror_print(false);
	for (var i = 0; i < array_length(dglobal_changer_options); i++)
	{
		name = dglobal_changer_options[i][0];
		limit = dglobal_changer_options[i][2];
		
		text = name;
		var global_value = "";

		if (i == 0 && reading_custom) {
			name = dkeyboard_texts[0];
			text = "global." + name;
		}

		else if (i > 0 && limit != -1) {
			var bt_index = 0;
			if (i == dvertical_index)
				bt_index = dhorizontal_index;

			name += "[" + string(bt_index) + "]";
			text = name;
		}


		if (i > 0 || reading_custom)
		{
			global_value = _dcmd_get_global_string(name);
			if (global_value == undefined)
				global_value = "";
		}

		if (dutils_reading_kb() && i == dvertical_index)
		{
			var _keyboard_text = dkeyboard_texts[reading_custom];
			if (_keyboard_text != "")
				global_value = _keyboard_text;
		}
		
		text += " = |" + string(global_value) + "|";
		var btlimit = [0, 0];
		if (limit != -1)
			btlimit = [0, limit - 1];

		array_push(dbuttons, dmenu_makebt(text, name, btlimit));
		dmenu_set_bttype(dbuttons[i], "keyboard");
	}
	set_derror_print(true);
}
