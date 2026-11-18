function dmenu_draw_state_specific()
{
	var callfunc = undefined;

	switch (dmenu_state)
	{
		case "debug":
			callfunc = dmenu_draw_main_menu_specific;
			break;

		case "recruits":
			callfunc = dmenu_draw_recruits_specific;
			break;
	}
	
	if (dmenu_parent_state == "items")
		callfunc = dmenu_draw_items_specific;

	if (callfunc == undefined)
		exit;

	callfunc();
}
