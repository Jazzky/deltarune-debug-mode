function dmenu_interact_dsave_export_dsave()
{
	var cmd = "export_dsave --mode=debug \"" + dload_options.target_path + "\"";
	dconsole_exec(cmd);
}

function dmenu_interact_dsave_export_normal()
{
	var cmd = "export_dsave \"" + dload_options.target_path + "\"";
	dconsole_exec(cmd);
}
