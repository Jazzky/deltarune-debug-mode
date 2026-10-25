dmenu_arrow_timer += 1;

if (dmenu_popup_launch == 1)
{
    dmenu_state_update();
    global.interact = 1;
}

if (dmenu_state == "debug_save")
{
    if (keyboard_check_pressed(ord("I")) && keyboard_check(vk_alt) && !global.dreading_custom_flag)
    {
        scr_debug_save_scan_imports();
        scr_get_debug_save_list();
        dmenu_state_update();
    }
    else if (keyboard_check_pressed(ord("I")) && !keyboard_check(vk_alt) && !global.dreading_custom_flag)
    {
        scr_debug_save_import();
        scr_get_debug_save_list();
        dmenu_state_update();
    }
}

if (dmenu_popup_launch != 1)
{
    if (!global.dreading_custom_flag && keyboard_check_pressed(ord("D")))
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

function dmenu_pressed_key(arg0)
{
    if (arg0 != 40 && arg0 != 38 && arg0 != 37 && arg0 != 39 && arg0 != 8)
        return 0;
    
    if (keyboard_check_pressed(arg0))
    {
        dscroll_cur_key = arg0;
        dscroll_timer = 0;
        return 1;
    }
    
    if (arg0 != dscroll_cur_key)
        return 0;
    
    if (keyboard_check(arg0))
    {
        dscroll_timer += 1;
        
        if (dscroll_timer >= dscroll_delay)
        {
            if ((dscroll_timer % dscroll_speed) == 0)
                return 2;
        }
    }
    else if (arg0 == dscroll_cur_key)
    {
        dscroll_timer = 0;
        dscroll_cur_key = 0;
    }
    
    return 0;
}

function vmove_menu(arg0, arg1)
{
    pressed_up = arg0;
    pressed_down = arg1;
    
    if (pressed_up != 0 || pressed_down != 0)
    {
        if (pressed_up == 1 && dvertical_index == 0)
        {
            dvertical_index = array_length(dbutton_options);
            dmenu_start_index = dvertical_index - 2;
        }
        else if (pressed_down == 1 && dvertical_index == (array_length(dbutton_options) - 1))
        {
            dvertical_index = -1;
            dmenu_start_index = 0;
        }
        
        increment = pressed_up ? -1 : 1;
        
        if ((pressed_up && dvertical_index != 0) || (pressed_down && dvertical_index != (array_length(dbutton_options) - 1)))
        {
            dvertical_index += increment;
            snd_play(snd_menumove);
            
            if (pressed_up && dvertical_index < dmenu_start_index)
                dmenu_start_index += increment;
            else if (pressed_down && (dvertical_index + 1) > (dmenu_start_index + dbutton_max_visible))
                dmenu_start_index += increment;
            
            if (dmenu_state == "flag_misc")
            {
                new_options = dother_options[dvertical_index];
                dhorizontal_index = find_subarray_index(new_options[2], new_options[3]);
            }
        }
    }
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
    proper_exit = scr_string_respect_type(dcustom_flag_text[0], first_type, 1, 1);
    
    if (dmenu_state != "flag_categories")
        return proper_exit;
    
    proper_exit = scr_string_respect_type(dcustom_flag_text[1], "real", 0, 1);
    
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

if (keyboard_check_pressed(vk_left) && !global.dreading_custom_flag)
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

if (dmenu_active && global.dreading_custom_flag)
{
    update_visu = 1;
    will_exit = 0;
    reading_double_flag = dmenu_state == "flag_categories" || (dmenu_state == "globals_changer" && dvertical_index == 0);
    
    if (!reading_double_flag)
        dkeyboard_input = dcustom_flag_text[0];
    
    will_exit = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(global.input_k[7]);
    will_exit |= (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down));
    
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
                        
                        if (scr_string_respect_type(dcustom_flag_text[1], "real", 1, 0))
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
        
        if (keyboard_check_pressed(vk_down))
            vmove_menu(0, 1);
        else if (keyboard_check_pressed(vk_up))
            vmove_menu(1, 0);
        
        if (dmenu_state != "warp_options")
        {
            if (keyboard_check_pressed(global.input_k[4]) || keyboard_check_pressed(global.input_k[7]))
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
        global.dkeyboard_text = dcustom_flag_text[--dhorizontal_index];
    }
    else if (reading_double_flag && keyboard_check_pressed(vk_right) && dhorizontal_index != 1)
    {
        snd_play(snd_menumove);
        global.dkeyboard_text = dcustom_flag_text[++dhorizontal_index];
    }
    else
    {
        update_visu = scr_read_keyboard();
        flag_index = 0;
        
        if (reading_double_flag)
            flag_index = dhorizontal_index;
        
        dcustom_flag_text[flag_index] = global.dkeyboard_text;
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
        
        if (keyboard_check_pressed(vk_up))
        {
            dvertical_index--;
            
            if (dvertical_index == -1)
                dvertical_index = array_length(dbutton_options_2d) - 1;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        }
        else if (keyboard_check_pressed(vk_down))
        {
            dvertical_index++;
            
            if (dvertical_index == array_length(dbutton_options_2d))
                dvertical_index = 0;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        }
        else if (keyboard_check_pressed(vk_left))
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
        else if (keyboard_check_pressed(vk_right))
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
        pressed_right = dmenu_pressed_key(39);
        pressed_left = dmenu_pressed_key(37);
        
        if (dmenu_state == "flag_misc")
        {
            cur_options = dother_options[dvertical_index];
            cur_options_len = array_length(cur_options[3]);
            playsound = 1;
            
            if (keyboard_check_pressed(vk_right) && dhorizontal_index < (cur_options_len - 1))
                dhorizontal_index++;
            else if (keyboard_check_pressed(vk_left) && dhorizontal_index != 0)
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
            
            if (pressed_left == 1 && dhorizontal_index != 0)
                dhorizontal_index--;
            
            if (pressed_right == 1 && dhorizontal_index != (cur_global_array_limit - 1))
                dhorizontal_index++;
            
            if (dhorizontal_index != og_horizontal_index)
                snd_play(snd_menumove);
        }
        
        if (pressed_left && pressed_right)
            pressed_right = 0;
        
        if (pressed_right || pressed_left)
        {
            if (dmenu_state == "recruits")
            {
                if (dvertical_index != 0)
                {
                    var real_index = dbutton_indices[dvertical_index];
                    scr_recruit_info(real_index);
                    recruit_count = global.flag[real_index + 600];
                    to_add = 1 / _recruitcount;
                    
                    if (pressed_left)
                    {
                        to_add = -to_add;
                        
                        if (recruit_count == 0)
                            to_add = -1;
                    }
                    else if (pressed_right && recruit_count == -1)
                    {
                        to_add = 1;
                    }
                    
                    if ((pressed_right && (recruit_count * _recruitcount) < _recruitcount) || (pressed_left && (recruit_count * _recruitcount) > -1))
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
                else if ((pressed_right && dhorizontal_page != global.chapter) || (pressed_left && dhorizontal_page != 0))
                {
                    dhorizontal_page++;
                    
                    if (pressed_left)
                        dhorizontal_page -= 2;
                    
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if (dmenu_state == "warp_options" && (dvertical_index == 3 || dvertical_index == 4))
            {
                cur_party = array_get([drooms_options.target_member_2, drooms_options.target_member_3], dvertical_index - 3);
                new_party = -1;
                
                if (pressed_left && cur_party != 0)
                    new_party = cur_party - 1;
                else if (pressed_right && cur_party != (4 - (global.chapter == 1)))
                    new_party = cur_party + 1;
                
                if (new_party == 1)
                    new_party += (pressed_right - pressed_left);
                
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
                
                if (pressed_left && global.dload_cur_inv != 0)
                    new_setting = 0;
                else if (pressed_right && global.dload_cur_inv != 1)
                    new_setting = 1;
                
                if (new_setting != -1)
                {
                    global.dload_cur_inv = new_setting;
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if ((dmenu_state == "objects" || dmenu_state == "weapons" || dmenu_state == "armors") && (pressed_left + pressed_right) == 1)
            {
                dhorizontal_page = !dhorizontal_page;
                dmenu_start_index = 0;
                dvertical_index = 0;
                snd_play(snd_menumove);
                dmenu_state_update();
            }
        }
        
        pressed_up = dmenu_pressed_key(38);
        pressed_down = dmenu_pressed_key(40);
        
        if (dmenu_state == "globals_changer" && (pressed_up || pressed_down))
            dhorizontal_index = 0;
        
        if (pressed_up && pressed_down)
            pressed_up = 0;
        
        vmove_menu(pressed_up, pressed_down);
        dmenu_start_index = clamp(dmenu_start_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
        
        if (dhorizontal_index != og_horizontal_index)
            dmenu_state_update();
    }
    
    if (dbutton_layout == 2)
    {
        if (keyboard_check_pressed(vk_left))
        {
            var owned_count = 0;
            
            switch (dgiver_menu_state)
            {
                case "objects":
                    if (dhorizontal_page == 0)
                        scr_itemcheck(dbutton_indices[dgiver_button_selected - 1]);
                    else
                        scr_litemcheck(dbutton_indices[dgiver_button_selected - 1]);
                    
                    owned_count = itemcount;
                    break;
                
                case "armors":
                    scr_armorcheck_inventory(dbutton_indices[dgiver_button_selected - 1]);
                    owned_count = itemcount;
                    break;
                
                case "weapons":
                    scr_weaponcheck_inventory(dbutton_indices[dgiver_button_selected - 1]);
                    owned_count = itemcount;
                    break;
                
                case "keyitems":
                    scr_keyitemcheck(dbutton_indices[dgiver_button_selected - 1]);
                    owned_count = itemcount;
                    break;
                
                default:
                    owned_count = 0;
            }
            
            if (dgiver_amount > -owned_count)
            {
                dgiver_amount -= 1;
                snd_play(snd_menumove);
            }
            else
            {
                snd_play(snd_error);
            }
        }
        
        if (keyboard_check_pressed(vk_right))
        {
            var owned_count = 0;
            
            switch (dgiver_menu_state)
            {
                case "objects":
                    if (dhorizontal_page == 0)
                        scr_itemcheck(0);
                    else
                        scr_litemcheck(0);
                    
                    owned_count = itemcount;
                    break;
                
                case "armors":
                    scr_armorcheck_inventory(0);
                    owned_count = itemcount;
                    break;
                
                case "weapons":
                    scr_weaponcheck_inventory(0);
                    owned_count = itemcount;
                    break;
                
                case "keyitems":
                    scr_keyitemcheck(0);
                    owned_count = itemcount;
                    break;
                
                case "recruits":
                    real_indice = dbutton_indices[dvertical_index];
                    recruited_nbr = global.flag[real_indice + 600];
                    global.flag[real_indice + 600] = recruited_nbr + 1;
                    break;
                
                default:
                    owned_count = 0;
            }
            
            if (dgiver_amount < owned_count)
            {
                dgiver_amount += 1;
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
    
    if (keyboard_check_pressed(global.input_k[4]) || keyboard_check_pressed(global.input_k[7]))
    {
        if (!(dmenu_state == "new_debug_save" && dvertical_index == 0))
            snd_play(snd_select);
        
        array_push(dmenu_state_history, dmenu_state);
        array_push(dmenu_vertical_index_history, dvertical_index);
        array_push(dmenu_horizontal_index_history, dhorizontal_index);
        array_push(dmenu_page_index_history, dhorizontal_page);
        
        if (dmenu_state == "flag_categories" && dvertical_index == 0)
        {
            global.dreading_custom_flag = 1;
            dhorizontal_index = 0;
            keyboard_string = "";
        }
        
        if (scr_array_contains(ditem_types, dmenu_state))
        {
            switch (dmenu_state)
            {
                case "objects":
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
    
    if (keyboard_check_pressed(global.input_k[5]) || keyboard_check_pressed(global.input_k[8]))
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
                        case "objects":
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