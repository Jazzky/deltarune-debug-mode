if (!dmenu_active)
	exit;


xx = __view_get(e__VW.XView, 0);
yy = __view_get(e__VW.YView, 0);
d = global.darkzone + 1;

var dmenu_arrow_timer = global.time;
var mono_spacing = (global.darkzone == 1) ? 15 : 8;
var reading_kb = dutils_reading_kb();

if (dmenu_box == 0)
{
    menu_width = 214;
    menu_height = 94;
    xcenter = 160;
    ycenter = 105;
}

if (dmenu_box == 1)
{
    menu_width = 214;
    menu_height = 154;
    xcenter = 160;
    ycenter = 135;
}

if (dmenu_box == 2)
{
    menu_width = 256;
    menu_height = 154;
    xcenter = 160;
    ycenter = 135;
}

x_padding = 7 * d;
x_start = ((xcenter - (menu_width / 2)) * d) + x_padding;
y_start = 95 * d;

x_spacing = 10 * d;
y_spacing = 10 * d;

if (dbutton_layout == 0)
{
    y_start = 100 * d;
}

if (dbutton_layout == 1)
{
    y_spacing = 20 * d;
}

if (dbutton_layout == 2)
{
}

if (dbutton_layout == 3)
{
}


function dmenu_draw_text(arg0, arg1, arg2)
{
	_draw_x = arg0;
	_draw_y = arg1;
	var str = arg2;

	var _text = dmenu_draw_sprite_tags(str);
	dutils_draw_monospace(_draw_x, _draw_y, _text);
}


button_count = array_length(dbuttons);

draw_set_color(c_white);
draw_rectangle(((xcenter - (menu_width / 2) - 3) * d) + xx, ((ycenter - (menu_height / 2) - 3) * d) + yy, ((xcenter + (menu_width / 2) + 3) * d) + xx, ((ycenter + (menu_height / 2) + 3) * d) + yy, false);
draw_set_color(c_black);
draw_rectangle(((xcenter - (menu_width / 2)) * d) + xx, ((ycenter - (menu_height / 2)) * d) + yy, ((xcenter + (menu_width / 2)) * d) + xx, ((ycenter + (menu_height / 2)) * d) + yy, false);


var myfnt = (global.darkzone) ? fnt_mainbig : fnt_main;
draw_set_font(myfnt);
draw_set_color(c_white);

draw_text(x_start + xx, (((ycenter - (menu_height / 2)) + 8) * d) + yy, string(dmenu_title));

if (dmenu_state == "debug")
{
	draw_set_halign(fa_right);
	draw_set_font(fnt_main);
	var text_scale = (global.darkzone == 1) ? 1 : 0.5;
	draw_set_color(c_gray);
	
	var key_text = string(dstr("M - Keys", "M - Touches"));
	var lang_text = string(dstr("F - French", "F - Anglais"));
	
	var draw_x = (((xcenter + (menu_width / 2)) - 10) * d) + xx;
	var key_draw_y = (((ycenter + (menu_height / 2)) - 15) * d) + yy;
	var lang_draw_y = (((ycenter - (menu_height / 2)) + 8) * d) + yy;
	
	draw_text_transformed(draw_x, key_draw_y, key_text, text_scale, text_scale, 0);
	draw_text_transformed(draw_x, lang_draw_y, lang_text, text_scale, text_scale, 0);
	
	draw_set_font(myfnt);
	draw_set_halign(fa_left);
}

if (reading_kb)
{
	draw_set_halign(fa_right);
	draw_set_color(c_gray);
	var right_border = (xcenter + (menu_width / 2)) * d;
	var padding = 8 * d;
	var draw_x = (right_border + xx) - padding;
	var draw_y = (((ycenter - (menu_height / 2)) + 8) * d) + yy;
	draw_text(draw_x, draw_y, string(dstr("Esc - Cancel", "Esc - Annuler")));
	draw_set_halign(fa_left);
}

