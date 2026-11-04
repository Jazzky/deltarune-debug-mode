function dmenu_update_warp()
{
	dmenu_title = dstr("Room List", "Liste des salles");
	dbuttons = [
		dmenu_makebt(dstr("Current Room", "Salle actuelle")),
		dmenu_makebt(dstr("Search", "Recherche"))
	];
	
	var room_substr = dkeyboard_texts[0];
	if (dutils_reading_kb() || room_substr != "")
		dbuttons[1].text =  dstr("Contains: ", "Contient : ") + room_substr;

	var nb_rooms = array_length(drooms);
	for (var i = 0; i < nb_rooms; i++)
	{
		var _room_name = drooms[i].room_name;
		var _room_id = drooms[i].room_id;

		if (!string_pos(room_substr, _room_name))
			continue;
		
		var combined = _room_name;
		array_push(dbuttons, dmenu_makebt(combined, _room_id));
	}
	
	dbutton_layout = 1;
	dmenu_box = 1;
}

function dmenu_update_warp_options()
{
	var teammates = [dstr("Nobody", "Personne"), "Kris", "Susie", "Ralsei", dstr("Noelle", "Noëlle")];
	var teammates_max_index = array_length(teammates) - 1;

	dmenu_title = dstr("Warp Options", "Options du saut");
	dbuttons = [
			dmenu_makebt(dstr("Cancel", "Annuler")),
			dmenu_makebt(dstr("Is Darkworld: ", "Est un Darkworld : "), -1, [0, 1]),
			dmenu_makebt(dstr("Plot Value: ", "Valeur de plot : ")),
			dmenu_makebt(dstr("Teammate 2:  ", "Équipier 2 :  "), -1, [0, teammates_max_index]),
			dmenu_makebt(dstr("Teammate 3:  ", "Équipier 3 :  "), -1, [0, teammates_max_index]),
			dmenu_makebt(dstr("Warp", "Sauter"))
	];

	dbuttons[1].text += drooms_options.target_is_darkzone ? dstr("Yes", "Oui") : dstr("No", "Non");
	
	var plot_string = dkeyboard_texts[0];
	dbuttons[2].text += dutils_reading_kb() ? plot_string : string(drooms_options.target_plot);
	
	dbuttons[3].text += teammates[drooms_options.target_member_2];
	dbuttons[4].text += teammates[drooms_options.target_member_3];
}
