function dmenu_dhinter_warp_options()
{
	var new_room = drooms_options.target_room;
	
	if (new_room == -1)
		new_room = room;
	
	dhinter_text = dstr("Selected room: ", "Salle sélectionnée : ");
	dhinter_text += room_get_name(new_room);
}
