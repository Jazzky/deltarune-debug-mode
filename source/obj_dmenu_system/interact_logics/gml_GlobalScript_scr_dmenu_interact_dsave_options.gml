function scr_dmenu_interact_dsave_export_dsave()
{
	dremove_false_history();
	dmenu_skip_reindexing = true;
	var cmd = "export_dsave --mode=debug \"" + global.debug_selected_save_section + "\"";
	scr_dmode_parse_cmd(cmd);
}

function scr_dmenu_interact_dsave_export_normal()
{
	dremove_false_history();
	dmenu_skip_reindexing = true;
	var cmd = "export_dsave \"" + global.debug_selected_save_section + "\"";
	scr_dmode_parse_cmd(cmd);
}
