function dmenu_state_interact_dsave_load_menu()
{
	if (btn_data == "save")
		dmenu_state_interact_dsave_save();

	else if (btn_data == "load")
		dmenu_state_interact_dsave_load();

	else if (btn_data == "delete")
		dmenu_state_interact_dsave_delete();

	else if (btn_data == "export_debug")
		dmenu_state_interact_dsave_export_dsave();

	else if (btn_data == "export_vanilla")
		dmenu_state_interact_dsave_export_normal();

	else
		dmenu_state_interact_dsave_update_metadata();
}
