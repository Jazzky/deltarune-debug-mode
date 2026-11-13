function dutils_normalize_id(arg0)
{
	var str = arg0;

	str = string_lower(str);
	str = string_replace(str, " ", "");

	return (str);
}
