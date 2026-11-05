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

        var state_tracker = dmenu_expanded;
        if (is_array(state_tracker) && state_tracker[target_base_index] == true)
        {
            state_tracker[target_base_index] = false;
			dmenu_expanded = state_tracker;
            
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
	dmenu_update_keyboard();
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
		snd_play(move_snd);

	dmenuback_update_dhinter();

    if (button1_p())
		dmenu_confirm();
    
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
	dmenu_state_update();
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
