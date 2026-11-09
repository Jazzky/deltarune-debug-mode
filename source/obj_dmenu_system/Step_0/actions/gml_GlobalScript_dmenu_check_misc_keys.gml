function dmenu_check_misc_keys()
{
	var callfunc = undefined;

	switch (dmenu_state)
	{
		case "debug":
			callfunc = dmenu_action_main_menu_keys;
			break;

		case "debug_save":
			callfunc = dmenu_action_dsaves_keys;
			break;
	}

	if (callfunc == undefined)
		exit;

	callfunc();
}
