function dutils_get_global_access_list(arg0)
{
	var global_str = arg0;

	var ipt_len = string_length(global_str);
	var access_list = [];
	var access_list_len = 0;

	var cur_word = "";
	var bracket_balance = 0;
	for (var i = 1; i <= ipt_len; i++) {
		var mychar = string_char_at(global_str, i);
		var is_brack = (mychar == "[" || mychar == "]");

		if (mychar == "[") {
			bracket_balance++;
			if (access_list_len == 0) {
				access_list[access_list_len++] = cur_word;
				cur_word = "";
			}
		}
		else if (mychar == "]") {
			if (bracket_balance == 0) {
				scr_derror_print("Error: bracket parsing error");
				return (undefined);
			}
			bracket_balance--;
			access_list[access_list_len++] = cur_word;
			cur_word = "";
		}

		if (!is_brack) {
			cur_word += mychar;
			if (i == ipt_len && access_list_len == 0)
				access_list[access_list_len++] = cur_word;
		}
	}

	if (bracket_balance != 0) {
		scr_derror_print("Error: bracket parsing error");
		return (undefined);
	}

	if (access_list_len == 0) {
		scr_derror_print("Error: no data for global extraction");
		return (undefined);
	}

	var global_name = access_list[0];
	if (!dutils_isvar(global_name)) {
		scr_derror_print("Error: '" + global_name + "' isn't a valid global name");
		return (undefined);
	}

	access_list[access_list_len] = undefined;
	return (access_list);
}
