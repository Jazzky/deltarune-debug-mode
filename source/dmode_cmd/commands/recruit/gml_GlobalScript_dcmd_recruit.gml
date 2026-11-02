function dcmd_recruit(argc, argv)
{
	if (global.chapter == 1)
		return (1);

	var flags = dcmd_get_argv_flags(argv);
	argv = dcmd_remove_argv_flags(argv);
	argc = array_length(argv);

	if (argc == 1)
		return (0);

	var flag_end_value = _dcmd_recruit_get_end_value(flags);
	var end_sound = _dcmd_recruit_get_end_sound(flag_end_value);

	for (var i = 0; i < argc; i++) {
		var enemy_name = argv[i];
		var lookup_name = string_lower(enemy_name);

		if (enemy_name == "all") {
			dcmd_recruit_all();
			break;
		}

		var enemy_id = ds_map_find_value(global.recruits_id_map, lookup_name);
		if (enemy_id == undefined) {
			scr_debug_print("Error: no enemy '" + enemy_name + "', skipping...");
			continue;
		}

		_dcmd_recruit_single(enemy_id, flag_end_value);
	}

	if (!dcmd_flags_flag_used(flags, "nosound"))
		snd_play(end_sound);

	return (0);
}

function dcmd_recruit_chapter(argc, argv)
{
	var flags = dcmd_get_avf(argv);
	argv = dcmd_rm_avf(argv);
	argc = array_length(argv);

	if (argc == 1)
		return (0);

	var flag_end_value = _dcmd_recruit_get_end_value(flags);
	var end_sound = _dcmd_recruit_get_end_sound(flag_end_value);

	for (var i = 0; i < argc; i++) {
		var chapter_str = argv[i];

		if (chapter_str == "all") {
			dcmd_recruit_all();
			break;
		}
		if (!scr_string_respect_type(chapter_str, "uint")) {
			scr_debug_print("Error: '" + chapter_str + "' isn't a valid chapter");
			continue;
		}

		var chapter = real(chapter_str);
		var chapter_recruits = scr_get_chapter_recruit_data(chapter);

		for (var i = 0; i < array_length(chapter_recruits); i++)
			_dcmd_recruit_single(chapter_recruits[i], flag_end_value);
	}

	if (!dcmd_flags_flag_used(flags, "nosound"))
		snd_play(end_sound);

	return (0);
}

function dcmd_recruit_all(argc, argv)
{
	var cmd = "recruitchap";
	for (var i = 1; i < (global.chapter + 1); i++)
		cmd += " " + string(i);

	return (dconsole_exec(cmd));
}

function _dcmd_recruit_get_end_value(flags)
{
	var res = 1;
	var try_end_value = argv[argc - 1];
	if (dcmd_flags_flag_used("lose") || try_end_value == "-1") {
		res = -1;",
		argc--;
	}
	return (res);
}

function _dcmd_recruit_get_end_sound(end_value)
{
	if (end_value < 0)
		return (snd_weirdeffect);
	return (snd_pirouette);
}

function _dcmd_recruit_single(arg0, arg1=1)
{
	var enemy_id = arg0;
	var end_value = arg1;

	global.flag[enemy_id + 600] = end_value;
}
