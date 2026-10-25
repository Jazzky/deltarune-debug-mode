xx = __view_get(e__VW.XView, 0);
yy = __view_get(e__VW.YView, 0);
d = global.darkzone + 1;

if (dmenu_box == 0)
{
    menu_width = 214;
    menu_length = 94;
    xcenter = 160;
    ycenter = 105;
}

if (dmenu_box == 1)
{
    menu_width = 214;
    menu_length = 154;
    xcenter = 160;
    ycenter = 135;
}

if (dmenu_box == 2)
{
    menu_width = 256;
    menu_length = 154;
    xcenter = 160;
    ycenter = 135;
}

x_start = 0;

if (dbutton_layout == 0)
{
    x_padding = 7 * d;
    y_start = 60 * d;
    x_spacing = 10 * d;
    y_spacing = 10 * d;
    x_start = ((xcenter - (menu_width / 2)) * d) + x_padding;
}

if (dbutton_layout == 1)
{
    x_padding = 7 * d;
    y_start = 95 * d;
    x_spacing = 10 * d;
    y_spacing = 20 * d;
    x_start = ((xcenter - (menu_width / 2)) * d) + x_padding;
}

if (dbutton_layout == 2)
{
    x_padding = 7 * d;
    y_start = 95 * d;
    x_start = ((xcenter - (menu_width / 2)) * d) + x_padding;
}

if (dbutton_layout == 3)
{
    x_padding = 7 * d;
    y_start = 95 * d;
    x_spacing = 10 * d;
    y_spacing = 10 * d;
    x_start = ((xcenter - (menu_width / 2)) * d) + x_padding;
}

button_count = array_length(dbutton_options);

