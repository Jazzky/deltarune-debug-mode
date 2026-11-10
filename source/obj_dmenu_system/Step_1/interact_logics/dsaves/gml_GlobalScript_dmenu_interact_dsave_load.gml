function dmenu_interact_dsave_load_menu()
{
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
