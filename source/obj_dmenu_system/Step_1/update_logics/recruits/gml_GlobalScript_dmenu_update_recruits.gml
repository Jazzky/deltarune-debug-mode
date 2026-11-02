function dmenu_update_recruits()
{
	dmenu_title = dstr("Recruit List", "Liste des recrues");

	var preset_string = dstr("Presets", "Préréglages");
	dbutton_options = [preset_string];
	dbutton_indices = [preset_string];
	var max_len = 40;
	
	if (dhorizontal_page != 0)
	{
		dbutton_options[0] = " " + preset_string;
		dbutton_indices[0] = " " + preset_string;
	}
	
	if (dhorizontal_page != 0)
	{
		var chapter_recruits = scr_get_chapter_recruit_data(dhorizontal_page);
		var nb_chap_recr = array_length(chapter_recruits);
		
		for (var i = 0; i < nb_chap_recr; i++)
		{
			var enemy_id = chapter_recruits[i];
			scr_recruit_info(enemy_id);

			var combined = _name + " - [" + string(max(floor(global.flag[enemy_id + 600] * _recruitcount), -1)) + "/" + string(_recruitcount) + "]";
			
			if (string_length(combined) > max_len)
				combined = string_copy(combined, 1, max_len - 3) + "...";
			
			array_push(dbutton_options, combined);
			array_push(dbutton_indices, enemy_id);
		}
	}
	
	if (dhorizontal_page != 0)
		dmenu_box = 1;
	else
		dmenu_box = 0;
	
	dbutton_layout = 1;
}

function dmenu_update_recruits_presets()
{
	dmenu_title = dstr("Recruit Presets", "Préréglages des recrues");
	dbutton_options = [
		dstr("Recruit All", "Recruter tous"),
		dstr("Lose All", "Perdre tous")
	];
	
	if (dhorizontal_page != 0)
	{
		dmenu_title += (" (" + dstr("chap") + " " + string(dhorizontal_page) + ")");
		dbutton_options[0] += " " + dstr("of chapter", "du chapitre") + " " + string(dhorizontal_page);
		dbutton_options[1] += " " + dstr("of chapter", "du chapitre") + " " + string(dhorizontal_page);
	}
	
	dmenu_box = 0;
	dbutton_layout = 1;
}