if (dmenu_active)
{
    draw_set_color(c_white);
    draw_rectangle(((xcenter - (menu_width / 2) - 3) * d) + xx, ((ycenter - (menu_length / 2) - 3) * d) + yy, ((xcenter + (menu_width / 2) + 3) * d) + xx, ((ycenter + (menu_length / 2) + 3) * d) + yy, false);
    draw_set_color(c_black);
    draw_rectangle(((xcenter - (menu_width / 2)) * d) + xx, ((ycenter - (menu_length / 2)) * d) + yy, ((xcenter + (menu_width / 2)) * d) + xx, ((ycenter + (menu_length / 2)) * d) + yy, false);
    
    if (global.darkzone == 1)
        draw_set_font(fnt_mainbig);
    else
        draw_set_font(fnt_main);
    
    draw_set_color(c_white);
    draw_text(x_start + xx, (((ycenter - (menu_length / 2)) + 8) * d) + yy, string(dmenu_title));
    
    if (dmenu_state == "debug")
    {
        draw_set_halign(fa_right);
        draw_set_font(fnt_main);
        var text_scale = (global.darkzone == 1) ? 1 : 0.5;
        draw_set_color(c_gray);
        
        var str_ = string(dstr("M - Keys", "M - Touches"));
        
        var draw_x = (((xcenter + (menu_width / 2)) - 10) * d) + xx;
        var draw_y = (((ycenter + (menu_length / 2)) - 15) * d) + yy;
        
        draw_text_transformed(draw_x, draw_y, str_, text_scale, text_scale, 0);
        
        var _fnt = (global.darkzone == 1) ? fnt_mainbig : fnt_main;
        draw_set_font(_fnt);
        draw_set_halign(fa_left);
    }

    if (dmenu_state == "debug")
    {
        draw_set_halign(fa_right);
        draw_set_font(fnt_main);
        var text_scale = (global.darkzone == 1) ? 1 : 0.5;
        draw_set_color(c_gray);
        var str_ = string(dstr("F - French", "F - Anglais"));
        var draw_x = (((xcenter + (menu_width / 2)) - 10) * d) + xx;
        var draw_y = (((ycenter - (menu_length / 2)) + 8) * d) + yy;
        draw_text_transformed(draw_x, draw_y, str_, text_scale, text_scale, 0);
        var _fnt = (global.darkzone == 1) ? fnt_mainbig : fnt_main;
        draw_set_font(_fnt);
        draw_set_halign(fa_left);
    }
    
    if (global.dreading_custom_flag)
    {
        draw_set_halign(fa_right);
        draw_set_color(c_gray);
        var right_border = (xcenter + (menu_width / 2)) * d;
        var padding = 8 * d;
        var draw_x = (right_border + xx) - padding;
        var draw_y = (((ycenter - (menu_length / 2)) + 8) * d) + yy;
        draw_text(draw_x, draw_y, string(dstr("Esc - Cancel", "Esc - Annuler")));
        draw_set_halign(fa_left);
    }
    
    if (global.dreading_custom_flag)
    {
        if (dmenu_state == "flag_categories")
        {
            var base_x = x_start + xx;
            var base_y = (((110 - (dmenu_start_index * 20)) + 2) * d) + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var thickness = 1 * d;
            var visual_offset = -5;
            var cursor_padding = 3 * d;
            var w_prefix = string_length("global.flag[") * mono_spacing;
            var w_name = string_length(string(dcustom_flag_text[0])) * mono_spacing;
            var w_middle = string_length("] = |") * mono_spacing;
            var w_value = string_length(string(dcustom_flag_text[1])) * mono_spacing;
            var x1_start = base_x + w_prefix;
            var x2_start = x1_start + w_name + w_middle;
            draw_set_color(c_yellow);
            var draw_w_name = (w_name == 0) ? (mono_spacing / 4) : w_name;
            var draw_w_value = (w_value == 0) ? (mono_spacing / 4) : w_value;
            
            if (dhorizontal_index == 0)
                draw_rectangle((x1_start + visual_offset) - cursor_padding, base_y, x1_start + draw_w_name + visual_offset + cursor_padding, base_y + thickness, false);
            else if (dhorizontal_index == 1)
                draw_rectangle((x2_start + visual_offset) - cursor_padding - 2, base_y, (x2_start + draw_w_value + visual_offset + cursor_padding) - 2, base_y + thickness, false);
        }
        else if (dmenu_state == "warp" || dmenu_state == "debug_save")
        {
            var base_x = x_start + xx;
            var base_y = (((130 - (dmenu_start_index * 20)) + 2) * d) + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var thickness = 1 * d;
            var visual_offset = -2;
            var cursor_padding = 3 * d;
            var w_prefix = string_length(string(dstr("Contains: ", "Contient : "))) * mono_spacing;
            var w_name = string_length(string(dkeyboard_input)) * mono_spacing;
            var x1_start = base_x + w_prefix;
            var x2_start = x1_start + w_name;
            draw_set_color(c_yellow);
            var draw_w_name = (w_name == 0) ? (mono_spacing / 4) : w_name;
            
            if (dhorizontal_index == 0)
                draw_rectangle((x1_start + visual_offset) - cursor_padding, base_y, x1_start + draw_w_name + visual_offset + cursor_padding, base_y + thickness, false);
        }
        else if (dmenu_state == "warp_options")
        {
            var base_x = x_start + xx;
            var base_y = (((150 - (dmenu_start_index * 20)) + 2) * d) + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var thickness = 1 * d;
            var visual_offset = -2;
            var cursor_padding = 3 * d;
            var w_prefix = string_length(string(dstr("Plot Value: ", "Valeur de plot : "))) * mono_spacing;
            var w_name = string_length(string(dkeyboard_input)) * mono_spacing;
            var x1_start = base_x + w_prefix;
            var x2_start = x1_start + w_name;
            draw_set_color(c_yellow);
            var draw_w_name = (w_name == 0) ? (mono_spacing / 4) : w_name;
            
            if (dhorizontal_index == 0)
                draw_rectangle((x1_start + visual_offset) - cursor_padding, base_y, x1_start + draw_w_name + visual_offset + cursor_padding, base_y + thickness, false);
        }
        else if (dmenu_state == "new_debug_save" || dmenu_state == "dsave_edit_name" || dmenu_state == "dsave_edit_desc" || dmenu_state == "dsave_edit_cat")
        {
            var base_x = x_start + x_padding + xx;
            var base_y = y_start + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
            var max_width = box_right_edge - base_x;
            var line_sep = 16 * d;
            var cursor_x = base_x;
            var cursor_y = base_y;
            var current_word = "";
            var input_str = string(dkeyboard_input);
            var str_len = string_length(input_str);
            
            for (var i = 1; i <= str_len; i++)
            {
                var _char = string_char_at(input_str, i);
                
                if (_char != " " && _char != "\n")
                    current_word += _char;
                
                if (_char == " " || _char == "\n" || i == str_len)
                {
                    var _word_width = string_length(current_word) * mono_spacing;
                    
                    if (max_width > 0 && ((cursor_x + _word_width) - base_x) > max_width)
                    {
                        if (cursor_x != base_x)
                        {
                            cursor_x = base_x;
                            cursor_y += line_sep;
                        }
                    }
                    
                    for (var w = 1; w <= string_length(current_word); w++)
                    {
                        if (max_width > 0 && ((cursor_x + mono_spacing) - base_x) > max_width)
                        {
                            cursor_x = base_x;
                            cursor_y += line_sep;
                        }
                        
                        cursor_x += mono_spacing;
                    }
                    
                    current_word = "";
                    
                    if (_char == " ")
                    {
                        cursor_x += mono_spacing;
                    }
                    else if (_char == "\n")
                    {
                        cursor_x = base_x;
                        cursor_y += line_sep;
                    }
                }
            }
            
            var cursor_thickness = 1 * d;
            var cursor_height = 14 * d;
            cursor_x += (1 * d);
            var final_cursor_y = cursor_y + (2 * d);
            draw_set_color(c_yellow);
            draw_rectangle(cursor_x, final_cursor_y, cursor_x + cursor_thickness, final_cursor_y + cursor_height, false);
        }
    }
    
    if (dbutton_layout == 0)
    {
        var draw_y = (100 * d) + yy;
        
        for (var j = 0; j < array_length(dbutton_options_2d); j++)
        {
            var draw_x = x_start + xx;
            
            for (var i = 0; i < array_length(dbutton_options_2d[j]); i++)
            {
                var cur_btn = string(dbutton_options_2d[j][i]);
                var text_width = string_width(cur_btn);
                draw_set_color((dvertical_index == j && dhorizontal_index == i) ? c_yellow : c_white);
                draw_text(draw_x, draw_y, cur_btn);
                draw_x += (text_width + x_spacing);
            }
            
            draw_y += 15 * d;
        }
    }
    
    side_arrows_mult = (global.darkzone == 1) ? [23, 10] : [12, 5];
    var dmenu_arrow_yoffset, darrow_scale;
    
    if (dbutton_layout == 1)
    {
        var dcan_scroll_up = dmenu_start_index > 0;
        var dcan_scroll_down = (dmenu_start_index + dbutton_max_visible) < array_length(dbutton_options);
        dmenu_arrow_yoffset = 2 * sin(dmenu_arrow_timer / 10);
        darrow_scale = d / 2;
        
        for (var i = 0; i < dbutton_max_visible; i++)
        {
            var button_index = dmenu_start_index + i;
            
            if (button_index < array_length(dbutton_options))
            {
                is_cur_line = dvertical_index == button_index;
                var text_color = is_cur_line ? c_yellow : c_white;
                draw_set_color(text_color);
                var cur_btn = string(dbutton_options[button_index]);
                draw_monospace(x_start + xx, y_start + (i * y_spacing) + yy, cur_btn);
                var mono_spacing = (global.darkzone == 1) ? 15 : 8;
                var needs_arrows = (is_cur_line && dmenu_state == "flag_misc") || (dmenu_state == "warp_options" && (button_index == 3 || button_index == 4)) || (dmenu_state == "debug_save_options" && button_index == 0);
                
                if (needs_arrows)
                {
                    var show_left = false;
                    
                    if (dmenu_state == "flag_misc" && dhorizontal_index != 0)
                        show_left = true;
                    else if (dmenu_state == "warp_options" && array_get([drooms_options.target_member_2, drooms_options.target_member_3], button_index - 3) != 0)
                        show_left = true;
                    else if (dmenu_state == "debug_save_options" && global.dload_cur_inv != 0)
                        show_left = true;
                    
                    if (show_left)
                    {
                        for (dash_pos = 0; 1; dash_pos++)
                        {
                            var check_char = "-";
                            
                            if (dmenu_state == "warp_options")
                                check_char = ":";
                            else if (dmenu_state == "debug_save_options")
                                check_char = "(";
                            
                            if (dash_pos > 4 && string_char_at(cur_btn, dash_pos) == check_char)
                                break;
                        }
                        
                        if (dmenu_state != "debug_save_options")
                            dash_pos++;
                        else
                            dash_pos -= 2;
                        
                        draw_sprite_ext(spr_morearrow, 0, x_start + ((dash_pos * mono_spacing) + floor(mono_spacing / 2)) + dmenu_arrow_yoffset + xx, y_start + (i * y_spacing) + side_arrows_mult[0] + yy, darrow_scale, -darrow_scale, 90, c_white, 1);
                    }
                    
                    var show_right = false;
                    
                    if (dmenu_state == "flag_misc" && dhorizontal_index < (array_length(dother_options[dvertical_index][3]) - 1))
                        show_right = true;
                    else if (dmenu_state == "warp_options" && array_get([drooms_options.target_member_2, drooms_options.target_member_3], button_index - 3) != (4 - (global.chapter == 1)))
                        show_right = true;
                    else if (dmenu_state == "debug_save_options" && global.dload_cur_inv != 1)
                        show_right = true;
                    
                    if (show_right)
                        draw_sprite_ext(spr_morearrow, 0, (x_start + xx + ((string_length(cur_btn) + 1) * mono_spacing)) - floor(mono_spacing / 2) - dmenu_arrow_yoffset, y_start + yy + (i * y_spacing) + side_arrows_mult[1], darrow_scale, -darrow_scale, 270, c_white, 1);
                }
                else if (dmenu_state == "recruits" && button_index == 0)
                {
                    if (dhorizontal_page != 0)
                        draw_sprite_ext(spr_morearrow, 0, x_start + floor(mono_spacing / 2) + dmenu_arrow_yoffset + xx, y_start + (i * y_spacing) + side_arrows_mult[0] + yy, darrow_scale, -darrow_scale, 90, c_white, 1);
                    
                    if (dhorizontal_page != global.chapter)
                        draw_sprite_ext(spr_morearrow, 0, ((x_start + ((string_length(cur_btn) + 1) * mono_spacing)) - floor(mono_spacing / 2) - dmenu_arrow_yoffset) + xx, y_start + (i * y_spacing) + side_arrows_mult[1] + yy, darrow_scale, -darrow_scale, 270, c_white, 1);
                }
            }
        }
        
        draw_set_color(c_white);
        
        if (dcan_scroll_up)
            draw_sprite_ext(spr_morearrow, 0, x_start + xx, y_start + (dbutton_max_visible * (y_spacing * -0.03)) + dmenu_arrow_yoffset + yy, darrow_scale, -darrow_scale, 0, c_white, 1);
        
        if (dcan_scroll_down)
            draw_sprite_ext(spr_morearrow, 0, x_start + xx, ((y_start + (dbutton_max_visible * y_spacing)) - dmenu_arrow_yoffset) + yy, darrow_scale, darrow_scale, 0, c_white, 1);
    }
    
    if (dmenu_state == "recruits" || dmenu_state == "weapons" || dmenu_state == "armors" || dmenu_state == "objects")
    {
        draw_set_halign(fa_right);
        var draw_y = (((ycenter - (menu_length / 2)) + 8) * d) + yy;
        var draw_x = x_start + (200 * d) + xx;
        
        if (dmenu_state == "recruits")
        {
            if (dhorizontal_page != 0)
                draw_text(draw_x, draw_y, "(" + string(dstr("chap")) + " " + string(dhorizontal_page) + ")");
            else
                draw_text(draw_x, draw_y, string(dstr("(all chap)", "(tout chap)")));
        }
        else if (dhorizontal_page == 0)
        {
            draw_text(draw_x + 30 + (global.darkzone * 30), draw_y, string(dstr("(Darkworld)")));
            draw_sprite_ext(spr_morearrow, 0, draw_x + 35 + (global.darkzone * 35) + dmenu_arrow_yoffset, draw_y + side_arrows_mult[1], darrow_scale, -darrow_scale, 270, c_white, 1);
        }
        else
        {
            draw_text(draw_x + 30 + (global.darkzone * 30), draw_y, string(dstr("(Lightworld)")));
            draw_sprite_ext(spr_morearrow, 0, draw_x + -55 + (global.darkzone * -55) + dmenu_arrow_yoffset, draw_y + side_arrows_mult[0], darrow_scale, -darrow_scale, 90, c_white, 1);
        }
        
        draw_set_halign(fa_left);
    }
    
    if (dbutton_layout == 2)
    {
        dmenu_arrow_yoffset = 2 * sin(dmenu_arrow_timer / 10);
        draw_set_color(c_yellow);
        draw_text(((xcenter - (string_length(string(dgiver_amount)) * 4)) * d) + xx, (ycenter * d) + yy, string(dgiver_amount));
        draw_set_color(c_white);
        var itemreminder = "";
        
        if (dgiver_menu_state == "objects")
        {
            itemreminder = "[" + string(dgiver_bname) + "]";
            
            if (dhorizontal_page == 0)
                scr_itemcheck(0);
            else
                scr_litemcheck(0);
            
            max_items = (dhorizontal_page == 0) ? 12 : 8;
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr("ITEMs: ", "OBJETs : ")) + string(max_items - itemcount) + " / " + string(max_items));
        }
        
        if (dgiver_menu_state == "armors")
        {
            itemreminder = "[" + string(dgiver_bname) + "]";
            scr_armorcheck_inventory(0);
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr("ARMORs: ", "ARMUREs : ")) + string(48 - itemcount) + " / 48");
        }
        
        if (dgiver_menu_state == "weapons")
        {
            itemreminder = "[" + string(dgiver_bname) + "]";
            scr_weaponcheck_inventory(0);
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr("WEAPONs: ", "ARMEs : ")) + string(48 - itemcount) + " / 48");
        }
        
        if (dgiver_menu_state == "keyitems")
        {
            itemreminder = "[" + string(dgiver_bname) + "]";
            scr_keyitemcheck(0);
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr("KEY ITEMs: ", "OBJETs CLÉs : ")) + string(12 - itemcount) + " / 12");
        }
        
        var text_width = string_width(itemreminder);
        draw_text(((xcenter * d) - (text_width / 2)) + xx, ((ycenter - 22) * d) + yy, itemreminder);
        darrow_scale = d / 2;
        draw_sprite_ext(spr_morearrow, 0, ((xcenter - 15) * d) + xx + dmenu_arrow_yoffset, ((ycenter + 6) * d) + yy, darrow_scale, darrow_scale, 270, c_white, 1);
        draw_sprite_ext(spr_morearrow, 0, (((xcenter + 15) * d) + xx) - dmenu_arrow_yoffset, ((ycenter + 12) * d) + yy, darrow_scale, darrow_scale, 90, c_white, 1);
    }
    
    if (dbutton_layout == 3)
    {
        var cur_btn = string(dbutton_options_2d[0][0]);
        var text_x = x_start + x_padding + xx;
        var text_y = y_start + yy;
        var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
        var max_width = box_right_edge - text_x;
        var line_spacing = 16 * d;
        var mono_spacing = (global.darkzone == 1) ? 15 : 8;
        var cursor_x = text_x;
        var line_count = 1;
        var current_word = "";
        var str_len = string_length(cur_btn);
        
        for (var i = 1; i <= str_len; i++)
        {
            var _char = string_char_at(cur_btn, i);
            
            if (_char != " " && _char != "\n")
                current_word += _char;
            
            if (_char == " " || _char == "\n" || i == str_len)
            {
                var _word_width = string_length(current_word) * mono_spacing;
                
                if (max_width > 0 && ((cursor_x + _word_width) - text_x) > max_width)
                {
                    if (cursor_x != text_x)
                    {
                        cursor_x = text_x;
                        line_count++;
                    }
                }
                
                for (var w = 1; w <= string_length(current_word); w++)
                {
                    if (max_width > 0 && ((cursor_x + mono_spacing) - text_x) > max_width)
                    {
                        cursor_x = text_x;
                        line_count++;
                    }
                    
                    cursor_x += mono_spacing;
                }
                
                current_word = "";
                
                if (_char == " ")
                {
                    cursor_x += mono_spacing;
                }
                else if (_char == "\n")
                {
                    cursor_x = text_x;
                    line_count++;
                }
            }
        }
        
        var extra_height = (line_count - 1) * line_spacing;
        var dynamic_bottom_y = text_y + (19 * d) + extra_height;
        var is_multiline = dmenu_box == 1;
        var buttons_y = yy + (is_multiline ? (185 * d) : (125 * d));
        
        for (var i = 0; i < array_length(dbutton_options_2d[1]); i++)
        {
            var bottom_btn_str = string(dbutton_options_2d[1][i]);
            var text_is_yellow = dvertical_index == 1 && dhorizontal_index == i;
            draw_set_color(text_is_yellow ? c_yellow : c_white);
            draw_text(x_start + (12 * power(10, i) * d) + xx, buttons_y, bottom_btn_str);
        }
        
        inputbox = function(arg0, arg1, arg2, arg3)
        {
            var border = 1 * d;
            draw_set_color((dvertical_index == 0 && !global.dreading_custom_flag) ? c_yellow : c_white);
            
            for (var i = 0; i < border; i++)
                draw_rectangle((arg0 - border) + i, (arg1 - border) + i, (arg2 + border) - i, (arg3 + border) - i, true);
        };
        
        inputbox(x_start + xx, text_y, box_right_edge, dynamic_bottom_y);
        var color = c_gray;
        
        if (dvertical_index == 0 && global.dreading_custom_flag)
            color = c_yellow;
        else if (dkeyboard_input != "")
            color = c_white;
        
        draw_set_color(color);
        draw_monospace_ext(text_x, text_y, cur_btn, line_spacing, max_width);
        var heartsprite = (d == 2) ? spr_heart : spr_heartsmall;
        
        if (dvertical_index != 0)
        {
            var heart_y = buttons_y + (5 * d);
            draw_sprite_ext(heartsprite, 0, x_start + (108 * dhorizontal_index * d) + xx, heart_y, 1, 1, 0, c_white, 1);
        }
    }
    
    dhinter_active = true;
    
    if (dhinter_active && dhinter_text != "" && (scr_array_contains(ditem_types, dmenu_state) || dmenu_state == "warp_options" || dmenu_state == "debug_save" || dmenu_state == "debug_save_options"))
    {
        draw_set_color(c_white);
        draw_rectangle(((xcenter - (menu_width / 2) - 3) * d) + xx, (2 * d) + yy, ((xcenter + (menu_width / 2) + 3) * d) + xx, (51 * d) + yy, false);
        draw_set_color(c_black);
        draw_rectangle(((xcenter - (menu_width / 2)) * d) + xx, (5 * d) + yy, ((xcenter + (menu_width / 2)) * d) + xx, (48 * d) + yy, false);
        draw_set_color(c_white);
        var x_start_desc = ((xcenter - (menu_width / 2)) + x_padding) * d;
        draw_text_ext(x_start_desc + xx, (10 * d) + yy, string(dhinter_text), 18 * d, (menu_width - (x_padding * 2)) * d);
    }
}

