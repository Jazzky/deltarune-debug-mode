function dmenu_save_history()
{
	dmenu_update_history("add");
	dmenu_reset_kb();
	
	dvertical_index = 0;
	dhorizontal_index = 0;
	dhorizontal_page = 0;
	dmenu_start_index = 0;
}

function dmenu_toggle_category(arg0=dvertical_index, arg1=undefined)
{
	var parent_y = arg0;
	var new_state = arg1;

	while (parent_y > 0) {
		if (dbuttons[parent_y].category == "category")
			break;
		parent_y--;
	}

	var cate_id = dbuttons[parent_y].category;
	var nb_collapsed = array_length(dcollapsed_categories);
	var collapsed_id = -1;

	for (var i = 0; i < nb_collapsed; i++) {
		if (dcollapsed_categories[i] != cate_id)
			continue;

		collapsed_id = i;
		break;
	}

	if (new_state == undefined)
		new_state = (collapsed_id != -1);

	var expand = (new_state == true);
	var collapse = !expand;

	if ((expand && collapsed_id == -1) || (collapse && collapsed_id != -1))
		exit;

	if (collapse)
		array_push(dcollapsed_categories, cate_id);
	else if (expand)
		array_delete(dcollapsed_categories, collapsed_id, 1);

	dvertical_index = parent_y;
}

function dmenu_confirm()
{
	var bt_type = cur_btn.type;
	switch (bt_type)
	{
		case "keyboard":
			dutils_toggle_kb(true);
			break;

		case "category":
			dmenu_toggle_category(dvertical_index)
			break;
	}

	dmenu_set_reindex(true);
	snd_play(snd_select);

	if (bt_type != undefined)
		exit;

	dmenu_popped_index = false;
	var old_state = dmenu_state;
	
	dmenu_state_interact();

	if (dmenu_state == old_state || dmenu_popped_index)
		exit;

	var new_state = dmenu_state;
	dmenu_state = old_state;

	dmenu_save_history();

	dmenu_state = new_state;
}
