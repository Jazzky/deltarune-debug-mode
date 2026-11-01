function dutils_isdigit(arg0)
{
	var char = arg0;
	
	if (string_length(char) != 1)
		return (false);
	return (char >= "0" && char <= "9");
}

function dutils_ischar(arg0)
{
	var char = arg0;
	
	if (string_length(char) != 1)
		return (false);
	return ((char >= "a" && char <= "z") || (char >= "A" && char <= "Z"));
}

function dutils_isint(arg0, arg1=false)
{
	var str = arg0;
	var is_uint = arg1;

	var str_len = string_length(str);
	if (str_len == 0)
		return (false);

	for (var i = 1; i <= str_len; i++) {
		var mychar = string_char_at(str, i);

		if (i == 1 && mychar == "-" && !is_uint)
			continue;

		if (!dutils_isdigit(mychar))
			return (false);
	}
	return (true);
}

function dutils_isuint(arg0)
{
	return (dutils_isint(arg0, true));
}

function dutils_isnum(arg0, arg1=false)
{
	var str = arg0;
	var is_unsigned = arg1;
	
	var str_len = string_length(str);
	if (str_len == 0)
		return (false);

	var saw_dot = false;
	for (var i = 1; i <= str_len; i++) {
		var mychar = string_char_at(str, i);

		if (i == 1 && mychar == "-" && !is_unsigned)
			continue;

		if (mychar == "." && !saw_dot) {
			saw_dot = true;
			continue;
		}

		if (!dutils_isdigit(mychar))
			return (false);
	}
	return (true);
}

function dutils_isvar(arg0)
{
	var str = arg0;

	var str_len = string_length(str);
	if (str_len == 0)
		return (false);

	for (var i = 1; i <= str_len; i++) {
		var mychar = string_char_at(str, i);

		if (dutils_ischar(mychar) || mychar == "_")
			continue;
		if (i > 1 && dutils_isdigit(mychar))
			continue;

		return (false);
	}
	return (true);
}

function dutils_istype(arg0, arg1)
{
	var variable = arg0;
	var type = arg1;

	switch (type) {
		case "char":
			return (dutils_ischar(variable));

		case "digit":
			return (dutils_isdigit(variable));

		case "int":
			return (dutils_isint(variable));

		case "uint":
			return (dutils_isuint(variable));

		case "var":
			return (dutils_isvar(variable));
	}
	return (false);
}
