function dutils_boxbound_string(arg0, arg1=-1)
{
	var str = arg0;
	var max_width = arg1;

	if (max_width <= 0)
		max_width = 9999999;

	var ret_str = "";
	var line_len = 0;

	var cur_word = "";
	var word_len = 0;

	var str_len = string_length(str);
	for (var i = 1; i <= str_len; i++) {
		var mychar = string_char_at(str, i);

		var is_sep = (mychar == " " || mychar == "\n");
		if (!is_sep) {
			cur_word += mychar;
			word_len++;
		}

		if (is_sep || i == str_len) {
			if (line_len != 0 && (word_len + line_len) > max_width) {
				ret_str += "\n";
				line_len = 0;
			}

			for (var j = 1; j <= word_len; j++) {
				var c = string_char_at(cur_word, j);

				if (line_len == max_width) {
					ret_str += "\n";
					line_len = 0;
				}
				ret_str += c;
				line_len++;
			}
			cur_word = "";
			word_len = 0;

			if (is_sep)
				ret_str += mychar;

			line_len++;
			if (mychar == "\n")
				line_len = 0;
		}
	}
	return (ret_str);
}
