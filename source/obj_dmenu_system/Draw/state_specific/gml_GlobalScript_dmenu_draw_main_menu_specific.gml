function dmenu_draw_main_menu_specific()
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
	
	draw_set_font((global.darkzone) ? fnt_mainbig : fnt_main);
	draw_set_halign(fa_left);
}
