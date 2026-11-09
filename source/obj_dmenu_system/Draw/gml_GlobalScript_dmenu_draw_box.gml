function dmenu_draw_box(arg0, arg1, arg2, arg3, arg4=3)
{
	var xx = __view_get(e__VW.XView, 0) + 320;
	var yy = __view_get(e__VW.YView, 0) + 240;

	var x1 = arg0;
	var y1 = arg1;
	var x2 = arg2;
	var y2 = arg3;

	var box_shift = arg4;

	draw_set_color(c_white);
	draw_rectangle(
		x1 - box_shift, y1 - box_shift,
		x2 + box_shift, y2 + box_shift, false
	);

	draw_set_color(c_black);
	draw_rectangle(x1, y1, x2, y2, false);
}

function dmenu_draw_box_center(arg0, arg1)
{
	var width = arg0;
	var height = arg1;

	var half_width = width / 2;
	var half_height = height / 2;

	dmenu_draw_box(
		xcenter - half_width, ycenter - height,
		xcenter + half_width, ycenter + height
	);
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
