function dutils_strstarts_with(arg0, arg1, arg2=0)
{
	var str = arg0;
	var start = arg1;
	var offset = arg2;

	var str_len = string_length(str);
	var start_len = string_length(start);

	if (start_len > (str_len - offset))
		return (false);

	for (var i = 1; i <= start_len; i++) {
		var str_char = string_char_at(str, i + offset);
		var start_char = string_char_at(start, i);

		if (str_char != start_char)
			return (false);
	}
	return (true);
}

/*function dutils_strends_with(arg0, arg1, arg2=0)
{
	var str = arg0;
	var end = arg1;
	var offset = arg2;

	var str_len = string_lengh(str);
	var end_len = string_lengh(end);

	if (end_len > (str_len - offset))
		return (false);

	for (var i = 0; i < end_len; i++) {
		var str_char = string_char_at(str, 
		var end_char = string_char_at(end, i);

		if (str_char != end_char)
			return (false);
	}
	return (true);
}*/
