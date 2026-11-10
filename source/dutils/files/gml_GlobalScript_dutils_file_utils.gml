function dutils_get_filepath(arg0)
{
	var basepath = arg0;
	if (basepath == undefined)
		return (undefined);

	var path_tries = [
		"./", working_dir + "/", working_dir + "/../"
	];

	var path;
	var nb_tries = array_length(path_tries);
	for (var i = 0; i < nb_tries; i++) {
		path = path_tries[i] + basepath;

		if (file_exists(path))
			break;
	}

	if (i == nb_tries)
		return (undefined);

	return (path);
}

function dutils_remove_file_extension(arg0)
{
	var filename = arg0;

	var name_len = string_length(filename);
	for (var i = name_len; i > 1; i--) {
		var mychar = string_char_at(filename, i);

		if (mychar == ".")
			break;
	}
	
	if (i == 1)
		return (filename);

	return (string_copy(filename, 1, i - 1));
}
