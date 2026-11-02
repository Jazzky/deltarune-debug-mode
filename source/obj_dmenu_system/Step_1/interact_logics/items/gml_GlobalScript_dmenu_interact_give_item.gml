function scr_dmenu_interact_set_itemgiver_type()
{
	if (dhorizontal_index == 0)
		dmenu_state = "objects";
	else if (dhorizontal_index == 1)
		dmenu_state = "armors";
	else if (dhorizontal_index == 2)
		dmenu_state = "weapons";
	else if (dhorizontal_index == 3)
		dmenu_state = "keyitems";
	
	dhorizontal_page = !global.darkzone;
	
	if (dmenu_state == "keyitems")
		dhorizontal_page = 0;
	
	dvertical_index = 0;
	dhorizontal_index = 0;
}

function scr_dmenu_interact_setup_givertab()
{
	dgiver_infos.item_type = dmenu_state;
	dgiver_infos.item_id = dbutton_indices[dvertical_index];
	dgiver_infos.item_name = _dmenu_back_get_desctext(dmenu_state, dgiver_infos.item_id);
	
	if (dhorizontal_page == 0 && dvertical_index == 0)
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		ditem_chap += 1;
		
		if (ditem_chap > global.chapter)
			ditem_chap = 1;
		exit;
	}
	if (dhorizontal_page == 1 && (dmenu_state == "armors" || dmenu_state == "weapons"))
	{
		dremove_false_history();
		dmenu_skip_reindexing = true;
		if (dmenu_state == "armors")
			global.larmor = dlight_armors[dvertical_index][0];
		else
			global.lweapon = dlight_weapons[dvertical_index][0];
		exit; //TODO create dcmd for light world
	}
	dmenu_state = "givertab";
	dvertical_index = 0;
}
