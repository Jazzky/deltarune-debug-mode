function scr_dmode_parse_cmd(arg0)
{
	var cmd_str = arg0;

	var argv = scr_parse_cmd_str(cmd_str);
	var command;
	
	if (argv == [])
	{
		scr_debug_print("FIXME jsp");
		return (-1);
	}
	switch (argv[0])
	{
		case "setteam":
		case "set_team":
			command = scr_dmode_cmd_setteam;
			break;

		case "warp":
			command = scr_dmode_cmd_warp;
			break;

		case "delete_save":
		case "dsave_delete":
			command = scr_dmode_cmd_delete_debug_save;
			break;

		case "save_dsave":
		case "dsave_save":
			command = scr_dmode_cmd_save_debug_save;
			break;

		case "load_save":
		case "dsave_load":
			command = scr_dmode_cmd_load_debug_save;
			break;

		case "update_save":
		case "dsave_update":
			command = scr_dmode_cmd_update_debug_save;
			break;

		case "export_dsave":
		case "dsave_export":
			command = scr_dmode_cmd_export_debug_save;
			break;

		default:
			scr_debug_print(dstr("Error: Invalid command", "Erreur : Commande invalide"));
			return (-1);
	}
	scr_debug_print("DEBUG: launching argv " + string(argv));
	return (command(array_length(argv), argv));
}

function scr_parse_cmd_str(arg0)
{
	var cmd_str = arg0;
	var cmd_len = string_length(cmd_str) + 1;

	var argv = [];
	var argv_index = 0;

	var cur_arg = "";
	var arg_start_index = 1;

	var cur_quote = "";

	scr_debug_print("Starting parsing for " + string(cmd_str));
	for (var i = arg_start_index; i < cmd_len; i++)
	{
		var char = string_char_at(cmd_str, i);
		
		if (char == " " && cur_quote == "")
		{
			scr_debug_print("Adding at argv[" + string(argv_index) + "] = " + cur_arg);
			argv[argv_index++] = cur_arg;
			while (char == " " && ++i < cmd_len)
				char = string_char_at(cmd_str, i);

			i--;
			arg_start_index = i;
			cur_arg = "";
		}
		else if (char == "\"")
		{
			if (i != 1 && string_char_at(cmd_str, i - 1) == "\\")
				cur_arg += "\"";
			else if (cur_quote == char)
				cur_quote = "";
			else
				cur_quote = char;
		}
		else if (char != "\\")
		{
			cur_arg += char;
		}
	}
	if (cur_quote != "")
	{
		scr_debug_print("Error: quotes not closed during command parsing (got " + cur_quote + ")");
		return (argv);
	}

	scr_debug_print("Adding at argv[" + string(argv_index) + "] = " + cur_arg);
	if (string_char_at(cmd_str, string_length(cmd_str)) != " ")
		argv[argv_index] = cur_arg;

	return (argv);
}
