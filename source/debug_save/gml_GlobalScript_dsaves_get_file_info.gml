function _dsaves_fetch_json_info(arg0, arg1, arg2)
{
	var _json = arg0;
	var _field = arg1;
	var default_value = arg2;

	if (_json == undefined)
		return (default_value);

	if (!variable_struct_exists(_json, _field))
		return (default_value);

	return (variable_struct_get(_json, _field));	
}

function dsaves_get_file_info(arg0=undefined)
{
	var path = arg0;

	var _path_content = dutils_read_file(path);
	var _metadata = undefined;
	if (_path_content != undefined) {
		var _content = json_parse(_path_content);
		var _metadata = _content.metadata;
	}

	var filename = filename_name(path);
	var filepath = filename_path(path);
	var res_json =
	{
		metadata:
		{
			SaveName: _dsaves_fetch_json_info(_metadata, "SaveName", dutils_remove_file_extension(filename)),
			Category: _dsaves_fetch_json_info(_metadata, "Category", filename_name(filepath)),
			Chapter: _dsaves_fetch_json_info(_metadata, "Chapter", global.chapter),
			Description: _dsaves_fetch_json_info(_metadata, "Description", "A save file"),
		},
		save_file: (_metadata != undefined) ? _content.save_file : ""
	};

	return (res_json);
}
