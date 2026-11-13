function dmenu_update_dw_items()
{
	var select_range = dmenu_get_item_index_data(ditem_chap, dmenu_state);

	dbuttons = [
		dmenu_makebt(dstr("Chapter: ", "Chapitre : ") + string(ditem_chap))
	];

	var max_len = 33;
	var range_len = array_length(select_range)
	for (var r = 0; r < range_len; r++)
	{
		var my_start = select_range[r].start_id;
		var my_count = select_range[r].count;
	
		for (var i = my_start; i < (my_start + my_count); i++)
		{
			var itemname = dutils_get_itemname(i, dmenu_state);
			var combined = string_replace_all(itemname, "#", " ");
			
			if (string_length(combined) > max_len)
				combined = string_copy(combined, 1, max_len - 3) + "...";
			
			array_push(dbuttons, dmenu_makebt(combined, i));
		}
	}
}

function dmenu_update_lw_items(arg0)
{
	var dlight_lst;
	var cur_selected;
	var is_item = (dmenu_state == "items");

	switch (dmenu_state) {
		case "items":
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

	dbuttons = [];
	var dlight_lst_len = array_length(dlight_lst);
	for (var i = 0; i < dlight_lst_len; i++)
	{
		var item_id = dlight_lst[i][0];
		var combined = dlight_lst[i][1];
		
		if (!is_item && cur_selected == item_id)
			combined += " (" + dstr("Equipped", "Équipé") + ")";
		else if (is_item) {
			var _owned = dutils_get_itemcount(item_id, "litem");
			combined += " - " + string(_owned) + " " + dstr("held", "possédé(s)");
		}
		
		array_push(dbuttons, dmenu_makebt(combined, item_id));
	}
}

function dmenu_update_items()
{
	dmenu_parent_state = "items";
	switch (dmenu_state)
	{
		case "items":
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

	if (dhorizontal_page == 0) {
		dmenu_update_dw_items();
	}
	else {
		dmenu_update_lw_items();
	}

	dmenu_box = 2;
	dbutton_layout = 1;
}
