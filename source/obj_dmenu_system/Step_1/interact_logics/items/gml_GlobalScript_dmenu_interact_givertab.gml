function dmenu_interact_givertab()
{
	var real_index = dgiver_infos.item_id;
	var item_name = dgiver_infos.item_name;
	var item_type = dgiver_infos.item_type;
	var quantity = string(dhorizontal_index);

	if (dhorizontal_page == 0)
	{
		var cmd = "gitem " + item_type + " \"" + item_name + "\" " + quantity;
		dconsole_exec(cmd);
	}
	else
	{
		scr_debug_print("TODO");
		//dmenu_interact_givertab_lw(item_type, real_index, dhorizontal_index);
	}

	dpop_history();
	dmenu_active = false;
	global.interact = 0;
}
