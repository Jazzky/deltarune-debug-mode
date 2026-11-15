function dmenu_state_interact_givertab()
{
	var real_index = dgiver_infos.item_id;
	var item_name = dgiver_infos.item_name;
	var item_type = dgiver_infos.item_type;
	var quantity = string(dhorizontal_index);

	var cmd = "gitem " + item_type + " \"" + item_name + "\" " + quantity;
	dconsole_exec(cmd);

	dpop_history();
	dmenu_active = false;
	global.interact = 0;
}
