function dmenu_interact_dsave_export_dsave()
{
	var cmd = "export_dsave --mode=debug \"" + global.debug_selected_save_section + "\"";
	dconsole_exec(cmd);
}

function dmenu_interact_dsave_export_normal()
{
	var cmd = "export_dsave \"" + global.debug_selected_save_section + "\"";
	dconsole_exec(cmd);
}
