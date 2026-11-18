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

	for (i = 0; i < array_length(drooms_id); i++) {
		var temp_room_id = drooms_id[i].room_index;
		var room_info = {
			room_name: room_get_name(temp_room_id),
			room_id: temp_room_id
		}
		array_push(drooms, room_info);
	}
}
