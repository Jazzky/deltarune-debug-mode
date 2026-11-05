function dmenu_dsave_process_submenus(arg0, arg1 = "")
{
	var _subs = arg0;
	var _search = string_lower(arg1);

	var nb_buttons = array_length(dbuttons);
    var my_options = array_create(nb_buttons);
    array_copy(my_options, 0, dbuttons, 0, nb_buttons);

    var _state_tracker = dmenu_expanded;
	if (_state_tracker == undefined)
		_state_tracker = array_create(nb_buttons, false);
    
    while (array_length(_state_tracker) < array_length(my_options))
        array_push(_state_tracker, false);
    
    var _search_changed = dmenu_last_search != _search;
    dmenu_last_search = _search;
    
    if (_search == "" && dmenu_was_searching)
    {
        for (var k = 0; k < array_length(_state_tracker); k++)
            _state_tracker[k] = false;
        
        dmenu_was_searching = false;
    }
    else if (_search != "")
    {
        dmenu_was_searching = true;
    }
    
    var _temp_buttons = [];
    var _temp_base_indices = [];
    var _needs_struct_save = false;
    
    for (var i = 0; i < array_length(my_options); i++)
    {
        var _base_name = my_options[i].text;
        var _is_dropdown = i < array_length(_subs) && is_array(_subs[i]);
        var _original_index = (i < nb_buttons) ? dbuttons[i].data : -1;
        var _is_persistent = _original_index == -2;
        var _cat_match = true;
        var _sub_match = false;
        
        if (_search != "" && !_is_persistent)
        {
            _cat_match = string_pos(_search, string_lower(_base_name)) > 0;
            
            if (_is_dropdown)
            {
                var _submenu = _subs[i];
                
                for (var j = 0; j < array_length(_submenu); j++)
                {
                    if (string_pos(_search, string_lower(_submenu[j])) > 0)
                        _sub_match = true;
                }
                
                if (_search_changed && _state_tracker[i] != _sub_match)
                {
                    _state_tracker[i] = _sub_match;
                    _needs_struct_save = true;
                }
            }
            
            if (!_cat_match && !_sub_match)
                continue;
        }
        
        var _is_open = _is_dropdown && _state_tracker[i] == true;
        var _display_name = _base_name;
        
        if (_is_dropdown)
            _display_name += (_is_open ? " ^" : " v");
        
		var _new_bt = dmenu_makebt(_display_name, _original_index);
		if (_is_dropdown)
			dmenu_set_bttype(_new_bt, "category");

		array_push(_temp_buttons, _new_bt);
        array_push(_temp_base_indices, i);
        
        if (_is_open)
        {
            var _submenu = _subs[i];
            var _subindices = (array_length(_subs) > (i + 1000) && is_array(_subs[i + 1000])) ? _subs[i + 1000] : [];
            
            for (var j = 0; j < array_length(_submenu); j++)
            {
                if (_search == "" || _cat_match || string_pos(_search, string_lower(_submenu[j])) > 0)
                {
                    var exact_index = (array_length(_subindices) > j) ? _subindices[j] : -1;
                    array_push(_temp_buttons, dmenu_makebt("- " + _submenu[j], exact_index));
                    array_push(_temp_base_indices, i);
                }
            }
        }
    }
    
    if (_needs_struct_save || (dmenu_expanded == undefined))
		dmenu_expanded = _state_tracker;
    
    dbuttons = _temp_buttons;
    dbutton_base_indices = _temp_base_indices;
}

function dmenu_dsave_interact_submenus()
{
	var pressed_btn = dbuttons[dvertical_index];
	var is_category = (pressed_btn.type == "category");

	if (!is_category)
		return (false);
    
    if (dmenu_expanded != undefined)
    {
        var _state_tracker = dmenu_expanded;
        
        if (dvertical_index < array_length(_state_tracker))
        {
            _state_tracker[dvertical_index] ^= 1;
			dmenu_expanded = _state_tracker;
            return true;
        }
    }
    
    return false;
}
