function dmenu_interact_dsave_export_dsave()
{
	if (dvertical_index == 1 && dhorizontal_index == 0) {
		var cmd = "export_dsave --mode=debug \"" + dload_options.target_path + "\"";
		dconsole_exec(cmd);
	}

	dpop_history();
}

function dmenu_interact_dsave_export_normal()
{
	if (dvertical_index == 1 && dhorizontal_index == 0) {
		var cmd = "export_dsave \"" + dload_options.target_path + "\"";
		dconsole_exec(cmd);
	}

	dpop_history();
}
