function dpop_history()
{
    dmenu_skip_reindexing = true;
    dkeyboard_input = "";
    
    if (array_length(dmenu_state_history) == 0)
    {
        if (!(dmenu_popup_launch == 1 && dmenu_state == "debug_save"))
            global.interact = 0;
        
        dmenu_popup_launch = 0;
        dmenu_active = !dmenu_active;
        dmenu_state = "debug";
        dbutton_options = dbutton_options_original;
        dmenu_state_history = [];
        dmenu_vertical_index_history = [];
        dmenu_horizontal_index_history = [];
        dmenu_page_index_history = [];
        dvertical_index = 0;
        dmenu_state_update();
    }
    
	dpop_history_vars(false);
    dmenu_state_update();
    dmenu_start_index = clamp(dvertical_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
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
