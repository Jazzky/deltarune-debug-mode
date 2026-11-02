function dmenu_update_dw_items(arg0)
{
	var _dmenu_state = arg0;
	var select_range = dmenu_get_item_index_data(ditem_chap, _dmenu_state);

	var max_len = 33;
	var range_len = array_length(select_range)
	for (var r = 0; r < range_len; r++)
	{
		var my_start = select_range[r].start_id;
		var my_count = select_range[r].count;
	
		for (var i = my_start; i < (my_start + my_count); i++)
		{
			var itemname = _dmenu_back_get_itemname(dmenu_state, i);
			var combined = string_replace_all(itemname, "#", " ");
			
			if (string_length(combined) > max_len)
				combined = string_copy(combined, 1, max_len - 3) + "...";
			
			array_push(dbutton_options, combined);
			array_push(dbutton_indices, i);
		}
	}
}

function dmenu_update_lw_items(arg0)
{
	var _dmenu_state = arg0;

	var dlight_lst;
	var cur_selected;
	var is_item = (_dmenu_state == "objects");

	switch (_dmenu_state) {
		case "objects":
			dlight_lst = dlight_objects;
			break;

		case "armors":
			dlight_lst = dlight_armors;
			cur_selected = global.larmor;
			break;

		case "weapons":
			dlight_lst = dlight_weapons;
			cur_selected = global.lweapon;
			break;
	}

	var dlight_lst_len = array_delete(dlight_lst);
	array_delete(dbutton_options, 0, 1);
	array_delete(dbutton_indices, 0, 1);
	for (var i = 0; i < dlight_lst_len; i++)
	{
		var item_id = dlight_lst[i][0];
		var combined = dlight_lst[i][1];
		
		if (!is_item && cur_selected == item_id)
			combined += " (" + dstr("Equipped", "Équipé") + ")";
		else if (is_item) {
			scr_litemcheck(item_id);
			combined += " - " + string(itemcount) + " " + dstr("held", "possédé(s)");
		}
		
		array_push(dbutton_options, combined);
		array_push(dbutton_indices, item_id);
	}
}

function dmenu_update_items()
{
	var is_weapon = (dmenu_state == "weapons")

	switch (dmenu_state)
	{
		case "objects":
            dmenu_title = dstr("Item List", "Liste d'objets");
			break;

		case "armors":
			dmenu_title = dstr("Armor List", "Liste d'armures");
			break;

		case "weapons":
			dmenu_title = dstr("Weapon List", "Liste d'armes");
			break;

		case "keyitems":
            dmenu_title = dstr("Key Item List", "Liste d'objets clés");
			break;
	}

	dbutton_options = [dstr("Chapter: ", "Chapitre : ")];
	dbutton_indices = [-1];
	dbutton_options[0] += string(ditem_chap);

	if (dhorizontal_page == 0)
		dmenu_update_dw_items(dmenu_state);
	else
		dmenu_update_lw_items(dmenu_state);

	dmenu_box = 2;
	dbutton_layout = 1;
}

function _dmenu_back_get_desctext(arg0, arg1)
{
	var item_category = arg0;
	var item_id = arg1;

	var res = "";
	switch (item_category) {
		case "objects":
			scr_iteminfo(item_id);
			res = itemnameb;
			break;

		case "armors":
			scr_armorinfo(item_id);
			res = armornametemp;
			break;

		case "weapons":
			scr_weaponinfo(item_id);
			res = weaponnametemp;
			break;

		case "keyitems":
			scr_keyiteminfo(item_id);
			res = tempkeyitemname;
			break;
	}
	return (res);
}