if (dkeys_helper == 1)
{
    dkeys_data = [string(dstr("F10 - Toggle debug mode", "F10 - Activer/désactiver le debug mode")), string(dstr("S - Save game", "S - Sauvegarder la partie")), string(dstr("L - Load last save", "L - Charger la dernière sauvegarde")), string(dstr("R - Reload room | Backspace+R - Restart game", "R - Charger la salle | Retour arrière+R - Redémarrer le jeu")), string(dstr("M+1 | M+2 - Add/remove 100 D$", "M+1 | M+2 - Ajouter/retirer 100 D$")), string(dstr("Delete - Go to previous room", "Suppr - Se rendre à la salle précédente")), string(dstr("Insert - Go to next room", "Insert - Se rendre à la salle suivante")), string(dstr("G - Toggle godmode", "G - Activer/désactiver le godmode")), string(dstr("W - Skip battle | Shift+W - Skip battle with recruit", "W - Passer un combat | Shift+W - Passer un combat avec recrue")), string(dstr("V - Skip enemy turn", "V - Passer le tour de l'ennemi")), string(dstr("H - Restore party HP", "H - Restaurer les HP du party")), string(dstr("T - Fill/empty TP bar", "T - Remplir/vider la barre de TP")), string(dstr("P -Set game to 1 FPS | Alt+P - Disable/restore bubble dialog autoskip", "P - Mettre le jeu à 1 FPS | Alt+P - Désactiver l'autoskip des bulles de combat")), string(dstr("O - Toggle 30, 60, 120 FPS", "O - Basculer entre 30, 60 et 120 FPS")), string(dstr("Backspace - Skip intro sequence (Ch1)", "Retour arrière - Passer le segment d'intro (Ch1)")), string(dstr("Middle Click - Room Editor", "Clic milieu - Éditeur de salle"))];
    
    menu_width = 264;
    menu_length = 204;
    xcenter = 160;
    ycenter = 120;
    x_padding = 14 * d;
    y_start = 50 * d;
    x_spacing = 10 * d;
    y_spacing = 10.5 * d;
    x_start = (((xcenter - (menu_width / 2))) * d) + x_padding;
    
    draw_set_color(c_white);
    draw_rectangle(((xcenter - (menu_width / 2) - 3) * d) + xx, ((ycenter - (menu_length / 2) - 3) * d) + yy, ((xcenter + (menu_width / 2) + 3) * d) + xx, ((ycenter + (menu_length / 2) + 3) * d) + yy, false);
    draw_set_color(c_black);
    draw_rectangle(((xcenter - (menu_width / 2)) * d) + xx, ((ycenter - (menu_length / 2)) * d) + yy, ((xcenter + (menu_width / 2)) * d) + xx, ((ycenter + (menu_length / 2)) * d) + yy, false);
    
    var text_scale = (global.darkzone == 1) ? 1 : 0.5;
    
    draw_set_font(fnt_mainbig);
    draw_set_halign(fa_right);
    draw_set_color(c_gray);
    var right_border = (xcenter + (menu_width / 2)) * d;
    var padding = 8 * d;
    var draw_x = (right_border + xx) - padding;
    var draw_y = (((ycenter - (menu_length / 2)) + 8) * d) + yy;
    
    draw_text_transformed(draw_x, draw_y, string(dstr("M - Close", "M - Fermer")), text_scale, text_scale, 0);
    
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    draw_text_transformed(x_start + xx, (((ycenter - (menu_length / 2)) + 8) * d) + yy, string(dstr("Debug Mode Keys", "Touches du debug mode")), text_scale, text_scale, 0);
    
    for (var i = 0; i < array_length(dkeys_data); i++)
    {
        draw_set_font(fnt_main);
        draw_set_color(c_white);
        
        draw_text_transformed(x_start + xx, y_start + yy + (i * y_spacing), string(dkeys_data[i]), text_scale, text_scale, 0);
    }
}

enum e__VW
{
    XView,
    YView,
    WView,
    HView,
    Angle,
    HBorder,
    VBorder,
    HSpeed,
    VSpeed,
    Object,
    Visible,
    XPort,
    YPort,
    WPort,
    HPort,
    Camera,
    SurfaceID
}