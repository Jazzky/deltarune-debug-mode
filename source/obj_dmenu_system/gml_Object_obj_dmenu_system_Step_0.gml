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


function vmove_menu(arg0, arg1)
{
	var move_up = arg0;
	var move_down = arg1;

	var y_limit = nb_button;
	var new_y = dvertical_index;
	var new_draw_y = dmenu_start_index;
	var drawn_elements = min(5, y_limit); //TODO check if a variable exist
	var middle_elements = ceil(drawn_elements / 2);

	if (move_up)
		new_y--;

	if (move_down)
		new_y++;

	if (new_y == dvertical_index)
		exit;


	if (new_y == -1)
		new_y = y_limit - 1;

	else if (new_y == y_limit)
		new_y = 0;


	if (new_y < middle_elements)
		new_draw_y = new_y;

	else if (new_y >= (y_limit - middle_elements))
		new_draw_y = drawn_elements - (y_limit - new_y);


	dvertical_index = new_y;
	dmenu_start_index = new_draw_y;
	if (dmenu_state == "flag_misc")
	{
		new_options = dother_options[dvertical_index];
		dhorizontal_index = find_subarray_index(new_options[2], new_options[3]);
	}
	snd_play(snd_menumove);
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
	dmenu_move_sideway();
    if (dbutton_layout == 0 && dkeys_helper == 0)
    {
        if (up_pressed)
        {
            dvertical_index--;
            
            if (dvertical_index == -1)
                dvertical_index = array_length(dbuttons_2d) - 1;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbuttons_2d[dvertical_index]) - 1);
        }
        else if (down_pressed)
        {
            dvertical_index++;
            
            if (dvertical_index == array_length(dbuttons_2d))
                dvertical_index = 0;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbuttons_2d[dvertical_index]) - 1);
        }
    }
    
    if (dbutton_layout == 1)
    {
        if (dmenu_state == "globals_changer" && (up_pressed || down_pressed))
            dhorizontal_index = 0;
        
		var up_requirement = (dvertical_index == 0) ? up_pressed : up_held;
		var down_requirement = (dvertical_index == (nb_button - 1)) ? down_pressed : down_held;
		vmove_menu(up_requirement, down_requirement);

    }
    
    if (dbutton_layout == 2)
    {
    }
    
    if (dbutton_layout == 3)
	{
		if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down))
		{
			dvertical_index ^= 1;
			snd_play(snd_menumove);
		}
	}
    
	if (dhorizontal_index != original_x ||
		dvertical_index != original_y)
	{
		snd_play(
		dmenu_state_update();
	}

	dmenuback_update_dhinter();

    if (button1_p())
    {
        if (!(dmenu_state == "new_debug_save" && dvertical_index == 0))
            snd_play(snd_select);
        
        array_push(dmenu_state_history, dmenu_state);
        array_push(dmenu_vertical_index_history, dvertical_index);
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
			var real_index = cur_btn.indice;
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
            option_name = "";
            
            if (dbutton_layout == 0)
                option_name = string(dbuttons_2d[dvertical_index][dhorizontal_index]);
            else
                option_name = string(cur_btn.text);
            
            scr_debug_print(option_name + dstr(" selected!", " sélectionné !"));
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

if ((dmenu_active == 1 && dmenu_state == "debug") || dkeys_helper == 1)
{
    if (keyboard_check_pressed(ord("M")))
    {
        if (dkeys_helper == 0)
            snd_play(snd_select);
        else
            snd_play(snd_smallswing);
        
        dkeys_helper = !dkeys_helper;
    }
}

if (dmenu_active == 1 && dmenu_state == "debug")
{
    if (keyboard_check_pressed(ord("F")))
    {
        global.dlang = (global.dlang == "en") ? "fr" : "en";
        scr_debug_print(dstr("Debug menu now in English!", "Menu debug désormais en français !"));

		dmenu_reset_menu();
    }
}
