if (!dconsole_active)
    exit;

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, display_get_gui_width(), dconsole_height, false);
draw_set_color(c_dkgray);
draw_set_alpha(1);
draw_line(0, dconsole_height, display_get_gui_width(), dconsole_height);
draw_set_font(fnt_dotumche);
var _text_y = dconsole_height - 30;

var _prefix = "> ";
var _prefix_width = string_width(_prefix);

draw_text(15, _text_y, _prefix);
dutils_draw_kbtext(15 + _prefix_width + 2, _text_y, draw_blink);


var _max_width = display_get_gui_width() - 30;
var _line_spacing = string_height("A") + 6;
var _log_spacing = 10;
var _history_count = array_length(dconsole_log);
var _total_h = 0;
var _visible_from_top = 0;
var _available_height = dconsole_height - 40 - 10;

for (var _k = 0; _k < _history_count; _k++)
{
    var _log_str = dconsole_log[_k];
    var _pw = 0;
    var _text = _log_str;
    
    if (string_copy(_log_str, 1, 5) == "  -> ")
    {
        _pw = string_width("  -> ");
        _text = string_delete(_log_str, 1, 5);
    }
    else if (string_copy(_log_str, 1, string_length(dconsole_prefix)) == dconsole_prefix)
    {
        _pw = string_width(dconsole_prefix);
        _text = string_delete(_log_str, 1, string_length(dconsole_prefix));
    }
    
    var _entry_h = string_height_ext(_text, _line_spacing, _max_width - _pw);
    _total_h += (_entry_h + _log_spacing);
    _visible_from_top++;
    
    if (_total_h > _available_height)
        break;
}

var _max_scroll = max(0, _history_count - _visible_from_top);

if (_total_h <= _available_height)
    _max_scroll = 0;

dconsole_scroll = min(dconsole_scroll, _max_scroll);
var _baseline_bottom = dconsole_height - 40;
var _draw_y = _baseline_bottom;
var _i = _history_count - 1 - floor(dconsole_scroll);

while (_i >= 0)
{
    var _log_str = dconsole_log[_i];
    var _prefix = "";
    var _text = _log_str;
    
    if (string_copy(_log_str, 1, 5) == "  -> ")
    {
        _prefix = "  -> ";
        _text = string_delete(_log_str, 1, 5);
    }
    else if (string_copy(_log_str, 1, string_length(dconsole_prefix)) == dconsole_prefix)
    {
        _prefix = dconsole_prefix;
        _text = string_delete(_log_str, 1, string_length(dconsole_prefix));
    }
    
    var _px = 15;
    var _pw = string_width(_prefix);
    var _rem_width = _max_width - _pw;
    var _entry_height = string_height_ext(_text, _line_spacing, _rem_width);
    _draw_y -= _entry_height;
    
    if (_draw_y < 10)
        break;
    
    draw_text(_px, _draw_y, _prefix);
    draw_text_ext(_px + _pw, _draw_y, _text, _line_spacing, _rem_width);
    _draw_y -= _log_spacing;
    _i--;
}
