function dconsole_fetch_function(arg0)
{
	var cmd = string(arg0);

	switch (cmd)
	{
		// WARPING COMMANDS
		case "warp":
			return (dcmd_warp);

		case "setteam":
		case "set_team":
			return (dcmd_setteam);


		// RECRUIT COMMANDS
		case "recruit":
			return (dcmd_recruit);

		case "recruitchap":
		case "recruit_chap":
			return (dcmd_recruit_chapter);

		case "recruitall":
		case "recruit_all":
			return (dcmd_recruit_all);

		case "lose":
			return (dcmd_lose);

		case "losechap":
		case "lose_chap":
			return (dcmd_lose_chapter);

		case "loseall":
		case "lose_all":
			return (dcmd_lose_all);


		// SETTERS COMMANDS
		case "setg":
		case "setglobal":
		case "set_global":
			return (dcmd_set_global);



		// ITEM COMMANDS
		case "gitem":
		case "giveitem":
		case "give_item":
			return (dcmd_give_item);

		case "garmor":
		case "givearmor":
		case "give_armor":
			return (dcmd_give_armor)

		case "gweapon":
		case "giveweapon":
		case "give_weapon":
			return (dcmd_give_weapon)

		case "gkitem":
		case "gkeyitem":
		case "givekeyitem":
		case "give_key_item":
			return (dcmd_give_key_item)


		// DEBUG SAVES COMMANDS
		case "loaddsave":
		case "load_dsave":
		case "dsave_load":
			return (dcmd_load_debug_save);

		case "deldsave":
		case "del_dsave":
		case "dsave_del":
		case "delete_dsave":
			return (dcmd_delete_debug_save);

		case "savedsave":
		case "save_dsave":
		case "dsave_save":
			return (dcmd_save_debug_save);

		case "dsave_export":
		case "export_dsave":
			return (dcmd_export_debug_save);

		case "update_dsave":
		case "dsave_update":
			return (dcmd_update_debug_save);
	}
	return (undefined);
}

function dconsole_exec(arg0)
{
	var cmd_str = arg0;

	var argv = dconsole_parse_cmd(cmd_str);
	var command;
	
	if (argv == [])
	{
		scr_debug_print("FIXME jsp");
		return (-1);
	}
	
	command = dconsole_fetch_function(argv[0]);
	if (command == undefined) {
		scr_derror_print("Error: unknown command '" + argv[0] + "'");
		return (1);
	}

	scr_debug_print("DEBUG: launching argv " + string(argv));
	var flags = dcmd_get_argv_flags(argv);
	argv = dcmd_remove_argv_flags(argv);

	var res = command(array_length(argv), argv, flags);
	return (res);
}

function dconsole_parse_cmd(arg0)
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
