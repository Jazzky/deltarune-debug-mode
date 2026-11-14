function dmenu_update_recruits()
{
	dmenu_title = dstr("Recruit List", "Liste des recrues");

	var preset_string = dstr("Presets", "Préréglages");
	if (dhorizontal_page != 0)
		preset_string = "</larrow/> " + preset_string;
	if (dhorizontal_page != global.chapter)
		preset_string += "</rarrow/>";

	dbuttons = [
		dmenu_makebt(preset_string, "preset", [0, global.chapter])
	]

	dbutton_layout = 1;
	dhorizontal_index = dhorizontal_page;
	if (dhorizontal_page == 0) {
		dmenu_box = 0;
		exit;
	}

	var max_len = 40;
	var chapter_recruits = scr_get_chapter_recruit_data(dhorizontal_page);
	var nb_chap_recr = array_length(chapter_recruits);
	
	for (var i = 0; i < nb_chap_recr; i++)
	{
		var enemy_id = chapter_recruits[i];
		scr_recruit_info(enemy_id);

		var nb_recruited = max(floor(global.flag[enemy_id + 600] * _recruitcount), -1);
		var combined = _name + " - [" + string(nb_recruited) + "/" + string(_recruitcount) + "]";

		if (string_length(combined) > max_len)
			combined = string_copy(combined, 1, max_len - 3) + "...";
		
		array_push(dbuttons, dmenu_makebt(combined, enemy_id, [-1, _recruitcount]));
		if (dvertical_index == (i + 1))
			dhorizontal_index = nb_recruited;
	}
	
	dmenu_box = 1;
}

function dmenu_update_recruits_presets()
{
	dmenu_title = dstr("Recruit Presets", "Préréglages des recrues");
	dbuttons = [
		dmenu_makebt(dstr("Recruit All", "Recruter tous"), "recruit"),
		dmenu_makebt(dstr("Lose All", "Perdre tous"), "lose")
	];
	
	if (dhorizontal_page != 0)
	{
		dmenu_title += (" (" + dstr("chap") + " " + string(dhorizontal_page) + ")");
		dbuttons[0].text += " " + dstr("of chapter", "du chapitre") + " " + string(dhorizontal_page);
		dbuttons[1].text += " " + dstr("of chapter", "du chapitre") + " " + string(dhorizontal_page);
	}
	
	dmenu_box = 0;
	dbutton_layout = 1;
}
