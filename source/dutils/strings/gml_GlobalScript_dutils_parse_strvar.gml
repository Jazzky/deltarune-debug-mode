function dutils_parse_strvar(arg0)
{
	var str = arg0;
	var str_len = string_length(str);

	if (str_len == 0)
		return ("");

	if (string_char_at(str, 1) == "\\")
		return (string_copy(str, 2, str_len - 1));

	if (str == "undefined")
		return (undefined);

	if (str == "NaN")
		return (NaN);

	if (str == "true")
		return (true);

	if (str == "false")
		return (false);

	if (dutils_isnum(str))
		return (real(str));

	return (str);
}
