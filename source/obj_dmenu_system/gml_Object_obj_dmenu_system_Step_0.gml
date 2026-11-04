dmenu_arrow_timer += 1;

left_held = dutils_key_pressed(vk_left);
right_held = dutils_key_pressed(vk_right);
up_held = dutils_key_pressed(vk_up);
down_held = dutils_key_pressed(vk_down);

enter_pressed = keyboard_check_pressed(vk_enter);
left_pressed = keyboard_check_pressed(vk_left);
right_pressed = keyboard_check_pressed(vk_right);
up_pressed = keyboard_check_pressed(vk_up);
down_pressed = keyboard_check_pressed(vk_down);

if (dbutton_layout != 0) {
	cur_btn = dbuttons[dvertical_index];
	nb_button = array_length(dbuttons);
}
else if (dbutton_layout == 0) {
	cur_btn = dbuttons_2d[dvertical_index][dhorizontal_index];
}

if (!global.dreading_kb && keyboard_check_pressed(ord("D")))
{
	dmenu_active = !dmenu_active;
	
	if (dmenu_active)
		snd_play(snd_egg);
	else
		snd_play(snd_smallswing);

	global.interact = dmenu_active;
}

if (dmenu_state == "debug_save")
{
    if (keyboard_check_pressed(ord("I")) && !global.dreading_kb)
    {
        scr_debug_save_scan_imports();
        scr_get_debug_save_list();
        dmenu_state_update();
    }
}


if (left_pressed && !global.dreading_kb)
{
    if (variable_instance_exists(id, "dbutton_base_indices") && array_length(dbutton_base_indices) > dvertical_index)
    {
        var target_base_index = dbutton_base_indices[dvertical_index];
        var state_tracker = variable_struct_get(dmenu_expanded, dmenu_state);
        
        if (is_array(state_tracker) && state_tracker[target_base_index] == true)
        {
            state_tracker[target_base_index] = false;
            variable_struct_set(dmenu_expanded, dmenu_state, state_tracker);
            
            for (var idx = 0; idx < array_length(dbutton_base_indices); idx++)
            {
                if (dbutton_base_indices[idx] == target_base_index)
                {
                    dvertical_index = idx;
                    break;
                }
            }
            
            if (dvertical_index < dmenu_start_index)
                dmenu_start_index = dvertical_index;
            
            dmenu_state_update();
            
            if (variable_instance_exists(id, "dbutton_max_visible"))
                dmenu_start_index = clamp(dmenu_start_index, 0, max(0, nb_button - dbutton_max_visible));
            
            snd_play(snd_select);
            keyboard_clear(vk_left);
        }
    }
}

if (dmenu_active && dutils_reading_kb())
{
	dmenuback_update_keyboard();
	dmenu_state_update();
}

if (dmenu_active && !dutils_reading_kb())
{
	var original_x = dhorizontal_index;
	var original_y = dvertical_index;

	move_snd = snd_menumove;
	dmenu_xmove();
	dmenu_ymove();
	dmenu_fix_start_index();

	if (dhorizontal_index != original_x || dvertical_index != original_y)
	{
		snd_play(move_snd);
		dmenu_state_update();
	}

	dmenuback_update_dhinter();

    if (button1_p())
    {
        if (!(dmenu_state == "new_debug_save" && dvertical_index == 0))
            snd_play(snd_select);
        
        array_push(dmenu_state_history, dmenu_state);
        array_push(dmenu_vertical_index_history, dvertical_index);
        array_push(dmenu_start_index_history, dmenu_start_index);
        array_push(dmenu_horizontal_index_history, dhorizontal_index);
        array_push(dmenu_page_index_history, dhorizontal_page);
        
        if (dmenu_state == "flag_categories" && dvertical_index == 0)
        {
            global.dreading_kb = true;
            dhorizontal_index = 0;
            keyboard_string = "";
        }
        
        if (dmenu_parent_state == "items")
        {
			var real_index = cur_btn.data;
			if (dhorizontal_page == 0)
			{
				var selected_item = dutils_get_itemname(real_index, dmenu_state);
				scr_debug_print(selected_item + dstr(" selected!", " sélectionné !"));
			}
			else
			{
				scr_debug_print("TODO");
			}
        }
        else if (dmenu_state == "warp" && dvertical_index == 1)
        {
            scr_debug_print(dstr("Search selected!", "Recherche sélectionné !"));
        }
        else if (dmenu_state != "givertab" && dmenu_state != "flag_misc" && dmenu_state != "warp_options" && (dmenu_state != "recruits" || dvertical_index == 0) && dmenu_state != "new_debug_save")
        {
			var option_name = string(cur_btn.text);
        }
        
        dmenu_skip_reindexing = false;
        dmenu_state_interact();
        
        if (!dmenu_skip_reindexing)
        {
            dmenu_start_index = 0;
            dvertical_index = 0;
            dhorizontal_index = 0;
        }
        
        dmenu_state_update();
    }
    
    if (button2_p())
    {
        snd_play(snd_smallswing);
        
        if (dmenu_state == "debug_save")
        {
            if (dmenu_popup_launch == 1)
            {
                if (!instance_exists(obj_savemenu))
                {
                    instance_create(0, 0, obj_savemenu);
                    obj_savemenu.menuno = 1;
                    obj_savemenu.mpos = 3;
                    global.interact = 1;
                }
            }
        }
        
        dpop_history();
    }
}

if (dmenu_active == 1 && dmenu_state == "debug")
{
	if (dkeys_helper == 1 && keyboard_check_pressed(ord("M")))
    {
        if (dkeys_helper == 0)
            snd_play(snd_select);
        else
            snd_play(snd_smallswing);
        
        dkeys_helper = !dkeys_helper;
    }

    if (keyboard_check_pressed(ord("F")))
    {
        global.dlang = (global.dlang == "en") ? "fr" : "en";
        scr_debug_print(dstr("Debug menu now in English!", "Menu debug désormais en français !"));

		dmenu_reset_menu();
    }
}
