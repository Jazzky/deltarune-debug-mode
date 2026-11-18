function dmenu_draw_items_specific()
{
	var draw_y = title_y;
	var draw_x = xx + 640 - x_start - 15;

	draw_set_halign(fa_right);
	var _item_cat_text;
	var _side_text;
	var _side_text_x;

	if (dhorizontal_page == 0) {
		_item_cat_text = "(Darkworld)"
		_side_text = "</rarrow/>";
		_side_text_x = draw_x;
	}
	else {
		_item_cat_text = "(Lightworld)";
		_side_text = "</larrow/>";
		_side_text_x = draw_x - string_width(_item_cat_text) - 15;
	}

	draw_text(draw_x, draw_y, _item_cat_text);
	dmenu_draw_text(_side_text_x, draw_y, _side_text);
	draw_set_halign(fa_left);
}
