function dmenu_interact_dsave_save()
{
	var target_path = dload_options.target_path;
	var cmd = "dsave_save \"" + target_path + "\"";

	dconsole_exec(cmd);
	dmenu_reset_menu();
}

function dmenu_interact_dsave_delete()
{
	var target_path = dload_options.target_path;
	
	var cmd = "dsave_delete \"" + string(target_path) + "\"";
	var res = dconsole_exec(cmd);

	dpop_history();
	dvertical_index = 0;
	dbutton_layout = 0;
	dmenu_start_index = 0;
}

function dmenu_interact_dsave_load()
{
	var target_path = dload_options.target_path;
	var res = dconsole_exec("dsave_load \"" + string(target_path) + "\"");
	
	if (res == 0)
		dmenu_reset_menu();
}

function dmenu_interact_dsave_update_metadata()
{
	if (btn_data == "rename")
		dmenu_state = "dsave_edit_name";

	else if (btn_data == "desc")
		dmenu_state = "dsave_edit_desc";
	
	else if (btn_data == "cate")
		dmenu_state = "dsave_edit_cat";
}

function dmenu_interact_dsave_update_metadata_confirm()
{
	if (!(dvertical_index == 1 && dhorizontal_index == 0)) {
		dpop_history();
		exit;
	}

	var target_path = dload_options.target_path;
	var final_text = dkeyboard_texts[0];
	var cmd_arg = "";
	var ini_key = "";
	
	if (dmenu_state == "dsave_edit_name")
		cmd_arg = "savename";
	else if (dmenu_state == "dsave_edit_desc")
		cmd_arg = "description";
	else if (dmenu_state == "dsave_edit_cat")
		cmd_arg = "category";

	cmd_arg = "--" + cmd_arg + "=\"" + final_text + "\"";
	var cmd = "dsave_update \"" + string(target_path) + "\" " + cmd_arg;
	var res = dconsole_exec(cmd);

	if (typeof(res) == "string")
		global.debug_selected_save_section = res;

	if (dmenu_state == "dsave_edit_name" && final_text != "")
		global.debug_selected_save_name = final_text;

	dpop_history();
}
