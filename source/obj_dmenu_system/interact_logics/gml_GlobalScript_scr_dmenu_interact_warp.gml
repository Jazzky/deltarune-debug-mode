function scr_dmenu_interact_warp_setup()
{
	if (dvertical_index == 1)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		global.dreading_custom_flag = 1;
		keyboard_string = "";
		dkeyboard_input = "";
		dmenu_state_update();
	}
	else
	{
		drooms_options.target_room = -1;
		
		if (dvertical_index != 0)
			drooms_options.target_room = dbutton_indices[dvertical_index];
		
		drooms_options.target_plot = global.plot;
		drooms_options.target_is_darkzone = global.darkzone;
		drooms_options.target_member_2 = global.char[1];
		drooms_options.target_member_3 = global.char[2];
		dmenu_state = "warp_options";
		dkeyboard_input = "";
	}
}

function scr_dmenu_interact_warp()
{
	if (dvertical_index == 0)
	{
		dkeyboard_input = "";
		dmenu_state = "warp";
	}
	else if (dvertical_index == 1)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		drooms_options.target_is_darkzone ^= 1;
	}
	else if (dvertical_index >= 2 && dvertical_index <= 4)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		
		if (dvertical_index == 2)
		{
			global.dreading_custom_flag = 1;
			keyboard_string = "";
		}
	}
	else if (dvertical_index == 5)
	{
		new_room = drooms_options.target_room;
		
		var cmd = "warp " + string(new_room);
		cmd += " " + string(drooms_options.target_member_2);
		cmd += " " + string(drooms_options.target_member_3);
		cmd += " --plot=" + string(drooms_options.target_plot);

		if (drooms_options.target_is_darkzone)
			cmd += " --dw";
		else
			cmd += " --lw";

		global.interact = 0;
		dmenu_active = false;
		scr_dmode_parse_cmd(cmd);
	}
}