if (reading_kb)
{
	var base_x = x_start + xx;
	var base_y = y_start + yy + ((dmenu_start_index + 1) * y_spacing) - 10;
	var thickness = 1 * d;
	var cursor_padding = 3 * d;

	var prefix_len = cur_btn.data;
	var w_prefix = prefix_len * mono_spacing;

	var ipt_text = dkeyboard_texts[dhorizontal_index];
	var w_input = string_length(ipt_text) * mono_spacing;

	var left_x = base_x + w_prefix;
	var right_x = left_x + w_input;

	draw_set_color(c_yellow);
	draw_rectangle(left_x - cursor_padding, base_y, right_x + cursor_padding, base_y + thickness, false);
}

if (dbutton_layout == 0)
{
	var draw_y = y_start;
	
	for (var j = 0; j < array_length(dbuttons_2d); j++)
	{
		var draw_x = x_start + xx;
		
		for (var i = 0; i < array_length(dbuttons_2d[j]); i++)
		{
			var cur_text = string(dbuttons_2d[j][i].text);
			var text_width = string_width(cur_text);

			if (dvertical_index != j || dhorizontal_index != i)
				draw_set_color(c_white);
			else
				draw_set_color(c_yellow);

			draw_text(draw_x, draw_y, cur_text);
			draw_x += (text_width + x_spacing);
		}
		draw_y += 15 * d;
	}
}

if (dbutton_layout == 1)
{
	var option_start_index = dvertical_index - abs(dmenu_start_index);
	var nb_option_to_draw = min(dbutton_max_visible, button_count);

	var dmenu_arrow_yoffset = 2 * sin(dmenu_arrow_timer / 10);
	var darrow_scale = d / 2;
	
	var _dx = xx + x_start;
	var _dy = yy + y_start;

	var dcan_scroll_up = (option_start_index > 0);
	if (dcan_scroll_up)
	{
		var _yoffset = (dbutton_max_visible * (y_spacing * -0.03));
		draw_sprite_ext(spr_morearrow, 0, _dx, _dy + _yoffset + dmenu_arrow_yoffset, darrow_scale, -darrow_scale, 0, c_white, 1);
	}
	

	for (var i = 0; i < nb_option_to_draw; i++)
	{
		var button_index = option_start_index + i;
		if (button_index < 0 || button_index >= button_count)
			continue;
		
		is_cur_line = dvertical_index == button_index;
		var text_color = is_cur_line ? c_yellow : c_white;
		draw_set_color(text_color);

		dmenu_draw_text(_dx, _dy, dbuttons[button_index].text);
		_dy += y_spacing;
	}
	
	var dcan_scroll_down = ((option_start_index + nb_option_to_draw) != button_count);
	if (dcan_scroll_down)
	{
		draw_sprite_ext(spr_morearrow, 0, _dx, _dy - dmenu_arrow_yoffset, darrow_scale, darrow_scale, 0, c_white, 1);
	}
}

if (dmenu_state == "recruits" || dmenu_parent_state == "item")
{
	draw_set_halign(fa_right);
	var draw_y = (((ycenter - (menu_height / 2)) + 8) * d) + yy;
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
	draw_text(((xcenter - (string_length(string(dhorizontal_index)) * 4)) * d) + xx, (ycenter * d) + yy, string(dhorizontal_index));
	draw_set_color(c_white);
	var itemreminder = "";
	
	var given_id = dgiver_infos.item_id;
	var given_name = dgiver_infos.item_name;
	var given_type = dgiver_infos.item_type;

	var itemreminder = "[" + string(given_name) + "]";
	var item_cate_name;
	var limit = dutils_get_storage_space(given_type);
	switch (given_type)
	{
		case "items":
			item_cate_name = dstr("ITEMs: ", "OBJETs : ");
			break;

		case "armors":
			item_cate_name = dstr("ARMORs: ", "ARMUREs : ");
			break;

		case "weapons":
			item_cate_name = dstr("WEAPONs: ", "ARMEs : ");
			break;

		case "keyitems":
			item_cate_name = dstr("KEY ITEMs: ", "OBJETs CLÉs : ");
			break;
	}

	draw_text(x_start + xx, ((ycenter + 25) * d) + yy, item_cate_name + string(limit - dgiver_infos.storage_space) + " / " + string(limit));

	var text_width = string_width(itemreminder);
	draw_text(((xcenter * d) - (text_width / 2)) + xx, ((ycenter - 22) * d) + yy, itemreminder);
	darrow_scale = d / 2;
	draw_sprite_ext(spr_morearrow, 0, ((xcenter - 15) * d) + xx + dmenu_arrow_yoffset, ((ycenter + 6) * d) + yy, darrow_scale, darrow_scale, 270, c_white, 1);
	draw_sprite_ext(spr_morearrow, 0, (((xcenter + 15) * d) + xx) - dmenu_arrow_yoffset, ((ycenter + 12) * d) + yy, darrow_scale, darrow_scale, 90, c_white, 1);
}

