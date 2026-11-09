function dmenu_interact_warp_setup()
{
	drooms_options.target_room = -1;
	if (dvertical_index != 0)
		drooms_options.target_room = dbuttons[dvertical_index].data;
	
	drooms_options.target_plot = global.plot;
	drooms_options.target_is_darkzone = global.darkzone;
	drooms_options.target_member_2 = global.char[1];
	drooms_options.target_member_3 = global.char[2];
	dmenu_state = "warp_options";
}

function dmenu_interact_warp()
{
	if (btn_data == "cancel")
		dmenu_state = "warp";

	else if (btn_data == "darkworld")
		drooms_options.target_is_darkzone ^= 1;

	else if (btn_data == "warp")
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
		dconsole_exec(cmd);
	}
}
