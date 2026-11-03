function dutils_isdigit(arg0, arg1=false)
{
	var char = arg0;
	var print_error = arg1;
	
	if (string_length(char) != 1) {
		if (print_error)
			scr_derror_print("Error: '" + char + "' isn't a digit because len isn't 1");
		return (false);
	}

	var res = (char >= "0" && char <= "9");
	if (!res && print_error)
		scr_derror_print("Error: '" + char + "' is an invalid digit");
	return (res);
}

function dutils_ischar(arg0, arg1=false)
{
	var char = arg0;
	var print_error = arg1;
	
	if (string_length(char) != 1) {
		if (print_error)
			scr_derror_print("Error: '" + char + "' isn't a char because len isn't 1");
		return (false);
	}

	var res = ((char >= "a" && char <= "z") || (char >= "A" && char <= "Z"));
	if (!res && print_error)
		scr_derror_print("Error: '" + char + "' is an invalid char");
	return (res);;
}

function dutils_isint(arg0, arg1=false, arg2=false)
{
	var str = arg0;
	var print_error = arg1;
	var is_uint = arg2;

	var str_len = string_length(str);
	if (str_len == 0)
		return (false);

	for (var i = 1; i <= str_len; i++) {
		var mychar = string_char_at(str, i);

		if (i == 1 && mychar == "-" && !is_uint)
			continue;

		if (dutils_isdigit(mychar))
			continue;

		if (print_error)
			scr_derror_print("Error: '" + str + "' isn't a integer because if '" + mychar + "'");
		return (false);
	}
	return (true);
}

function dutils_isuint(arg0, arg1)
{
	return (dutils_isint(arg0, arg1, true));
}

function dutils_isnum(arg0, arg1=false, arg2=false)
{
	var str = arg0;
	var print_error = arg1;
	var is_unsigned = arg2;
	
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

		if (dutils_isdigit(mychar))
			continue;

		if (print_error)
			scr_derror_print("Error: '" + str + "' isn't a number because of '" + mychar + "'");
		return (false);
	}
	return (true);
}

function dutils_isvar(arg0, arg1=false)
{
	var str = arg0;
	var print_error = arg1;

	var str_len = string_length(str);
	if (str_len == 0)
		return (false);

	for (var i = 1; i <= str_len; i++) {
		var mychar = string_char_at(str, i);

		if (dutils_ischar(mychar) || mychar == "_")
			continue;
		if (i > 1 && dutils_isdigit(mychar))
			continue;

		if (print_error)
			scr_derror_print("Error: '" + str + "' isn't a variable because of '" + mychar + "'");
		return (false);
	}
	return (true);
}

function dutils_istype(arg0, arg1, arg2)
{
	var variable = arg0;
	var type = arg1;
	var print_error = arg2;

	switch (type) {
		case "char":
			return (dutils_ischar(variable, print_error));

		case "digit":
			return (dutils_isdigit(variable, print_error));

		case "int":
			return (dutils_isint(variable, print_error));

		case "uint":
			return (dutils_isuint(variable, print_error));

		case "var":
			return (dutils_isvar(variable, print_error));

		case "num":
		case "real":
		case "number":
			return (dutils_isnum(variable, print_error));
	}
	return (false);
}
