function dpop_history()
{
	dmenu_reset_kb();
    dmenu_skip_reindexing = true;
    
    if (array_length(dmenu_state_history) == 0)
    {
		dmenu_reset_menu();
        dmenu_state_update();
    }
    
	dpop_history_vars(false);
    dmenu_state_update();
};

function dpop_history_vars(arg0=false)
{
	var just_delete = arg0;
	var _temp;

    if (array_length(dmenu_state_history) > 0) {
        _temp = array_pop(dmenu_state_history);
		if (!just_delete)
			dmenu_state = _temp;
	}
    
    if (array_length(dmenu_vertical_index_history) > 0) {
        _temp = array_pop(dmenu_vertical_index_history);
		if (!just_delete)
			dvertical_index = _temp;
	}

    if (array_length(dmenu_start_index_history) > 0) {
        _temp = array_pop(dmenu_start_index_history);
		if (!just_delete)
			dmenu_start_index = _temp;
	}

    if (array_length(dmenu_horizontal_index_history) > 0) {
        _temp = array_pop(dmenu_horizontal_index_history);
		if (!just_delete)
			dhorizontal_index = _temp;
	}
    
    if (array_length(dmenu_page_index_history) > 0) {
        _temp = array_pop(dmenu_page_index_history);
		if (!just_delete)
			dhorizontal_page = _temp;
	}
};

function dremove_false_history()
{
	dpop_history_vars(true);
}
