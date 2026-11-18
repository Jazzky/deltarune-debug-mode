function dmenu_draw_menu_sprite(arg0, arg1)
{
	var sprite_id = arg0;
	var _xpos = arg1;
	var valid = true;

	var mono_spacing = (global.darkzone == 1) ? 15 : 8;
	var dx = _draw_x + (_xpos * mono_spacing);
	var dy = _draw_y;

	var spr = undefined;
	var spr_frame = 0;
	var spr_angle = 0;
	var xscale = 1;
	var yscale = 1;
	var spr_alpha = 1;
	var timing = global.time;

	switch (sprite_id)
	{
		case "larrow":
		case "rarrow":
			var _left = (sprite_id == "larrow");

			var side_arrows_mult = (global.darkzone) ? [23, 10] : [12, 5];
			var _arrow_scale = (global.darkzone) ? 1 : 0.5;

			spr = spr_morearrow;
			dx += floor(mono_spacing / 2) + (2 * sin(timing / 10));
			dy += side_arrows_mult[_left];
			xscale = _arrow_scale;
			yscale = _arrow_scale;
			spr_angle = (_left) ? 270 : 90;
			break;

		default:
			valid = false;
			break;
	}

	if (!valid)
		return (false);

	draw_sprite_ext(
		spr, spr_frame,
		dx, dy, xscale, yscale,
		spr_angle, c_white, spr_alpha
	);

	return (true);
}

function dmenu_draw_sprite_tags(arg0="")
{
	var str = arg0;

	var spr_tag_start = "</";
	var spr_tag_end = "/>";

	var tag_start_len = string_length(spr_tag_start);
	var tag_end_len = string_length(spr_tag_end);

	var ret_string = "";
	var ret_string_pos = 0;
	var slen = string_length(str);
	for (var i = 1; i <= slen; i++)
	{
		var mychar = string_char_at(str, i);

		if (!dutils_strstarts_with(str, spr_tag_start, i - 1)) {
			ret_string += mychar;
			ret_string_pos++;
			continue;
		}

		i += tag_start_len;
		var _temp_word = "";
		var _break_save = false;
		for (var j = i; j <= slen; j++)
		{
			var _lookup_char = string_char_at(str, j);

			if (dutils_strstarts_with(str, spr_tag_start, j - 1) || (j == slen))
				_break_save = true;

			else if (dutils_strstarts_with(str, spr_tag_end, j - 1)) {
				i = j + tag_end_len - 1;
				var valid_sprite = dmenu_draw_menu_sprite(_temp_word, ret_string_pos);

				if (valid_sprite)
					break;

				_break_save = true;
			}
			
			if (_break_save)
			{
				ret_string += spr_tag_start;
				ret_string += _temp_word;
				ret_string_pos += (j - i);
				i = j - 1;
				break;
			}

			_temp_word += _lookup_char;
		}
	}
	return (ret_string);
}
