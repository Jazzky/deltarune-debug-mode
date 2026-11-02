function dmenu_interact_dsave_export_dsave()
{
	dremove_false_history();
	dmenu_skip_reindexing = true;
	var cmd = "export_dsave --mode=debug \"" + global.debug_selected_save_section + "\"";
	dconsole_exec(cmd);
}

function dmenu_interact_dsave_export_normal()
{
	dremove_false_history();
	dmenu_skip_reindexing = true;
	var cmd = "export_dsave \"" + global.debug_selected_save_section + "\"";
	dconsole_exec(cmd);
}
