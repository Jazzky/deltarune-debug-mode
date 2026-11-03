function dcmd_recruit(argc, argv, flags)
{
	if (global.chapter == 1)
		return (1);

	if (argc == 1)
		return (0);

	var flag_end_value = _dcmd_recruit_get_end_value(argc, argv, flags);
	var end_sound = _dcmd_recruit_get_end_sound(flag_end_value);

	for (var i = 1; i < argc; i++) {
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

	if (!dcmd_flag_used(flags, "nosound"))
		snd_play(end_sound);

	return (0);
}

function _dcmd_back_recruit_chapter(arg0, arg1=1)
{
	var chapter = arg0;
	var end_value = arg1;

	var chapter_str = string(chapter)
	if (!dutils_isuint(chapter_str)) {
		scr_debug_print("Error: '" + chapter_str + "' isn't a valid chapter");
		return (0);
	}

	chapter = real(chapter);
	var chapter_recruits = scr_get_chapter_recruit_data(chapter);
	for (var i = 0; i < array_length(chapter_recruits); i++)
		_dcmd_recruit_single(chapter_recruits[i], end_value);

	return (0);
}

function dcmd_recruit_chapter(argc, argv, flags)
{
	if (argc == 1)
		return (0);

	var end_value = _dcmd_recruit_get_end_value(argc, argv, flags);
	var end_sound = _dcmd_recruit_get_end_sound(end_value);

	for (var i = 1; i < argc; i++)
		_dcmd_back_recruit_chapter(argv[i], end_value);

	if (!dcmd_flag_used(flags, "nosound"))
		snd_play(end_sound);

	return (0);
}

function dcmd_recruit_all(argc, argv, flags)
{
	var new_argv = [];

	for (var i = 0; i <= global.chapter; i++)
		new_argv[i] = string(i);

	return (dcmd_recruit_chapter(global.chapter + 1, new_argv, flags));
}

function _dcmd_recruit_get_end_value(argc, argv, flags)
{
	var res = 1;
	var try_end_value = argv[argc - 1];
	if (dcmd_flag_used(flags, "lose") || try_end_value == "-1") {
		res = -1;
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
