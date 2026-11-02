function dmenu_init_warps()
{
	var drooms_id = scr_get_room_list();

	drooms = [];

	drooms_options = 
	{
		target_room: ROOM_INITIALIZE,
		target_plot: global.plot,
		target_is_darkzone: global.darkzone,
		target_member_2: global.char[1],
		target_member_3: global.char[2]
	};

	for (i = 0; i < array_length(drooms_id); i++)
		array_push(drooms, room_get_name(drooms_id[i].room_index));
}
