function dmenu_save_history()
{
	dmenu_update_history("add");
	dmenu_reset_kb();
	
	dvertical_index = 0;
	dhorizontal_index = 0;
	dhorizontal_page = 0;
	dmenu_start_index = 0;
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
	dmenu_state_update();
}
