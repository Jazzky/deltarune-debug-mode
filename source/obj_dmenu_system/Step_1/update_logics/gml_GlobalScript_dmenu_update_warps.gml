function dmenu_update_warp()
{
	dmenu_title = dstr("Room List", "Liste des salles");
	dbuttons = [
		dmenu_makebt(dstr("Current Room", "Salle actuelle")),
		dmenu_makebt(dstr("Search", "Recherche"))
	];

	dmenu_set_bttype(dbuttons[1], "keyboard");
	
	var room_substr = dkeyboard_texts[0];
	if (dutils_reading_kb() || room_substr != "") {
		dbuttons[1].text = dstr("Contains: ", "Contient : ");
		dbuttons[1].data = string_length(dbuttons[1].text);
		dbuttons[1].text += room_substr;
	}

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
			dmenu_makebt(dstr("Cancel", "Annuler"), "cancel"),
			dmenu_makebt(dstr("Is Darkworld: ", "Est un Darkworld : "), "darkworld"),
			dmenu_makebt(dstr("Plot Value: ", "Valeur de plot : "), "plot"),
	];

	dbuttons[1].text += drooms_options.target_is_darkzone ? dstr("Yes", "Oui") : dstr("No", "Non");
	
	var plot_string = dkeyboard_texts[0];
	dbuttons[2].data = string_length(dbuttons[2]);
	dbuttons[2].text += dutils_reading_kb() ? plot_string : string(drooms_options.target_plot);
	dmenu_set_bttype(dbuttons[2], "keyboard");
	
	var _nb_teammates = 2;
	var _bt_count = array_length(dbuttons);
	for (var i = 0; i < _nb_teammates; i++) {
		var _index = (i == 0) ? drooms_options.target_member_2 : drooms_options.target_member_3;
		var _team_id = string(i + 2);

		var teamtext = dstr("Teammate ", "Équipier ") + _team_id + dstr(": ", " : ");
		if (_index != 0)
			teamtext += "</larrow/>";

		teamtext += " " + teammates[_index];

		if (_index != teammates_max_index)
			teamtext += "</rarrow/>";

		array_push(dbuttons, dmenu_makebt(teamtext, "teammate " + _team_id, [0, teammates_max_index]));
		if (dvertical_index == (_bt_count + i))
			dhorizontal_index = _index
	}
	array_push(dbuttons, dmenu_makebt(dstr("Warp", "Sauter"), "warp"));
}
