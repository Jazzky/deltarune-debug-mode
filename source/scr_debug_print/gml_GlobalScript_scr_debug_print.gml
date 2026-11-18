function scr_debug_print(arg0, arg1 = false)
{
    if (global.debug == 0 && !arg1)
    {
        exit;
    }

    if (!instance_exists(obj_debug_gui))
    {
        instance_create(__view_get(e__VW.XView, 0) + 10, __view_get(e__VW.YView, 0) + 10, obj_debug_gui);
        obj_debug_gui.depth = -99999;
    }
    
    obj_debug_gui.newtext = string(arg0);
    
    with (obj_debug_gui)
    {
        message[messagecount] = newtext;
        newtext = "";
        timer[messagecount] = 90 - totaltimer;
        totaltimer += timer[messagecount];
        messagecount++;
        debugmessage = message[0];
        
        for (i = 1; i < messagecount; i++)
            debugmessage += ("#" + message[i]);
    }
}

function scr_derror_print(arg0)
{
	if (global.dprint_errors == false)
		exit;

	scr_debug_print(arg0);
}

function print_message(arg0)
{
    scr_debug_print(arg0);
}

function debug_print(arg0)
{
    scr_debug_print(arg0);
}

function scr_debug_clear_all()
{
    scr_debug_clear_persistent();
}

function set_derror_print(arg0=undefined)
{
	if (arg0 == undefined)
		global.dprint_errors = !global.dprint_errors;
	else
		global.dprint_errors = arg0;
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
