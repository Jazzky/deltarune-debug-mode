function dutils_get_global_access_list(arg0)
{
	var global_str = arg0;

	var ipt_len = string_length(s_global);
	var access_list = [];
	var access_list_len = 0;

	var cur_word = 0;
	var bracket_balance = 0;
	for (var i = 1; i <= ipt_len; i++) {
		var mychar = string_char_at(s_global, i);

		if (mychar == "[") {
			bracket_balance++;
			if (access_list_len == 0) {
				access_list[access_list_len++] = cur_word;
				cur_word = "";
			}
		}
		else if (mychar == "]") {
			if (bracket_balance == 0) {
				scr_debug_print("Error: bracket parsing error");
				return (undefined);
			}
			bracket_balance--;
			access_list[access_list_len++] = cur_word;
			cur_word = "";
		}
		else
			cur_word += mychar;
	}

	if (bracket_balance == 0) {
		scr_debug_print("Error: bracket parsing error");
		return (undefined);
	}

	if (access_list_len == 0) {
		scr_debug_print("Error: no data for global extraction");
		return (undefined);
	}

	var global_name = access_list[0];
	if (!dutils_isvar(global_name)) {
		scr_debug_print("Error: '" + global_name + "' isn't a valid global name");
		return (undefined);
	}

	access_list[access_list_len] = undefined;
	return (access_list);
}
