function _dmenu_check_dsave_cate_id(arg0, arg1)
{
	var cat_name = arg0;
	var cat_lst = arg1;

	var nb_cat = array_length(cat_lst);
	for (var i = 0; i < nb_cat; i++) {
		if (cat_lst[i] == cat_name)
			return (i);
	}
	array_push(cat_lst, cat_name);
	return (nb_cat);
}

function dmenu_update_dsave_main_menu()
{
	dmenu_title = "Debug save";
	dbuttons = [
		dmenu_makebt(dstr("New save", "Nouvelle sauvegarde"), -2),
		dmenu_makebt(dstr("Search", "Recherche"), -2)
	];

	dmenu_set_bttype(dbuttons[1], "keyboard");

	var save_substr = dkeyboard_texts[0];
	if (save_substr != "" || dutils_reading_kb())
	{
		dbuttons[1].text = dstr("Contains: ", "Contient : ");
		dbuttons[1].data = string_length(dbuttons[1].text);
		dbuttons[1].text += save_substr;
	}
	
	var subs = [];
	var categories = [];
	for (var i = 0; i < array_length(debug_saves); i++)
	{
		var _save = debug_saves[i];

		var _cate_id = _dmenu_check_dsave_cate_id(_save.cat, categories);
		if (_cate_id == array_length(subs))
			array_push(subs, []);

		if (!string_pos(save_substr, _save.name))
			continue;

		var save_bt = dmenu_makebt(_save.name, _save);
		if (_save.cat == "")
			array_push(dbuttons, save_bt);
		else
			array_push(subs[_cate_id], save_bt)
	}

	var nb_base_bt = array_length(dbuttons);
	var _dbuttons_index = nb_base_bt;
	for (var i = 0; i < array_length(categories); i++) {
		if (!array_length(subs[i]) || categories[i] == "")
			continue;

		dbuttons[_dbuttons_index] = dmenu_makebt(categories[i]);
		dmenu_create_category(_dbuttons_index++, subs[i]);
	}
	dmenu_box = 1;
	dbutton_layout = 1;
}
