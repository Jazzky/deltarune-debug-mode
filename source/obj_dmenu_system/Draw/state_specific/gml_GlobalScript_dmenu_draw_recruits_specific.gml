function dmenu_draw_recruits_specific()
{
	var draw_y = title_y;
	var draw_x = x_start + (200 * d) + xx;

	draw_set_halign(fa_right);
	var _chap_text = "(chap " + string(dhorizontal_page) + ")";
	if (dhorizontal_page == 0)
		_chap_text = dstr("(all chap)", "(tout chap)");

	draw_text(draw_x, draw_y, _chap_text);
	draw_set_halign(fa_left);
}
