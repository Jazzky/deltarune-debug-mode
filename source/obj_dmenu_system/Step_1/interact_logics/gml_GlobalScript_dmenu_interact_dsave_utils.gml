function dmenu_dsave_process_submenus(arg0, arg1 = "")
{
	var _subs = arg0;
	var _search = string_lower(arg1);

	var nb_buttons = array_length(dbuttons);
    my_options = array_create(nb_buttons);
    array_copy(my_options, 0, dbuttons, 0, nb_buttons);
    var _state_tracker = variable_struct_exists(dmenu_expanded, dmenu_state) ? variable_struct_get(dmenu_expanded, dmenu_state) : array_create(nb_buttons, false);
    
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
        var _base_name = my_options[i];
        var _is_dropdown = i < array_length(_subs) && is_array(_subs[i]);
        var _original_index = (i < nb_buttons) ? dbuttons[i].indice : -1;
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
        
		array_push(_temp_buttons, dmenu_makeby(_display_name, _original_index));
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
    
    if (_needs_struct_save || !variable_struct_exists(dmenu_expanded, dmenu_state))
        variable_struct_set(dmenu_expanded, dmenu_state, _state_tracker);
    
    dbuttons = _temp_buttons;
    dbutton_base_indices = _temp_base_indices;
}

function dmenu_interact_submenus(arg0)
{
    var _clicked_index = -1;
    
    for (var i = 0; i < array_length(my_options); i++)
    {
        var _base_name = my_options[i];
        
        if (arg0 == (_base_name + " v") || arg0 == (_base_name + " ^"))
        {
            _clicked_index = i;
            break;
        }
    }
    
    if (_clicked_index != -1 && variable_struct_exists(dmenu_expanded, dmenu_state))
    {
        var _state_tracker = variable_struct_get(dmenu_expanded, dmenu_state);
        
        if (_clicked_index < array_length(_state_tracker))
        {
            _state_tracker[_clicked_index] = !_state_tracker[_clicked_index];
            variable_struct_set(dmenu_expanded, dmenu_state, _state_tracker);
            dmenu_skip_reindexing = true;
            dremove_false_history();
            return true;
        }
    }
    
    return false;
}
