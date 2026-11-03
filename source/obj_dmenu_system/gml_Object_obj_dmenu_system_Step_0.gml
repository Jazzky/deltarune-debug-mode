dmenu_arrow_timer += 1;

var left_held = dutils_key_pressed(vk_left);
var right_held = dutils_key_pressed(vk_right);
var up_held = dutils_key_pressed(vk_up);
var down_held = dutils_key_pressed(vk_down);

var left_pressed = keyboard_check_pressed(vk_left);
var right_pressed = keyboard_check_pressed(vk_right);
var up_pressed = keyboard_check_pressed(vk_up);
var down_pressed = keyboard_check_pressed(vk_down);

if (dmenu_popup_launch == 1)
{
    dmenu_state_update();
    global.interact = 1;
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

if (dmenu_popup_launch != 1)
{
    if (!global.dreading_kb && keyboard_check_pressed(ord("D")))
    {
        dmenu_active = !dmenu_active;
        
        if (dmenu_active)
        {
            dmenu_previous_interact = global.interact;
            snd_play(snd_egg);
            global.interact = 1;
        }
        else
        {
            snd_play(snd_smallswing);
            global.interact = dmenu_previous_interact;
        }
    }
}

function vmove_menu(arg0, arg1)
{
	var move_up = arg0;
	var move_down = arg1;

	var y_limit = array_length(dbutton_options);
	var new_y = dvertical_index;
	var new_draw_y = dmenu_start_index;

	if (move_up)
		new_y--;

	if (move_down)
		new_y++;

	if (new_y == -1)
	{
		new_y = y_limit - 1;
		new_draw_y = min(5, y_limit) - 1; //TODO check if a variable exist
	}

	else if (new_y == y_limit)
	{
		new_y = 0;
		new_draw_y = 0;
	}

	if (new_y == dvertical_index)
		exit;

	dvertical_index = new_y;
	dmenu_start_index = new_draw_y;
	if (dmenu_state == "flag_misc")
	{
		new_options = dother_options[dvertical_index];
		dhorizontal_index = find_subarray_index(new_options[2], new_options[3]);
	}
	snd_play(snd_menumove);
}

function evaluate_custom_flag(arg0, arg1)
{
    scr_debug_print("Checking for " + string(arg1));
    proper_exit = arg0;
    
    if (!proper_exit)
    {
        set_keyboard_reader(0);
        return 0;
    }
    
    first_type = arg1;
    proper_exit = dutils_istype(dcustom_flag_text[0], first_type, true);
    
    if (dmenu_state != "flag_categories")
        return proper_exit;
    
    proper_exit = dutils_isnum(dcustom_flag_text[1], true);
    
    if (string_length(dcustom_flag_text[1]) == 0)
    {
        if (proper_exit)
            scr_debug_print("global.flag[" + string(real(dcustom_flag_text[0])) + "] = |" + string(global.flag[real(dcustom_flag_text[0])]) + "|");
        else
            scr_debug_print(dstr("Empty value", "Valeur vide"));
        
        proper_exit = 0;
    }
    
    if (proper_exit)
    {
        scr_debug_print(dstr("Updated ", "Mise à jour de ") + "global.flag[" + string(real(dcustom_flag_text[0])) + "]" + dstr(" from ", " de ") + "|" + string(global.flag[real(dcustom_flag_text[0])]) + "|" + dstr(" to ", " à ") + "|" + dcustom_flag_text[1] + "|");
        global.flag[real(dcustom_flag_text[0])] = real(dcustom_flag_text[1]);
    }
    
    if (proper_exit)
    {
        dmenu_active = 0;
        global.interact = 0;
    }
    
    return proper_exit;
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
                dmenu_start_index = clamp(dmenu_start_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
            
            snd_play(snd_select);
            keyboard_clear(vk_left);
        }
    }
}