if (dbutton_layout == 3)
{
	var cur_text = string(dbuttons_2d[0][0].text);
	var text_x = x_start + x_padding + xx;
	var text_y = y_start + yy;
	var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
	var max_width = box_right_edge - text_x;
	var line_spacing = 16 * d;
	var cursor_x = text_x;
	var line_count = 1;
	var current_word = "";
	var str_len = string_length(cur_text);
	
	for (var i = 1; i <= str_len; i++)
	{
		var _char = string_char_at(cur_text, i);
		
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
	
	for (var i = 0; i < array_length(dbuttons_2d[1]); i++)
	{
		var bottom_btn_str = string(dbuttons_2d[1][i].text);
		var text_is_yellow = dvertical_index == 1 && dhorizontal_index == i;
		draw_set_color(text_is_yellow ? c_yellow : c_white);
		draw_text(x_start + (12 * power(10, i) * d) + xx, buttons_y, bottom_btn_str);
	}
	
	inputbox = function(arg0, arg1, arg2, arg3)
	{
		var border = 1 * d;
		draw_set_color((dvertical_index == 0 && !dutils_reading_kb()) ? c_yellow : c_white);
		
		for (var i = 0; i < border; i++)
			draw_rectangle((arg0 - border) + i, (arg1 - border) + i, (arg2 + border) - i, (arg3 + border) - i, true);
	};
	
	inputbox(x_start + xx, text_y, box_right_edge, dynamic_bottom_y);
	var color = c_gray;
        
	if (dvertical_index == 0 && reading_kb)
		color = c_yellow;
	else if (dkeyboard_texts[0] != "")
		color = c_white;
	
	draw_set_color(color);
	dutils_draw_monospace_ext(text_x, text_y, cur_text, line_spacing, max_width);
	var heartsprite = (d == 2) ? spr_heart : spr_heartsmall;
	
	if (dvertical_index != 0)
	{
		var heart_y = buttons_y + (5 * d);
		draw_sprite_ext(heartsprite, 0, x_start + (108 * dhorizontal_index * d) + xx, heart_y, 1, 1, 0, c_white, 1);
	}
}
    
if (dhinter_text != "")
{
	draw_set_color(c_white);
	draw_rectangle(((xcenter - (menu_width / 2) - 3) * d) + xx, (2 * d) + yy, ((xcenter + (menu_width / 2) + 3) * d) + xx, (51 * d) + yy, false);
	draw_set_color(c_black);
	draw_rectangle(((xcenter - (menu_width / 2)) * d) + xx, (5 * d) + yy, ((xcenter + (menu_width / 2)) * d) + xx, (48 * d) + yy, false);
	draw_set_color(c_white);
	var x_start_desc = ((xcenter - (menu_width / 2)) + x_padding) * d;
	draw_text_ext(x_start_desc + xx, (10 * d) + yy, string(dhinter_text), 18 * d, (menu_width - (x_padding * 2)) * d);
}

if (dkeys_helper == 1)
	dmenu_draw_key_helper();

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
