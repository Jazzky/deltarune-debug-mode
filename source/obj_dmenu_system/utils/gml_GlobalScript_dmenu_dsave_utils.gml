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
