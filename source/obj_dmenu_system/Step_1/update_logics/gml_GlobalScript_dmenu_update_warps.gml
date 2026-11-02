function dmenu_update_warp()
{
	dmenu_title = dstr("Room List", "Liste des salles");
	dbutton_options = [dstr("Current Room", "Salle actuelle"), dstr("Search", "Recherche")];
	dbutton_indices = [-1, -1];
	
	if (dutils_reading_kb())
		dbutton_options[1] = dstr("Contains: ", "Contient : ");
	else
		dbutton_options[1] = dstr("Search", "Recherche");
	
	dbutton_options[1] += dkeyboard_input;
	var nb_rooms = array_length(drooms);
	
	for (var i = 0; i < nb_rooms; i++)
	{
		if (!string_pos(dkeyboard_input, drooms[i]))
			continue;
		
		var combined = drooms[i];
		array_push(dbutton_options, combined);
		array_push(dbutton_indices, drooms_id[i].room_index);
	}
	
	dbutton_layout = 1;
	dmenu_box = 1;
}

function dmenu_update_warp_options()
{
	dmenu_title = dstr("Warp Options", "Options du saut");
	dbutton_options = [
			dstr("Cancel", "Annuler"),
			dstr("Is Darkworld: ", "Est un Darkworld : "),
			dstr("Plot Value: ", "Valeur de plot : "),
			dstr("Teammate 2:  ", "Équipier 2 :  "),
			dstr("Teammate 3:  ", "Équipier 3 :  "),
			dstr("Warp", "Sauter")
	];

	dbutton_indices = [];
	for (var i = 0; i < array_length(dbutton_options); i++)
		dbutton_indices[i] = i;

	dbutton_options[1] += drooms_options.target_is_darkzone ? dstr("Yes", "Oui") : dstr("No", "Non");
	
	if (dutils_reading_kb())
		dbutton_options[2] += dkeyboard_input;
	else
		dbutton_options[2] += string(drooms_options.target_plot);
	
	teammates = [dstr("Nobody", "Personne"), "Kris", "Susie", "Ralsei", "Noëlle"];
	dbutton_options[3] += teammates[drooms_options.target_member_2];
	dbutton_options[4] += teammates[drooms_options.target_member_3];
}
