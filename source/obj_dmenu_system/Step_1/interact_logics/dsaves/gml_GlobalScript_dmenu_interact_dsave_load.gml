function dmenu_interact_dsave_load()
{
	var check_name = selected_name;
	if (dmenu_dsave_interact_submenus(check_name))
		exit;

	var target_sec = global.debug_selected_save_section;
	var target_name = global.debug_selected_save_name;
	
	if (btn_data == "save")
		dmenu_interact_dsave_save();

	else if (btn_data == "load")
		dmenu_interact_dsave_load();

	else if (btn_data == "delete")
		dmenu_interact_dsave_delete();

	else if (btn_data == "export_debug")
		dmenu_interact_dsave_export_dsave();

	else if (btn_data == "export_vanilla")
		dmenu_interact_dsave_export_normal();

	else
		dmenu_interact_dsave_update_metadata();
}
