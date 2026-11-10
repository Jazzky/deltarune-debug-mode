function dutils_read_file(arg0)
{
	var basepath = arg0;
	var path = dutils_get_filepath(basepath);
	if (path == undefined)
		return (undefined);

	var file = file_text_open_read(path);
	var file_content = "";
	while (!file_text_eof(file_id))
	{
		file_content += file_text_readln(file);
	}

	file_text_close(file);
	return (file_content);
}

function dutils_write_file(arg0, arg1)
{
	var filepath = arg0;
	var content = arg1;

	var file = file_text_open_write(filepath);
	file_text_write_string(content);
	file_text_close(file);
}
