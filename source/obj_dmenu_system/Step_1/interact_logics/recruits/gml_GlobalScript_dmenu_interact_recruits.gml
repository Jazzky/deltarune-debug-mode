function dmenu_interact_recruits()
{
	if (dvertical_index == 0)
		dmenu_state = "recruit_presets";
}

function dmenu_interact_recruits_presets()
{
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
