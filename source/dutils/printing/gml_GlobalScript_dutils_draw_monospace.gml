function dutils_draw_monospace_ext(arg0, arg1, arg2, arg3=0, arg4=-1)
{
    var _start_x = arg0;
    var _start_y = arg1;
    var _text = string(arg2);
    var _line_sep = arg3;
    var _max_width = arg4;
    var _char_sep = (global.darkzone == 1) ? 15 : 8;
    var _draw_x = _start_x;
    var _draw_y = _start_y;
    var _current_word = "";
    var _text_len = string_length(_text);
    
    for (var i = 1; i <= _text_len; i++)
    {
        var _char = string_char_at(_text, i);
        
        if (_char != " " && _char != "\n") {
            _current_word += _char;
			if (i != _text_len)
				continue;
		}
        
		var _word_width = string_length(_current_word) * _char_sep;
		
		if (_max_width > 0 && ((_draw_x + _word_width) - _start_x) > _max_width)
		{
			if (_draw_x != _start_x)
			{
				_draw_x = _start_x;
				_draw_y += _line_sep;
			}
		}
		
		for (var w = 1; w <= string_length(_current_word); w++)
		{
			if (_max_width > 0 && ((_draw_x + _char_sep) - _start_x) > _max_width)
			{
				_draw_x = _start_x;
				_draw_y += _line_sep;
			}
			
			draw_text(_draw_x, _draw_y, string_char_at(_current_word, w));
			_draw_x += _char_sep;
		}
		
		_current_word = "";
		
		if (_char == " ")
		{
			_draw_x += _char_sep;
		}
		else if (_char == "\n")
		{
			_draw_x = _start_x;
			_draw_y += _line_sep;
        }
    }
}

function dutils_draw_monospace(arg0, arg1, arg2)
{
	dutils_draw_monospace_ext(arg0, arg1, arg2, 0, -1);
}
