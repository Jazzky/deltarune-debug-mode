dconsole_prefix = "[" + global.truename + "]: ";

if (keyboard_check_pressed(vk_f5) && !dutils_reading_kb())
{
    if (!dconsole_active)
    {
        dinteract_bk = global.interact;
        global.interact = 1;
        dconsole_active = true;
        keyboard_string = "";
        dinput_text = "";
        sel_history_count = 0;
    }
}

if (keyboard_check_pressed(vk_escape))
{
    if (dconsole_active)
    {
        global.interact = dinteract_bk;
        dconsole_active = false;
        sel_history_count = 0;
        io_clear();
    }
}

if (dconsole_active)
{
    if (mouse_wheel_up() || keyboard_check_pressed(vk_pageup))
    {
        var _max_scroll = max(0, array_length(dconsole_log) - 1);
        dconsole_scroll = min(dconsole_scroll + 1, _max_scroll);
    }
    
    if (mouse_wheel_down() || keyboard_check_pressed(vk_pagedown))
        dconsole_scroll = max(dconsole_scroll - 1, 0);
    
    if (keyboard_check_direct(vk_control))
    {
        if (keyboard_check_pressed(ord("A")))
        {
            if (dinput_text != "")
                dselect_all = true;
        }
        
        keyboard_string = "";
    }
    
    if (keyboard_check_direct(vk_left))
    {
        dleft_timer++;
        
        if (dleft_timer == 1 || (dleft_timer > 15 && (dleft_timer % 1) == 0))
        {
            dselect_all = false;
            dcursor_pos = max(0, dcursor_pos - 1);
            blink_cursor = "|";
            blink_timer = 0;
        }
    }
    else
    {
        dleft_timer = 0;
    }
    
    if (keyboard_check_direct(vk_right))
    {
        dright_timer++;
        
        if (dright_timer == 1 || (dright_timer > 15 && (dright_timer % 1) == 0))
        {
            dselect_all = false;
            dcursor_pos = min(string_length(dinput_text), dcursor_pos + 1);
            blink_cursor = "|";
            blink_timer = 0;
        }
    }
    else
    {
        dright_timer = 0;
    }
    
    if (keyboard_string != "")
    {
        if (dselect_all)
        {
            dinput_text = "";
            dcursor_pos = 0;
            dselect_all = false;
        }
        
        dinput_text = string_insert(keyboard_string, dinput_text, dcursor_pos + 1);
        dcursor_pos += string_length(keyboard_string);
        keyboard_string = "";
        blink_cursor = "|";
        blink_timer = 0;
    }
    
    if (keyboard_check_direct(vk_backspace))
    {
        dbackspace_timer++;
        
        if (dbackspace_timer == 1 || (dbackspace_timer > 15 && (dbackspace_timer % 1) == 0))
        {
            if (dselect_all)
            {
                dinput_text = "";
                dcursor_pos = 0;
                dselect_all = false;
            }
            else if (dcursor_pos > 0)
            {
                dinput_text = string_delete(dinput_text, dcursor_pos, 1);
                dcursor_pos--;
            }
            
            blink_cursor = "|";
            blink_timer = 0;
        }
    }
    else
    {
        dbackspace_timer = 0;
    }
    
    if (keyboard_string != "")
    {
        if (dselect_all)
        {
            dinput_text = "";
            dcursor_pos = 0;
            dselect_all = false;
        }
        
        dinput_text = string_insert(keyboard_string, dinput_text, dcursor_pos + 1);
        dcursor_pos += string_length(keyboard_string);
        keyboard_string = "";
        blink_cursor = "|";
        blink_timer = 0;
    }
    
    if (keyboard_check_pressed(vk_enter))
    {
        if (dinput_text != "")
        {
            array_push(dconsole_log, dconsole_prefix + dinput_text);
            array_push(dconsole_history, dinput_text);
            
			scr_dconsole_command(dinput_text);
            
            dinput_text = "";
            keyboard_string = "";
            sel_history_count = 0;
            dcursor_pos = 0;
            dselect_all = false;
            dconsole_scroll = 0;
            blink_cursor = "|";
            blink_timer = 0;
        }
    }
    
    if (keyboard_check_direct(vk_up))
    {
        dup_timer++;
        
        if (dup_timer == 1 || (dup_timer > 20 && (dup_timer % 5) == 0))
        {
            var _len = array_length(dconsole_history);
            
            if (_len > 0 && sel_history_count < _len)
            {
                sel_history_count++;
                var _entry = _len - sel_history_count;
                dinput_text = dconsole_history[_entry];
                dcursor_pos = string_length(dinput_text);
                dselect_all = false;
                blink_cursor = "|";
                blink_timer = 0;
            }
        }
    }
    else
    {
        dup_timer = 0;
    }
    
    if (keyboard_check_direct(vk_down))
    {
        ddown_timer++;
        
        if (ddown_timer == 1 || (ddown_timer > 20 && (ddown_timer % 5) == 0))
        {
            if (sel_history_count > 0)
            {
                sel_history_count--;
                
                if (sel_history_count == 0)
                {
                    dinput_text = "";
                }
                else
                {
                    var _len = array_length(dconsole_history);
                    var _entry = _len - sel_history_count;
                    dinput_text = dconsole_history[_entry];
                }
                
                dcursor_pos = string_length(dinput_text);
                dselect_all = false;
                blink_cursor = "|";
                blink_timer = 0;
            }
        }
    }
    else
    {
        ddown_timer = 0;
    }
    
    blink_timer++;
    
    if (blink_timer > 30)
    {
        blink_cursor = (blink_cursor == "|") ? "" : "|";
        blink_timer = 0;
    }
    
    io_clear();
}
