function dmenu_interact_recruits()
{
	if (btn_data == "preset")
		dmenu_state = "recruit_presets";
}

function dmenu_interact_recruits_presets()
{
	var cmd = "recruitchap";
	var losemode = (btn_data == "lose");

	if (dhorizontal_page == 0)
		cmd = (!losemode) ? "recruitall" : "loseall";

	else {
		cmd = (!losemode) ? "recruitchap" : "losechap";
		cmd += " " + string(dhorizontal_page);
	}

	dconsole_exec(cmd);
	dpop_history();
}
