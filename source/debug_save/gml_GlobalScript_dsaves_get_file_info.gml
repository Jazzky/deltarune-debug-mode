function dsaves_get_file_info(arg0=undefined)
{
	var path = arg0;
	var _new = false;

	var _path_content = dutils_read_file(path);
	if (_path_content != undefined) {
		var _content = json_stringify(_path_content);
		var _metadata = _content.metadata;
	}
	else {
		_new = true;
	}

	var filename = filename_name(path);
	var filepath = filename_path(path);
	var res_json =
	{
		metadata:
		{
			SaveName: dutils_remove_file_extension(filename),
			Category: filename_name(flepath),
			Chapter: (!_new) ? _metadata.Chapter : global.chapter,
			Plot: (!_new) ? _metadata.Plot : global.plot;
			Description: (!_new) ? _metadata.Description : "A save file",
			Room: (!_new) ? _metadata.Room : scr_get_id_by_room_index(room),
		},
		save_file: (!_new) ? _content.save_file : ""
	};

	return (res_json);
}
