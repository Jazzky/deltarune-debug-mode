function _dmenuback_get_dhinter_updater()
{
	var state = dmenu_state;

	switch (state)
	{
		case "warp_options":
			return (dmenu_dhinter_warp_options);

		case "debug_save":
			return (dmenu_dhinter_dsaves_main_menu);

		case "debug_save_options":
			return (dmenu_dhinter_dsaves_options);
	}

	state = dmenu_parent_state;
	switch (state)
	{
		case "items":
			return (dmenu_dhinter_items);
	}

	return (undefined);
}

function dmenuback_update_dhinter()
{
	var callfunc = _dmenuback_get_dhinter_updater();
	if (callfunc == undefined)
		exit;
	
	callfunc();
}
