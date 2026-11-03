function dmenu_interact_recruits()
{
	dremove_false_history();

	if (dvertical_index != 0)
		dmenu_skip_reindexing = true;

	if (dvertical_index == 0)
		dmenu_state = "recruit_presets";
}

function dmenu_interact_recruits_presets()
{
	dremove_false_history();
	dmenu_skip_reindexing = true;
	
	var cmd = "recruitchap";
	var losemode = (dvertical_index == 1);

	if (dhorizontal_page == 0)
		cmd = (!losemode) ? "recruitall" : "loseall";

	else {
		cmd = (!losemode) ? "recruitchap" : "losechap";
		cmd += " " + string(dhorizontal_page);
	}

	dconsole_exec(cmd);
	dpop_history();
}