if (dmenu_active && global.dreading_kb)
{
    update_visu = 1;
    will_exit = 0;
    reading_double_flag = dmenu_state == "flag_categories" || (dmenu_state == "globals_changer" && dvertical_index == 0);
    
    if (!reading_double_flag)
        dkeyboard_input = dcustom_flag_text[0];
    
    will_exit = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(global.input_k[7]);
    will_exit |= (up_pressed || down_pressed);
    
    if (will_exit)
    {
        clean_exit = !keyboard_check_pressed(vk_escape);
        
        if (clean_exit)
        {
            if (dmenu_state == "flag_categories" || dmenu_state == "warp_options" || dmenu_state == "globals_changer")
            {
                check_type = "uint";
                
                if (dmenu_state == "warp_options")
                    check_type = "real";
                
                if (dmenu_state == "globals_changer")
                {
                    if (dvertical_index == 0)
                    {
                        check_type = "variable";
                        dglobal_changer_options[dvertical_index][1] = "string";
                        
                        if (dutils_isnum(dcustom_flag_text[1]))
                            dglobal_changer_options[dvertical_index][1] = "real";
                    }
                    else
                    {
                        check_type = dglobal_changer_options[dvertical_index][1];
                    }
                }
                
                if (dcustom_flag_text[0] != "")
                {
                    flags_good = evaluate_custom_flag(clean_exit, check_type);
                    
                    if (flags_good && dmenu_state == "warp_options")
                        drooms_options.target_plot = real(dkeyboard_input);
                    
					if (!flags_good)
						dmenu_reset_kb();

                    snd_play(array_get([299, 420], flags_good));
                }
            }
        }
        else
        {
            set_keyboard_reader(0);
            dkeyboard_input = "";
            dcustom_flag_text = ["", ""];
            snd_play(snd_error);
        }
        
        if (down_pressed)
            vmove_menu(0, 1);
        else if (up_pressed)
            vmove_menu(1, 0);
        
        if (dmenu_state != "warp_options")
        {
            if (button1_p())
            {
                snd_play(snd_select);
                
                if (dmenu_state == "globals_changer" && flags_good)
                    dmenu_state_interact();
            }
            else if (keyboard_check_pressed(vk_escape))
            {
                snd_play(snd_error);
            }
            else
            {
                snd_play(snd_menumove);
            }
        }
        
        if (!clean_exit)
            dkeyboard_input = "";
        
        set_keyboard_reader(0);
        will_exit = 1;
    }
    else if (reading_double_flag && keyboard_check_pressed(vk_left) && dhorizontal_index != 0)
    {
        snd_play(snd_menumove);
		dutils_set_kb_text(dcustom_flag_text[--dhorizontal_index]);
    }
    else if (reading_double_flag && keyboard_check_pressed(vk_right) && dhorizontal_index != 1)
    {
        snd_play(snd_menumove);
		dutils_set_kb_text(dcustom_flag_text[++dhorizontal_index]);
    }
    else
    {
        update_visu = dutils_read_kb();
        flag_index = 0;
        
        if (reading_double_flag)
            flag_index = dhorizontal_index;
        
        dcustom_flag_text[flag_index] = dutils_get_kb_text();
    }
    
    if (update_visu)
    {
        if (!will_exit)
            dkeyboard_input = dcustom_flag_text[0];
        
        dmenu_state_update();
    }
}
else if (dmenu_active)
{
    if (dbutton_layout == 0 && dkeys_helper == 0)
    {
        moved = 1;
        
        if (up_pressed)
        {
            dvertical_index--;
            
            if (dvertical_index == -1)
                dvertical_index = array_length(dbutton_options_2d) - 1;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        }
        else if (down_pressed)
        {
            dvertical_index++;
            
            if (dvertical_index == array_length(dbutton_options_2d))
                dvertical_index = 0;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        }
        else if (left_pressed)
        {
            dhorizontal_index--;
            
            if (dhorizontal_index == -1)
            {
                dvertical_index--;
                
                if (dvertical_index == -1)
                    dvertical_index = array_length(dbutton_options_2d) - 1;
                
                dhorizontal_index = array_length(dbutton_options_2d[dvertical_index]) - 1;
            }
        }
        else if (right_pressed)
        {
            dhorizontal_index++;
            
            if (dhorizontal_index == array_length(dbutton_options_2d[dvertical_index]))
            {
                dvertical_index++;
                
                if (dvertical_index == array_length(dbutton_options_2d))
                    dvertical_index = 0;
                
                dhorizontal_index = 0;
            }
        }
        else
        {
            moved = 0;
        }
        
        if (moved)
            snd_play(snd_menumove);
    }
    
    if (dbutton_layout == 1)
    {
        og_horizontal_index = dhorizontal_index;
        
        if (dmenu_state == "flag_misc")
        {
            cur_options = dother_options[dvertical_index];
            cur_options_len = array_length(cur_options[3]);
            playsound = 1;
            
            if (right_pressed && dhorizontal_index < (cur_options_len - 1))
                dhorizontal_index++;
            else if (left_pressed && dhorizontal_index != 0)
                dhorizontal_index--;
            else
                playsound = 0;
            
            if (playsound)
            {
                global.flag[cur_options[2]] = cur_options[3][dhorizontal_index][1];
                scr_debug_print(dstr("Updated ", "Mise à jour de ") + "global.flag[" + string(cur_options[2]) + "]" + dstr(" to ", " à ") + "|" + string(cur_options[3][dhorizontal_index][1]) + "|");
                snd_play(snd_menumove);
            }
        }
        else if (dmenu_state == "globals_changer")
        {
            cur_global_array_limit = dglobal_changer_options[dvertical_index][2];
            
            if (left_pressed == 1 && dhorizontal_index != 0)
                dhorizontal_index--;
            
            if (right_pressed == 1 && dhorizontal_index != (cur_global_array_limit - 1))
                dhorizontal_index++;
            
            if (dhorizontal_index != og_horizontal_index)
                snd_play(snd_menumove);
        }
        
        if (right_pressed && left_pressed)
			right_pressed = 0;
        
        if (right_pressed || left_pressed)
        {
            if (dmenu_state == "recruits")
            {
                if (dvertical_index != 0)
                {
                    var real_index = dbutton_indices[dvertical_index];
                    scr_recruit_info(real_index);
                    recruit_count = global.flag[real_index + 600];
                    to_add = 1 / _recruitcount;
                    
                    if (left_pressed)
                    {
                        to_add = -to_add;
                        
                        if (recruit_count == 0)
                            to_add = -1;
                    }
                    else if (right_pressed && recruit_count == -1)
                    {
                        to_add = 1;
                    }
                    
                    if ((right_pressed && (recruit_count * _recruitcount) < _recruitcount) || (left_pressed && (recruit_count * _recruitcount) > -1))
                    {
                        global.flag[600 + real_index] = recruit_count + to_add;
                        dmenu_state_update();
                        snd_play(snd_sparkle_gem);
                    }
                    else
                    {
                        snd_play(snd_error);
                    }
                }
                else if ((right_pressed && dhorizontal_page != global.chapter) || (left_pressed && dhorizontal_page != 0))
                {
                    dhorizontal_page++;
                    
                    if (left_pressed)
                        dhorizontal_page -= 2;
                    
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if (dmenu_state == "warp_options" && (dvertical_index == 3 || dvertical_index == 4))
            {
                cur_party = array_get([drooms_options.target_member_2, drooms_options.target_member_3], dvertical_index - 3);
                new_party = -1;
                
                if (left_pressed && cur_party != 0)
                    new_party = cur_party - 1;
                else if (right_pressed && cur_party != (4 - (global.chapter == 1)))
                    new_party = cur_party + 1;
                
                if (new_party == 1)
                    new_party += (right_pressed - left_pressed);
                
                if (new_party != -1)
                {
                    if (dvertical_index == 3)
                        drooms_options.target_member_2 = new_party;
                    else
                        drooms_options.target_member_3 = new_party;
                    
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if (dmenu_state == "debug_save_options" && dvertical_index == 0)
            {
                var new_setting = -1;
                
                if (left_pressed && global.dload_cur_inv != 0)
                    new_setting = 0;
                else if (right_pressed && global.dload_cur_inv != 1)
                    new_setting = 1;
                
                if (new_setting != -1)
                {
                    global.dload_cur_inv = new_setting;
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if (dmenu_state == "items" || dmenu_state == "weapons" || dmenu_state == "armors")
            {
                dhorizontal_page = !dhorizontal_page;
                dmenu_start_index = 0;
                dvertical_index = 0;
                snd_play(snd_menumove);
                dmenu_state_update();
            }
        }
        
        if (dmenu_state == "globals_changer" && (up_pressed || down_pressed))
            dhorizontal_index = 0;
        
        if (up_pressed && down_pressed)
            up_pressed = 0;
        
        vmove_menu(up_pressed, down_pressed);
        dmenu_start_index = clamp(dmenu_start_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
        
        if (dhorizontal_index != og_horizontal_index)
            dmenu_state_update();
    }
    
    if (dbutton_layout == 2)
    {
        if (left_held || right_held)
        {
            var owned_count = dgiver_infos.owned_amt;
			var storage_space = dgiver_infos.storage_space;
			var item_id = dgiver_infos.item_id;
			var item_type = dgiver_infos.item_type;
			scr_debug_print("Storage space = " + string(storage_space) + ", itemcount = " + string(owned_count));
            
			var to_add = (right_held ? 1 : -1);
			var can_move = ((to_add == 1 && dhorizontal_index < storage_space) ||
							(to_add == -1 && -dhorizontal_index < owned_count));

            if (can_move)
            {
                dhorizontal_index += to_add;
                snd_play(snd_menumove);
            }
            else
            {
                snd_play(snd_error);
            }
        }
    }
    
    if (dbutton_layout == 3)
    {
        if (dvertical_index != 0)
        {
            if (keyboard_check_pressed(vk_left))
            {
                dhorizontal_index--;
                
                if (dhorizontal_index == -1)
                {
                    var TODO = "change this to a proper array_len later";
                    dhorizontal_index = 1;
                }
                
                snd_play(snd_menumove);
            }
            
            if (keyboard_check_pressed(vk_right))
            {
                dhorizontal_index++;
                
                if (dhorizontal_index == 2)
                    dhorizontal_index = 0;
                
                snd_play(snd_menumove);
            }
        }
        
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down))
        {
            dvertical_index ^= 1;
            snd_play(snd_menumove);
        }
    }
    
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
        
        if (scr_array_contains(ditem_types, dmenu_state))
        {
            switch (dmenu_state)
            {
                case "items":
                    if (dhorizontal_page != 0 || dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        
                        if (dhorizontal_page == 0)
                        {
                            scr_iteminfo(real_index);
                            dgiver_bname = itemnameb;
                        }
                        else
                        {
                            for (var i = 0; i < array_length(dlight_objects); i++)
                            {
                                if (dlight_objects[i][0] == real_index)
                                {
                                    real_index = i;
                                    break;
                                }
                            }
                            
                            dgiver_bname = dlight_objects[real_index][1];
                        }
                        
                        scr_debug_print(dgiver_bname + dstr(" selected!", " sélectionné !"));
                    }
                    
                    break;
                
                case "armors":
                    if (dhorizontal_page != 0 || dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        
                        if (dhorizontal_page == 0)
                        {
                            scr_armorinfo(real_index);
                            dgiver_bname = armornametemp;
                        }
                        else
                        {
                            dgiver_bname = dlight_armors[real_index][1];
                        }
                        
                        scr_debug_print(string(dgiver_bname) + dstr(" selected!", " sélectionné !"));
                    }
                    
                    break;
                
                case "weapons":
                    if (dhorizontal_page != 0 || dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        
                        if (dhorizontal_page == 0)
                        {
                            scr_weaponinfo(real_index);
                            dgiver_bname = weaponnametemp;
                        }
                        else
                        {
                            dgiver_bname = dlight_weapons[real_index][1];
                        }
                        
                        scr_debug_print(string(dgiver_bname) + dstr(" selected!", " sélectionné !"));
                    }
                    
                    break;
                
                case "keyitems":
                    if (dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        scr_keyiteminfo(real_index);
                        dgiver_bname = tempkeyitemname;
                        scr_debug_print(string(dgiver_bname) + dstr(" selected!", " sélectionné !"));
                    }
                    
                    break;
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
                option_name = string(dbutton_options_2d[dvertical_index][dhorizontal_index]);
            else
                option_name = string(dbutton_options[dvertical_index]);
            
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
    
    if (dhinter_active)
    {
        if (dmenu_state == "warp_options")
        {
            new_room = drooms_options.target_room;
            
            if (new_room == -1)
                new_room = room;
            
            dhinter_text = dstr("Selected room: ", "Salle sélectionnée : ") + room_get_name(new_room);
        }
        
        if (dmenu_state == "debug_save")
        {
            if (dvertical_index == 0)
            {
                dhinter_text = dstr("[I] - Import individual\n[Alt+I] - Batch import", "[I] - Importation unique\n[Alt+I] - Importation par lot");
            }
            else if (dvertical_index > 0 && dvertical_index < array_length(dbutton_options))
            {
                var real_index = (dvertical_index < array_length(dbutton_indices)) ? dbutton_indices[dvertical_index] : -1;
                
                if (real_index >= 0 && real_index < array_length(debug_save_descriptions))
                    dhinter_text = debug_save_descriptions[real_index];
                else
                    dhinter_text = "";
            }
        }
        
        if (dmenu_state == "debug_save_options")
        {
            var target_path = global.debug_selected_save_section;
            var found_desc = "No description available.";
            
            for (var i = 0; i < array_length(debug_save_sections); i++)
            {
                if (debug_save_sections[i] == target_path)
                {
                    found_desc = debug_save_descriptions[i];
                    break;
                }
            }
            
            dhinter_text = found_desc;
        }
        
        if (scr_array_contains(ditem_types, dmenu_state))
        {
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dhinter_text = dstr("Press ", "Appuyez sur ") + scr_get_input_name(4) + dstr(" to change chapter", " pour changer de chapitre");
            }
            else if (dhorizontal_page == 0 && dvertical_index != 0)
            {
                var hover_id = dbutton_indices[dvertical_index];
                
                if (hover_id != -1)
                {
                    var raw_desc = "";
                    
                    switch (dmenu_state)
                    {
                        case "items":
                            scr_iteminfo(hover_id);
                            raw_desc = itemdescb;
                            break;
                        
                        case "armors":
                            scr_armorinfo(hover_id);
                            raw_desc = armordesctemp;
                            break;
                        
                        case "weapons":
                            scr_weaponinfo(hover_id);
                            raw_desc = weapondesctemp;
                            break;
                        
                        case "keyitems":
                            scr_keyiteminfo(hover_id);
                            raw_desc = tempkeyitemdesc;
                            break;
                    }
                    
                    dhinter_text = string_replace_all(raw_desc, "#", " ");
                    var max_w = (menu_width - (x_padding * 2)) * d;
                    var line_sep = 18 * d;
                    var max_h = line_sep * 2;
                    
                    if (!variable_instance_exists(id, "dhinter_cached_raw") || dhinter_cached_raw != dhinter_text)
                    {
                        dhinter_cached_raw = dhinter_text;
                        var temp_text = dhinter_text;
                        
                        if (string_height_ext(temp_text, line_sep, max_w) > max_h)
                        {
                            while (string_height_ext(temp_text + "...", line_sep, max_w) > max_h && string_length(temp_text) > 0)
                                temp_text = string_delete(temp_text, string_length(temp_text), 1);
                            
                            temp_text += "...";
                        }
                        
                        dhinter_cached_display = temp_text;
                    }
                    
                    dhinter_text = dhinter_cached_display;
                }
                else
                {
                    dhinter_text = "---";
                }
            }
            else
            {
                dhinter_text = "";
            }
        }
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
        
        with (obj_dmenu_system)
        {
            event_perform(ev_create, 0); 
        }

        scr_debug_print(dstr("Debug menu now in English!", "Menu debug désormais en français !"));
        global.interact = 0;
    }
}
