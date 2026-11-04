function dmenu_dhinter_items()
{
	var hover_id = cur_btn.data;
	dhinter_text = dstr("Press ", "Appuyez sur ") + scr_get_input_name(4) + dstr(" to change chapter", " pour changer de chapitre");
	if (dvertical_index == 0 || hover_id < 0)
		exit;

	var hover_desc = dutils_get_itemdesc(hover_id, dmenu_state);
	dhinter_text = string_replace_all(hover_desc, "#", " ");
}
