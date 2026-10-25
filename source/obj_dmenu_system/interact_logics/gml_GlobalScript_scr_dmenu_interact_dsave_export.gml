function scr_dmenu_interact_dsave_save()
{
	var target_path = global.debug_selected_save_section;
	var target_name = global.debug_selected_save_name;
	var cmd = "dsave_save \"" + target_path + "\"";

	global.debug_save_category = "";
	global.debug_save_name = target_name;
	global.debug_save_description = dstr("No description available.", "Aucune description disponible.");
	
	/*if (file_exists(target_path))
	{
		var file_id = file_text_open_read(target_path);
		var file_content = "";
		
		while (!file_text_eof(file_id))
		{
			file_content += file_text_read_string(file_id);
			file_text_readln(file_id);
		}
		
		file_text_close(file_id);
		
		try
		{
			var parsed_struct = json_parse(file_content);
			
			if (is_struct(parsed_struct) && variable_struct_exists(parsed_struct, "metadata"))
			{
				var meta = parsed_struct.metadata;
				
				if (variable_struct_exists(meta, "Category"))
					global.debug_save_category = meta.Category;
				
				if (variable_struct_exists(meta, "Description"))
					global.debug_save_description = meta.Description;
			}
		}
		catch (e)
		{
		}
	}*/
	//TODO add functions to easily get debug saves infos
	
	
	var cmd = "dsave_save \"" + target_name + "\"";
	global.debug_overwrite_section = target_path;
	scr_dmode_parse_cmd(cmd);

	dmenu_popup_launch = 0;
	dmenu_state = "debug";
	dbutton_options = dbutton_options_original;
	dmenu_state_history = [];
	dmenu_vertical_index_history = [];
	dvertical_index = 0;
	dbutton_layout = 0;
	dmenu_active = false;
	dkeyboard_input = "";
	global.interact = 0;
}

function scr_dmenu_interact_dsave_delete()
{
dremove_false_history();
	var target_path = global.debug_selected_save_section;
	
	var res = scr_dmode_parse_cmd("dsave_delete \"" + string(target_path) + "\"");
	if (res == 0)
		scr_get_debug_save_list();

	dpop_history();
	dvertical_index = 0;
	dbutton_layout = 0;
	dmenu_start_index = 0;
}

function scr_dmenu_interact_dsave_load()
{
	var target_path = global.debug_selected_save_section;
	var res = scr_dmode_parse_cmd("dsave_load \"" + string(target_path) + "\"");
	
	if (res == 0)
	{
		dmenu_popup_launch = 0;
		dmenu_state = "debug";
		dbutton_options = dbutton_options_original;
		dmenu_state_history = [];
		dmenu_vertical_index_history = [];
		dvertical_index = 0;
		dbutton_layout = 0;
		dmenu_active = false;
		dkeyboard_input = "";
		global.interact = 0;
	}
}

function scr_dmenu_interact_dsave_update_metadata()
{
	keyboard_string = "";
	dkeyboard_input = "";

	if (selected_name == "- " + dstr("Rename", "Renommer"))
		dmenu_state = "dsave_edit_name";

	else if (selected_name == "- " + dstr("Edit description", "Modifier description"))
		dmenu_state = "dsave_edit_desc";
	
	else if (selected_name == "- " + dstr("Change category", "Changer description"))
		dmenu_state = "dsave_edit_cat";
}

function scr_dmenu_interact_dsave_update_metadata_confirm()
{
	dremove_false_history();
	if (dvertical_index == 0)
	{
		dmenu_skip_reindexing = true;
		global.dreading_custom_flag = 1;
		keyboard_string = "";
		dkeyboard_input = "";
		dmenu_state_update();
		exit;
	}
	if (dvertical_index == 1 && dhorizontal_index == 0)
	{
		var target_path = global.debug_selected_save_section;
		var final_text = dkeyboard_input;
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
		var res = scr_dmode_parse_cmd(cmd);

		if (typeof(res) == "string")
			global.debug_selected_save_section = res;

		if (dmenu_state == "dsave_edit_name" && final_text != "")
			global.debug_selected_save_name = final_text;
	}
	dremove_false_history();
	global.dreading_custom_flag = 0;
	dkeyboard_input = "";
	dpop_history();
}
