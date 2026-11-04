function dmenu_interact_set_itemgiver_type()
{
	dmenu_state = cur_btn.data;

	dhorizontal_page = !global.darkzone;
	
	if (dmenu_state == "keyitems")
		dhorizontal_page = 0;
	
	dvertical_index = 0;
	dhorizontal_index = 0;
}

function dmenu_setup_dgiver_infos()
{
	var item_type = dmenu_state;
	var item_id = dbuttons[dvertical_index].data;

	switch (dgiver_infos.item_type)
	{
		case "items":
			scr_itemcheck(item_id);
			break;

		case "armors":
			scr_armorcheck_inventory(item_id);
			break;

		case "weapons":
			scr_weaponcheck_inventory(item_id);
			break;

		case "keyitems":
			scr_keyitemcheck(item_id);
			break;
	}

	dgiver_infos.item_type = item_type
	dgiver_infos.item_id = item_id;
	dgiver_infos.item_name = dutils_get_itemname(item_id, item_type);
	dgiver_infos.owned_amt = dutils_get_itemcount(item_id, item_type);
	dgiver_infos.storage_space = dutils_get_storage_left(item_type);
}

function dmenu_interact_setup_givertab()
{
	dmenu_setup_dgiver_infos();
	
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
