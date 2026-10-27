EnsureDataLoaded();

if (!Data.IsVersionAtLeast(2023, 6))
{
    ScriptError("Erreur 0 : Ce script fonctionne uniquement pour la version payante de Deltarune.");
    return;
}

if (Data?.GeneralInfo?.DisplayName?.Content.ToLower() != "deltarune chapter 2" &&
    Data?.GeneralInfo?.DisplayName?.Content.ToLower() != "deltarune chapitre 2")
{
    ScriptError("Erreur 1 : Ce script s'applique seulement au Chapitre 2.");
    return;
}

bool isFrenchPatch = false;
foreach (var str in Data.Strings)
{
    if (str.Content == "Français")
    {
        isFrenchPatch = true;
        break;
    }
}
string defaultLang = isFrenchPatch ? "fr" : "en";

GlobalDecompileContext globalDecompileContext = new(Data);
Underanalyzer.Decompiler.IDecompileSettings decompilerSettings = new Underanalyzer.Decompiler.DecompileSettings();
UndertaleModLib.Compiler.CodeImportGroup importGroup = new(Data, globalDecompileContext, decompilerSettings)
{
    ThrowOnNoOpFindReplace = true
};

// --- COMMON CODE ---


UndertaleScript scr_gamestart = Data.Scripts.ByName("scr_gamestart");
importGroup.QueueAppend("gml_GlobalScript_scr_gamestart",
@"global.debug = 0;
global.dgodmode = 0;
global.debug_save_name = -1;
global.debug_saving = 0;
global.dkeyboard_text = """";
global.dlang = ""en"";
global.dpause_dialog = 0;
");


UndertaleScript scr_debug_print = Data.Scripts.ByName("scr_debug_print");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_print",
@"function scr_debug_print(arg0, arg1 = false)
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
        newtext = """";
        timer[messagecount] = 90 - totaltimer;
        totaltimer += timer[messagecount];
        messagecount++;
        debugmessage = message[0];
        
        for (i = 1; i < messagecount; i++)
            debugmessage += (""#"" + message[i]);
    }
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
}");


UndertaleScript scr_debug_print_persistent = Data.Scripts.ByName("scr_debug_print_persistent");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_print_persistent",
@"function scr_debug_print_persistent(arg0, arg1)
{
    if (!scr_debug())
        exit;
    
    if (!instance_exists(obj_debug_gui_persistent))
    {
        instance_create(__view_get(e__VW.XView, 0) + 10, __view_get(e__VW.YView, 0) + 10, obj_debug_gui_persistent);
        obj_debug_gui_persistent.depth = -9999;
    }
    
    var search_key = string(arg0) + "":"";
    var final_text = string(arg0) + "": "" + string(arg1);
    
    with (obj_debug_gui_persistent)
    {
        var found = false;
        
        for (i = 0; i < messagecount; i++)
        {
            if (string_pos(search_key, message[i]) == 1)
            {
                message[i] = final_text;
                messagetimer[i] = 10;
                found = true;
                break;
            }
        }
        
        if (!found)
        {
            message[messagecount] = final_text;
            messagetimer[messagecount] = 10;
            messagecount++;
        }
        
        debugmessage = message[0];
        
        for (i = 1; i < messagecount; i++)
            debugmessage += (""#"" + message[i]);
    }
}

function debug_print_bitmask_persistent(arg0, arg1, arg2)
{
}

function debug_print_persistent(arg0, arg1)
{
    scr_debug_print_persistent(arg0, arg1);
}

function scr_debug_delete_persistent(arg0, arg1 = false)
{
    if (!instance_exists(obj_debug_gui_persistent))
        exit;
    
    var search_key = string(arg0) + "":"";
    
    with (obj_debug_gui_persistent)
    {
        var found_index = -1;
        
        for (i = 0; i < messagecount; i++)
        {
            if (string_pos(search_key, message[i]) == 1)
            {
                found_index = i;
                break;
            }
        }
        
        if (found_index != -1)
        {
            for (i = found_index; i < (messagecount - 1); i++)
            {
                message[i] = message[i + 1];
                messagetimer[i] = messagetimer[i + 1];
            }
            
            messagecount--;
            
            if (messagecount <= 0)
            {
                debugmessage = """";
                instance_destroy();
            }
            else
            {
                debugmessage = message[0];
                
                for (i = 1; i < messagecount; i++)
                    debugmessage += (""#"" + message[i]);
            }
        }
    }
}

function scr_debug_clear_persistent()
{
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
}");


UndertaleGameObject obj_debug_gui = Data.GameObjects.ByName("obj_debug_gui");
importGroup.QueueReplace(obj_debug_gui.EventHandlerFor(EventType.Create, (uint)0, Data),
@"message[0] = """";
debugmessage = """";
timer[0] = 90;
newtext = """";
messagecount = 0;
totaltimer = 0;");


importGroup.QueueReplace(obj_debug_gui.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (timer[0] > 0)
{
    timer[0]--;
    totaltimer--;
}

if (timer[0] <= 0)
{
    messagecount--;
    
    if (messagecount <= 0)
    {
        instance_destroy();
    }
    else
    {
        for (i = 0; i < messagecount; i++)
        {
            message[i] = message[i + 1];
            timer[i] = timer[i + 1];
        }
        
        message[messagecount] = """";
        timer[messagecount] = 0;
        debugmessage = message[0];
        
        for (i = 1; i < messagecount; i++)
            debugmessage += (""#"" + message[i]);
    }
}");


importGroup.QueueReplace(obj_debug_gui.EventHandlerFor(EventType.Draw, (uint)64, Data),
@"var fnt = draw_get_font();
draw_set_font(fnt_comicsans);
var col = draw_get_color();
draw_set_color(c_black);
draw_text_transformed(7, 7, string_hash_to_newline(debugmessage), 1, 1, 0);
draw_text_transformed(9, 7, string_hash_to_newline(debugmessage), 1, 1, 0);
draw_text_transformed(9, 9, string_hash_to_newline(debugmessage), 1, 1, 0);
draw_text_transformed(7, 9, string_hash_to_newline(debugmessage), 1, 1, 0);
draw_set_color(c_red);
draw_text_transformed(8, 8, string_hash_to_newline(debugmessage), 1, 1, 0);
draw_set_color(col);
draw_set_font(fnt);");


importGroup.QueueReplace(obj_debug_gui.EventHandlerFor(EventType.CleanUp, (uint)0, Data),
@"event_inherited();");


UndertaleGameObject obj_debug_gui_persistent = new UndertaleGameObject();
obj_debug_gui_persistent.Name = Data.Strings.MakeString("obj_debug_gui_persistent");
obj_debug_gui_persistent.Visible = true;
obj_debug_gui_persistent.Persistent = true;
obj_debug_gui_persistent.Awake = true;
Data.GameObjects.Add(obj_debug_gui_persistent);

importGroup.QueueReplace(obj_debug_gui_persistent.EventHandlerFor(EventType.Create, (uint)0, Data),
@"message[0] = """";
debugmessage = """";
newtext = """";
messagecount = 0;");


importGroup.QueueReplace(obj_debug_gui_persistent.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (messagecount <= 0)
{
    instance_destroy();
}
else
{
    var _rebuild = false;
    i = messagecount - 1;
    
    while (i >= 0)
    {
        messagetimer[i]--;
        
        if (messagetimer[i] <= 0)
        {
            for (var j = i; j < (messagecount - 1); j++)
            {
                message[j] = message[j + 1];
                messagetimer[j] = messagetimer[j + 1];
            }
            
            messagecount--;
            _rebuild = true;
        }
        
        i--;
    }
    
    if (messagecount <= 0)
    {
        instance_destroy();
        exit;
    }
    
    if (_rebuild)
    {
        debugmessage = message[0];
        
        for (i = 1; i < messagecount; i++)
            debugmessage += (""#"" + message[i]);
    }
}");


importGroup.QueueReplace(obj_debug_gui_persistent.EventHandlerFor(EventType.Draw, (uint)64, Data),
@"var fnt = draw_get_font();
draw_set_font(fnt_comicsans);
var col = draw_get_color();
draw_set_halign(fa_right);
draw_set_color(c_black);
draw_text_transformed(631, 40, string_hash_to_newline(debugmessage), 0.5, 0.5, 0);
draw_set_color(c_red);
draw_text_transformed(630, 39, string_hash_to_newline(debugmessage), 0.5, 0.5, 0);
draw_set_halign(fa_left);
draw_set_color(col);
draw_set_font(fnt);");


UndertaleGameObject obj_debug_xy = Data.GameObjects.ByName("obj_debug_xy");
importGroup.QueueReplace(obj_debug_xy.EventHandlerFor(EventType.Create, (uint)0, Data),
@"if (instance_number(object_index) > 1)
    instance_destroy();

selected_object = -4;
mouse_held = 0;
mouse_held_r = 0;
siner = 0;
show_invisible = 0;
show_all_object_xy = 0;
xy_camera_relative = 0;
actor_debug_x = 0;
actor_debug_y = 0;
actor_debug_xstart = 0;
actor_debug_ystart = 0;
gridsize = 20;

if (global.darkzone == 0)
    gridsize = 10;

main_focus = 1;
mousebuffer = 3;
copybuffer = 0;
totalstring = "" "";
actor_selected_before = 0;
actor_previously_selected = -1;
panremx = camerax();
panremy = cameray();
enable_mouse_wheel = 0;
old_right_click = 0;");


importGroup.QueueReplace(obj_debug_xy.EventHandlerFor(EventType.Draw, (uint)0, Data),
@"x = round(mouse_x);
y = round(mouse_y);
_old_x = x;
_old_y = y;
siner++;
mousebuffer--;
main_focus = 1;

if (i_ex(obj_debug_windows))
    main_focus = 0;

if (main_focus)
{
    if (mouse_check_button_pressed(mb_left) && mousebuffer < 0)
    {
        mouse_held = 0;
        obj_check = collision_rectangle(x - 2, y - 2, x + 2, y + 2, all, 0, 1);
        
        if (obj_check != -4)
        {
            visiblecheck = 0;
            
            if (show_invisible == 1)
                visiblecheck = 1;
            else if (obj_check.visible == true)
                visiblecheck = 1;
            
            if (visiblecheck == 1 && obj_check.image_alpha > 0)
            {
                selected_object = obj_check;
                selected_object.is_debug_copy = true;
            }
        }
        else
        {
            selected_object = -898;
        }
        
        if (instance_exists(obj_actor))
        {
            obj_check = collision_rectangle(x - 2, y - 2, x + 2, y + 2, obj_actor, 0, 1);
            
            if (obj_check != -4)
            {
                visiblecheck = 0;
                
                if (show_invisible == 1)
                    visiblecheck = 1;
                else if (obj_check.visible == true)
                    visiblecheck = 1;
                
                if (visiblecheck == 1 && obj_check.image_alpha > 0)
                {
                    selected_object = obj_check;
                    selected_object.is_debug_copy = true;
                }
            }
        }
    }
}

if (main_focus)
{
    if (mouse_check_button(mb_left) && i_ex(selected_object))
    {
        mouse_held++;
        mouse_held_minimum = 5;
        
        if (selected_object.object_index == obj_actor)
            mouse_held_minimum = 15;
        
        if (mouse_held >= mouse_held_minimum && i_ex(selected_object))
        {
            selected_object.x = x - (selected_object.sprite_width / 2);
            selected_object.y = y - (selected_object.sprite_height / 2);
            
            if (selected_object.x != _old_x || selected_object.y != _old_y)
            {
                with (selected_object)
                {
                    if (variable_instance_exists(id, ""is_debug_copy""))
                        scr_depth();
                }
            }
        }
    }
    else if (mouse_check_button_pressed(mb_left))
    {
        mouse_held = 0;
    }
}

if (keyboard_check_pressed(vk_pagedown))
{
    if (show_all_object_xy == 1)
        show_all_object_xy = 0;
    else
        show_all_object_xy = 1;
    
    mouse_held = 0;
}

if (i_ex(selected_object) && !keyboard_check(ord(""P"")))
{
    if (selected_object.sprite_index != -1)
    {
        os = selected_object;
        var _moved = false;
        
        if (keyboard_check(vk_up))
        {
            os.y -= 1;
            _moved = true;
        }
        
        if (keyboard_check(vk_left))
        {
            os.x -= 1;
            _moved = true;
        }
        
        if (keyboard_check(vk_down))
        {
            os.y += 1;
            _moved = true;
        }
        
        if (keyboard_check(vk_right))
        {
            os.x += 1;
            _moved = true;
        }
        
        if (_moved)
        {
            os.is_debug_copy = true;
            
            with (os.object_index)
            {
                if (variable_instance_exists(id, ""is_debug_copy""))
                    scr_depth();
            }
        }
        
        draw_sprite_ext_flash(os.sprite_index, os.image_index, os.x, os.y, os.image_xscale, os.image_yscale, os.image_angle, os.image_blend, (sin(siner / 8) * 0.5) + 0.5);
    }
}

if (keyboard_check_pressed(vk_pageup))
{
    xy_camera_relative++;
    
    if (xy_camera_relative >= 3)
        xy_camera_relative = 0;
}

if (keyboard_check_pressed(vk_delete))
{
    if (i_ex(selected_object))
    {
        with (selected_object)
            instance_destroy();
        
        selected_object = -999;
    }
}

if (keyboard_check_pressed(ord(""V"")))
{
    if (show_invisible == 0)
        show_invisible = 1;
    else
        show_invisible = 0;
}

if (siner >= 5 && mouse_check_button_pressed(mb_middle))
{
    instance_destroy();
    
    with (obj_debug_windows)
        instance_destroy();
}

if (show_all_object_xy == 1)
{
    for (i = 0; i < instance_count; i++)
    {
        findo = instance_id_get(i);
        
        if (i_ex(findo))
        {
            visiblecheck = 0;
            
            if (show_invisible == 1)
                visiblecheck = 1;
            else if (findo.visible == true)
                visiblecheck = 1;
            
            if (visiblecheck == 1 && findo.sprite_index != -1)
            {
                fox = findo.x;
                foy = findo.y;
                
                if (xy_camera_relative == 1)
                {
                    fox -= __view_get(e__VW.XView, 0);
                    foy -= __view_get(e__VW.YView, 0);
                }
                
                if (xy_camera_relative == 2)
                {
                    fox -= findo.xstart;
                    foy -= findo.ystart;
                }
                
                draw_info = 1;
                
                if (findo.object_index == object_index)
                    draw_info = 0;
                
                if (findo.object_index == obj_overworldheart)
                    draw_info = 0;
                
                if (findo.object_index == obj_grazebox)
                    draw_info = 0;
                
                if (draw_info == 1)
                {
                    draw_set_color(c_black);
                    draw_rectangle(findo.x - 4, findo.y - 32, findo.x + 80, findo.y, false);
                    draw_set_font(fnt_main);
                    draw_set_color(c_aqua);
                    draw_text(findo.x, findo.y - 32, string_hash_to_newline(object_get_name(findo.object_index)));
                    draw_text(findo.x, findo.y - 16, string_hash_to_newline(string(fox) + "" , "" + string(foy)));
                    draw_set_color(c_red);
                    draw_rectangle(findo.bbox_left, findo.bbox_top, findo.bbox_right, findo.bbox_bottom, true);
                }
            }
        }
    }
}

if (show_all_object_xy == 1)
{
    fox = x;
    foy = y;
    
    if (xy_camera_relative == 1)
    {
        fox -= __view_get(e__VW.XView, 0);
        foy -= __view_get(e__VW.YView, 0);
    }
    
    if (xy_camera_relative == 2)
    {
        fox -= xstart;
        foy -= ystart;
    }
    
    draw_set_color(c_black);
    draw_rectangle(x - 4, y - 24, x + 60, y, false);
    draw_set_color(c_fuchsia);
    draw_text(x, y - 20, string_hash_to_newline(string(fox) + "" , "" + string(foy)));
}

draw_set_color(c_black);
draw_line_width(x + 16, y + 16, x + 2, y + 2, 5);
draw_set_color(c_white);
draw_line_width(x + 12, y + 12, x + 3, y + 3, 4);
draw_set_color(make_color_hsv(siner * 6, 255, 255));
draw_line_width(x + 7, y + 7, x + 3, y + 3, 3);
old_right_click = 0;

if (!old_right_click)
{
    if (mouse_check_button_pressed(mb_right))
    {
        main_focus = 0;
        
        if (!i_ex(obj_debug_windows))
        {
            instance_create(0, 0, obj_debug_windows);
            
            if (!i_ex(selected_object))
                obj_debug_windows.type = 1;
            
            with (obj_debug_windows)
                event_user(15);
        }
        else
        {
            with (obj_debug_windows)
                instance_destroy();
        }
    }
}

if (i_ex(selected_object))
{
    so = selected_object;
    
    if (object_get_parent(so.object_index) == 390)
    {
        if (enable_mouse_wheel)
        {
            if (mouse_wheel_up() || mouse_wheel_down())
            {
                with (so)
                {
                    if (state == 0)
                    {
                        state = 3;
                        shakex = 2;
                        hurttimer = 10;
                    }
                    else
                    {
                        state = 0;
                    }
                }
            }
        }
    }
    
    if (so.object_index == obj_actor)
    {
        if (mouse_wheel_up() && enable_mouse_wheel)
        {
            with (so)
            {
                if (specialspriteno < 9)
                {
                    specialspriteno++;
                    sprite_index = specialsprite[specialspriteno];
                }
                else
                {
                    specialspriteno = 0;
                    sprite_index = dsprite;
                }
            }
        }
        
        if (mouse_wheel_down() && enable_mouse_wheel)
        {
            with (so)
            {
                if (specialspriteno > 0)
                {
                    specialspriteno--;
                    sprite_index = specialsprite[specialspriteno];
                }
                else
                {
                    specialspriteno = 9;
                    sprite_index = specialsprite[specialspriteno];
                }
            }
        }
        
        if (button2_h())
            cardinal_grid_align = 1;
        else
            cardinal_grid_align = 0;
        
        if (old_right_click)
        {
            if (mouse_check_button_pressed(mb_right) && mousebuffer < 0)
            {
                cardinal_grid_align = 0;
                thiscardinal = ""d"";
                actor_debug_xstart = so.x;
                actor_debug_ystart = so.y;
            }
        }
        
        if (old_right_click)
        {
            if (mouse_check_button(mb_right) && mousebuffer < 0)
            {
                dir_from_actor = point_direction(so.x, so.y, x, y);
                thiscardinal = scr_get_cardinal_direction(dir_from_actor);
                
                if (cardinal_grid_align == 1)
                {
                    if (thiscardinal == ""d"" || thiscardinal == ""u"")
                        x = so.x;
                    
                    if (thiscardinal == ""r"" || thiscardinal == ""l"")
                        y = so.y;
                }
                
                actor_debug_x = x;
                actor_debug_y = y;
                scr_actor_facing(so, thiscardinal);
                draw_set_color(c_red);
                
                if (cardinal_grid_align == 1)
                    draw_set_color(c_aqua);
                
                draw_arrow(so.x, so.y, x, y, 8);
                draw_sprite_ext(so.sprite_index, so.image_index, x, y, so.image_xscale, so.image_yscale, so.image_angle, so.image_blend, 0.5 + (sin(siner / 4) * 0.1));
            }
        }
        
        if (old_right_click)
        {
            if (mouse_check_button_released(mb_right) && mousebuffer < 0)
            {
                dir_from_actor = point_direction(so.x, so.y, x, y);
                thiscardinal = scr_get_cardinal_direction(dir_from_actor);
                
                if (cardinal_grid_align == 1)
                {
                    if (thiscardinal == ""d"" || thiscardinal == ""u"")
                        x = so.x;
                    
                    if (thiscardinal == ""r"" || thiscardinal == ""l"")
                        y = so.y;
                }
                
                if (actor_previously_selected != so.number)
                    totalstring += (""c_sel("" + string(so.number) + "") //select "" + so.name + "" \\n"");
                
                actor_previously_selected = so.number;
                _speed = 4;
                _time = 40;
                _realdist = point_distance(so.x, so.y, x, y);
                _realtime = _realdist / _speed;
                
                if (cardinal_grid_align == 1)
                    totalstring += (""c_walk_wait(\"""" + thiscardinal + ""\"""" + "","" + string(_speed) + "","" + string(_realtime) + "") //move "" + so.name + "" "" + string(_realdist) + "" pixels\\n"");
                else
                    totalstring += (""c_walkdirect_wait("" + string(x) + "","" + string(y) + "","" + string(ceil(_realtime)) + "")//move"" + so.name + "" \\n"");
                
                clipboard_set_text(totalstring);
                scr_actor_facing(so, thiscardinal);
                so.x = x;
                so.y = y;
                copymessage = ""Copied to clipboard"";
                copybuffer = 15;
                mousebuffer = 3;
            }
        }
        
        if (keyboard_check_pressed(ord(""W"")))
        {
            totalstring += ""c_wait(30)\\n"";
            copymessage = ""Wait command copied"";
            copybuffer = 15;
        }
        
        if (keyboard_check_pressed(vk_f2))
        {
            totalstring += ""c_msgset(0,\""* Text/%\"")\\nc_talk_wait()\\n"";
            copymessage = ""Dialogue command copied"";
            copybuffer = 15;
        }
        
        if (keyboard_check_pressed(ord(""Q"")))
        {
            if (actor_previously_selected != so.number)
                totalstring += (""c_sel("" + string(so.number) + "") //select "" + so.name + "" \\n"");
            
            actor_previously_selected = so.number;
            totalstring += (""c_specialsprite("" + string(so.specialspriteno) + "")\\n"");
            copymessage = ""Sprite change copied"";
            copybuffer = 15;
        }
        
        if (keyboard_check_pressed(ord(""P"")))
        {
            panremx = camerax();
            panremy = cameray();
            
            if (instance_exists(obj_mainchara))
            {
                if (obj_mainchara.cutscene == 0)
                {
                    obj_mainchara.cutscene = 1;
                    totalstring += ""c_pannable(1)\\n"";
                    copymessage = ""Panning enabled!"";
                    copybuffer = 5;
                }
            }
        }
        
        if (keyboard_check(ord(""P"")))
        {
            cameraxadd = 0;
            camerayadd = 0;
            cameraspeed = 2;
            
            if (global.darkzone == 1)
                cameraspeed = 4;
            
            if (right_h())
                cameraxadd = cameraspeed;
            
            if (left_h())
                cameraxadd = -cameraspeed;
            
            if (up_h())
                camerayadd = -cameraspeed;
            
            if (down_h())
                camerayadd = cameraspeed;
            
            camerax_set(camerax() + cameraxadd);
            cameray_set(cameray() + camerayadd);
        }
        
        if (keyboard_check_released(ord(""P"")))
        {
            if (camerax() != panremx || cameray() != panremy)
            {
                pandiffx = camerax() - panremx;
                pandiffy = cameray() - panremy;
                totalstring += (""c_panspeed_wait("" + string(pandiffx / 40) + "","" + string(pandiffy / 40) + "",40) //pan amount: "" + string(pandiffx) + "","" + string(pandiffy));
                totalstring += ("" // panned to: "" + string(camerax()) + "","" + string(cameray()) + ""  \\n"");
                copymessage = ""Pan copied!"";
                copybuffer = 15;
                panremx = camerax();
                panremy = cameray();
            }
        }
        
        if (copybuffer > 0)
        {
            if (copybuffer == 15)
                clipboard_set_text(totalstring);
            
            draw_set_color(c_yellow);
            copybuffer -= 1;
            draw_text(x, y, string_hash_to_newline(copymessage));
        }
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
}");


importGroup.QueueReplace(obj_debug_xy.EventHandlerFor(EventType.Draw, (uint)74, Data),
@"_selected_string = ""No object!#MouseL:Choose&Drag#MouseR:Drag From Anchor"";

if (i_ex(selected_object))
{
    so = selected_object;
    sox = selected_object.x;
    soy = selected_object.y;
    
    if (xy_camera_relative == 1)
        sox -= __view_get(e__VW.XView, 0);
    
    if (xy_camera_relative == 1)
        soy -= __view_get(e__VW.YView, 0);
    
    if (xy_camera_relative == 2)
        sox -= so.xstart;
    
    if (xy_camera_relative == 2)
        soy -= so.ystart;
    
    _selected_string = object_get_name(selected_object.object_index);
    _selected_string += ("" X: "" + string(sox) + "" Y: "" + string(soy));
    _selected_string += (""#Depth: "" + string(selected_object.depth));
    _selected_string += ""#Arrows: Move Precisely"";
}

draw_set_font(fnt_main);
draw_set_color(c_white);
scr_84_draw_text_outline(0, 430, string_hash_to_newline(_selected_string));
draw_set_font(fnt_main);
_str = string_hash_to_newline(stringsetloc(""PgDown: Show All Info"", ""obj_debug_xy_slash_Draw_74_gml_26_0""));
draw_text(__view_get(2, 0) - string_width(_str), 460, _str);
draw_text(320, 460, string_hash_to_newline(stringsetsubloc(""CameraX: ~1 CameraY: ~2"", string(__view_get(e__VW.XView, 0)), string(__view_get(e__VW.YView, 0)), ""obj_debug_xy_slash_Draw_74_gml_27_0"")));

if (show_invisible == 1)
    draw_text(320, 430, string_hash_to_newline(stringsetloc(""Show Invisible"", ""obj_debug_xy_slash_Draw_74_gml_28_0"")));

draw_text(320, 445, string_hash_to_newline(stringsetsubloc(""instance_count: ~1"", string(instance_count), ""obj_debug_xy_slash_Draw_74_gml_29_0_b"")));
_str = string_hash_to_newline(stringsetloc(""PgUp: XY Camera-Relative"", ""obj_debug_xy_slash_Draw_74_gml_29_0""));
draw_text(__view_get(2, 0) - string_width(_str), 445, _str);

if (xy_camera_relative >= 1)
{
    draw_set_color(c_yellow);
    
    if (xy_camera_relative == 1)
    {
        _str = string_hash_to_newline(stringsetloc(""XY is camera-relative!"", ""obj_debug_xy_slash_Draw_74_gml_33_0""));
        draw_text(__view_get(2, 0) - string_width(_str), 425, _str);
    }
    
    if (xy_camera_relative == 2)
    {
        _str = string_hash_to_newline(stringsetloc(""XY is StartXY relative!"", ""obj_debug_xy_slash_Draw_74_gml_34_0""));
        draw_text(__view_get(2, 0) - string_width(_str), 425, _str);
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
}");


UndertaleGameObject obj_debug_windows = Data.GameObjects.ByName("obj_debug_windows");
importGroup.QueueReplace(obj_debug_windows.EventHandlerFor(EventType.Create, (uint)0, Data),
@"xx = mouse_x - camerax() - 40;
yy = mouse_y - cameray() - 20;
xx = clamp(xx, -30, 500);
yy = clamp(yy, -5, 340);
type = 0;
button_text[0] = ""Drag Window!"";
event_user(15);
watchvar = "" "";
watchflag = -1;

for (i = 0; i < button_amount; i++)
{
    button_state[i] = 0;
    button_clicked[i] = 0;
}

remmx = mouse_x - camerax();
remmy = mouse_y - cameray();");


importGroup.QueueReplace(obj_debug_windows.EventHandlerFor(EventType.Draw, (uint)64, Data),
@"bspace = 30;
padding = 5;
wd = 160;
ht = 40 + (bspace * button_amount);
mx = mouse_x - camerax();
my = mouse_y - cameray();
draw_set_color(c_black);
draw_rectangle(xx - 4, yy - 4, xx + wd + 4, yy + ht + 4, false);
draw_set_color(c_ltgray);
draw_rectangle(xx, yy, xx + wd, yy + ht, false);

for (i = 0; i < button_amount; i++)
{
    button_state[i] = 0;
    
    if (point_in_rectangle(mx, my, xx + 10, yy + (bspace * i) + padding, (xx + wd) - 10, yy + ((bspace + 1) * i) + bspace))
    {
        if (i > 0)
        {
            button_state[i] = 1;
            
            if (mouse_check_button(mb_left))
                button_state[i] = 2;
            
            if (mouse_check_button_released(mb_left))
            {
                button_state[i] = 3;
                button_clicked[i] = 1;
            }
        }
        else
        {
            button_state[i] = 1;
            
            if (mouse_check_button(mb_left))
            {
                button_clicked[i] = 1;
                button_state[i] = 3;
            }
        }
    }
}

draw_set_font(fnt_main);

for (i = 0; i < button_amount; i++)
{
    if (button_state[i] == 0)
        draw_set_color(c_ltgray);
    
    if (button_state[i] == 1)
        draw_set_color(c_white);
    
    if (button_state[i] == 2)
        draw_set_color(c_dkgray);
    
    if (button_state[i] == 3)
        draw_set_color(c_blue);
    
    if (i == 0)
        draw_set_color(merge_color(draw_get_color(), c_aqua, 0.7));
    
    draw_rectangle(xx + 10, yy + (bspace * i) + padding, (xx + wd) - 10, (yy + 30 + ((bspace + 1) * i)) - padding, false);
    draw_set_color(c_black);
    draw_rectangle(xx + 10, yy + (bspace * i) + padding, (xx + wd) - 10, (yy + 30 + ((bspace + 1) * i)) - padding, true);
    draw_set_color(c_red);
    draw_text(xx + 10, yy + (bspace * i) + padding, button_text[i]);
    draw_set_color(c_black);
}

if (button_clicked[0] == 1)
{
    if (mouse_check_button(mb_left))
    {
        xx += (mx - remmx);
        yy += (my - remmy);
    }
    else
    {
        button_clicked[0] = 0;
    }
}

if (type == 0)
{
    if (button_clicked[1] == 1)
    {
        if (i_ex(obj_debug_xy))
        {
            var _target = obj_debug_xy.selected_object;
            
            if (i_ex(_target))
            {
                var _copy = instance_create(_target.x + 20, _target.y + 20, _target.object_index);
                
                with (_copy)
                {
                    sprite_index = _target.sprite_index;
                    image_index = _target.image_index;
                    image_speed = _target.image_speed;
                    image_xscale = _target.image_xscale;
                    image_yscale = _target.image_yscale;
                    image_angle = _target.image_angle;
                    image_blend = _target.image_blend;
                    is_debug_copy = true;
                }
                
                obj_debug_xy.selected_object = _copy;
            }
        }
        
        button_clicked[1] = 0;
    }
    
    if (button_clicked[2] == 1)
    {
        if (i_ex(obj_debug_xy))
        {
            if (i_ex(obj_debug_xy.selected_object))
            {
                with (obj_debug_xy.selected_object)
                    instance_destroy();
                
                instance_destroy();
            }
        }
        
        button_clicked[2] = 0;
    }
    
    if (button_clicked[3] == 1)
    {
        if (i_ex(obj_debug_xy))
        {
            if (i_ex(obj_debug_xy.selected_object))
            {
                checksprite = asset_get_index(get_string(""Enter new sprite_index."", """"));
                
                if (checksprite != -1)
                    obj_debug_xy.selected_object.sprite_index = checksprite;
            }
        }
        
        button_clicked[3] = 0;
    }
    
    if (button_clicked[4] == 1)
    {
        if (i_ex(obj_debug_xy))
        {
            if (i_ex(obj_debug_xy.selected_object))
            {
                var so = obj_debug_xy.selected_object;
                var varname = get_string(""Enter variable name. No quotation marks. No arrays."", """");
                
                if (variable_instance_exists(so, varname))
                    watchvar = varname;
                else
                    show_message(""No variable exists. Zannen."");
            }
        }
        
        button_clicked[4] = 0;
    }
    
    if (button_clicked[5] == 1)
    {
        if (i_ex(obj_debug_xy))
        {
            if (i_ex(obj_debug_xy.selected_object))
            {
                var so = obj_debug_xy.selected_object;
                var varname = get_string(""Enter variable name. No quotation marks. No arrays."", """");
                
                if (variable_instance_exists(so, varname))
                {
                    var foundvar = variable_instance_get(so, varname);
                    foundvar = string(foundvar);
                    var newvalue = get_string(varname + "" is "" + foundvar + "". Enter new REAL NUMBER value."", """");
                    variable_instance_set(so, varname, real(newvalue));
                }
                else
                {
                    show_message(""No variable exists. Zannen."");
                }
            }
        }
        
        button_clicked[5] = 0;
    }
    
    if (button_clicked[6] == 1)
    {
        if (i_ex(obj_debug_xy))
        {
            if (i_ex(obj_debug_xy.selected_object))
            {
                var so = obj_debug_xy.selected_object;
                var varname = get_string(""Enter variable name. No quotation marks. No arrays."", """");
                
                if (variable_instance_exists(so, varname))
                {
                    var foundvar = string(variable_instance_get(so, varname));
                    var newvalue = get_string(varname + "" is "" + foundvar + "". Enter string value."", """");
                    variable_instance_set(so, varname, string(newvalue));
                }
                else
                {
                    show_message(""No variable exists. Zannen."");
                }
            }
        }
        
        button_clicked[6] = 0;
    }
    
    if (watchvar != "" "")
    {
        button_text[4] = ""Watch Variable"";
        
        if (i_ex(obj_debug_xy))
        {
            if (i_ex(obj_debug_xy.selected_object))
            {
                var so = obj_debug_xy.selected_object;
                
                if (variable_instance_exists(so, watchvar))
                    button_text[4] = watchvar + "": "" + string(variable_instance_get(so, watchvar));
            }
        }
    }
}
else if (type == 1)
{
    if (button_clicked[1] == 1)
    {
        var varname = get_string(""object name?"", """");
        
        if (varname != """")
        {
            if (i_ex(asset_get_index(varname)))
            {
                with (obj_debug_xy)
                    selected_object = instance_find(asset_get_index(varname), 0);
                
                instance_destroy();
            }
        }
        
        button_clicked[1] = 0;
    }
    
    if (button_clicked[2] == 1)
    {
        var varname = get_string(""object name?"", """");
        
        if (varname != """")
        {
            if (asset_get_index(varname) > 0)
            {
                var bepis = instance_create(mouse_x, mouse_y, asset_get_index(varname));
                
                with (obj_debug_xy)
                    selected_object = bepis;
                
                instance_destroy();
            }
        }
        
        button_clicked[2] = 0;
    }
    
    if (button_clicked[3] == 1)
    {
        var whatflag = -1;
        whatflag = get_string(""Flag to watch? "", """");
        
        if (whatflag != """")
        {
            whatflag = real(string_digits(whatflag));
            
            if (whatflag > 0)
                watchflag = whatflag;
            
            button_clicked[3] = 0;
        }
    }
    
    if (watchflag > 0)
        button_text[3] = ""Flag ["" + string(watchflag) + ""] : "" + string(global.flag[watchflag]);
    
    if (button_clicked[4] == 1)
    {
        var whatflag = -1;
        whatflag = get_string(""Which flag? "", """");
        
        if (whatflag != """")
        {
            whatflag = real(string_digits(whatflag));
            
            if (whatflag > 0)
            {
                var flagvalue = global.flag[whatflag];
                flagvalue = get_string(""Flag ["" + string(whatflag) + ""] is "" + string(flagvalue) + "". Enter new value."", """");
                
                if (flagvalue != """")
                    global.flag[whatflag] = real(string_digits(flagvalue));
            }
        }
        
        button_clicked[4] = 0;
    }
    
    if (button_clicked[5] == 1)
    {
        var varname = get_string(""Enter variable name without \""global.\"""", """");
        
        if (varname != """")
        {
            if (variable_global_exists(varname))
            {
                var varval = variable_global_get(varname);
                var newval = get_string(""The value of "" + varname + "" is "" + string(varval) + "". What to set it to?"", """");
                
                if (newval != """")
                {
                    if (real(string_digits(newval)) > 0)
                        variable_global_set(varname, real(newval));
                }
            }
            else
            {
                show_message(""No variable exists. Zannen."");
            }
        }
        
        button_clicked[5] = 0;
    }
}

xx = clamp(xx, -30, 500);
yy = clamp(yy, -5, 340);
remmx = mouse_x - camerax();
remmy = mouse_y - cameray();
draw_sprite(spr_maus_cursor, 0, mx, my);");


importGroup.QueueReplace(obj_debug_windows.EventHandlerFor(EventType.Other, (uint)25, Data),
@"if (type == 0)
{
    button_amount = 7;
    button_text[1] = ""DUPLICATE OBJECT"";
    button_text[2] = ""DELETE OBJECT"";
    button_text[3] = ""Change Sprite Index"";
    button_text[4] = ""Watch Variable"";
    button_text[5] = ""Change Variable (num)"";
    button_text[6] = ""Change Variable (str)"";
}

if (type == 1)
{
    button_amount = 6;
    button_text[1] = ""Select Object"";
    button_text[2] = ""Instance Create"";
    button_text[3] = ""Watch Flag"";
    button_text[4] = ""Set Flag"";
    button_text[5] = ""Set/Check Global Var"";
}");


UndertaleGameObject obj_savemenu = Data.GameObjects.ByName("obj_savemenu");
importGroup.QueueAppend(obj_savemenu.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (menuno == 98)
{
    var _script_id = asset_get_index(""scr_get_debug_save_list"");
    
    with (obj_dmenu_system)
        script_execute(_script_id);
    
    obj_dmenu_system.dmenu_popup_launch = 1;
    obj_dmenu_system.dmenu_state = ""debug_save"";
    obj_dmenu_system.dmenu_start_index = 0;
    obj_dmenu_system.dvertical_index = 0;
    obj_dmenu_system.dhorizontal_index = 0;
    obj_dmenu_system.dmenu_state_history = [];
    obj_dmenu_system.dmenu_horizontal_index_history = [];
    obj_dmenu_system.dmenu_vertical_index_history = [];
    obj_dmenu_system.dmenu_page_index_history = [];
    obj_dmenu_system.dmenu_active = true;
    instance_destroy();
}");


importGroup.QueueFindReplace("gml_Object_obj_savemenu_Draw_0",
@"    if (mpos == 3)
    {
        draw_set_color(c_yellow);
    }",
@"    if (mpos == 3)
        draw_set_color(c_yellow);

    if (global.debug)
        returntxt = stringsetloc(""Debug saves"", ""obj_savemenu_slash_Draw_0_gml_48_0"");
    else");


importGroup.QueueFindReplace("gml_Object_obj_savemenu_Draw_0",
@"        if (button1_p() && buffer < 0)
        {
            if (mpos == 3)
            {
                menuno = 0;
                buffer = 3;
                mpos = global.filechoice;
                snd_play(snd_select);
            }",
@"        if (button1_p() && buffer < 0)
        {
            if (mpos == 3)
            {
                if (global.debug)
                {
                    menuno = 98;
                    buffer = 3;
                    snd_play(snd_egg);
                }
                else
                {
                    menuno = 0;
                    buffer = 3;
                    mpos = global.filechoice;
                    snd_play(snd_select);
                }
            }");


UndertaleScript scr_saveprocess = Data.Scripts.ByName("scr_saveprocess");
importGroup.QueueFindReplace("gml_GlobalScript_scr_saveprocess",
@"file = ""filech"" + string(global.chapter) + ""_"" + string(arg0);",
@"if (global.debug_saving == 1)
        file = ""debug_save/filech"" + string(global.chapter) + ""_"" + string(arg0);
    else
        file = ""filech"" + string(global.chapter) + ""_"" + string(arg0);");


UndertaleScript scr_get_debug_save_list = Data.Scripts.ByName("scr_get_debug_save_list");
importGroup.QueueReplace("gml_GlobalScript_scr_get_debug_save_list",
@"function scr_get_debug_save_list()
{
    debug_save_sections = [];
    debug_save_names = [];
    debug_save_categories = [];
    debug_save_chapters = [];
    debug_save_descriptions = [];
    var base_dir = ""debug_save/"";
    
    if (!directory_exists(base_dir))
        return debug_save_sections;
    
    var dirs_to_scan = [base_dir];
    var files_to_read = [];
    
    while (array_length(dirs_to_scan) > 0)
    {
        var current_dir = array_pop(dirs_to_scan);
        var f_name = file_find_first(current_dir + ""*"", 16);
        
        while (f_name != """")
        {
            if (f_name != ""."" && f_name != "".."")
            {
                var full_path = current_dir + f_name;
                
                if (directory_exists(full_path))
                    array_push(dirs_to_scan, full_path + ""/"");
                else if (string_ends_with(string_lower(f_name), "".save""))
                    array_push(files_to_read, full_path);
            }
            
            f_name = file_find_next();
        }
        
        file_find_close();
    }
    
    var unsorted_saves = [];
    
    for (var i = 0; i < array_length(files_to_read); i++)
    {
        var save_path = files_to_read[i];
        var file_id = file_text_open_read(save_path);
        var file_content = """";
        
        while (!file_text_eof(file_id))
        {
            file_content += file_text_read_string(file_id);
            file_text_readln(file_id);
            
            if (!file_text_eof(file_id))
                file_content += ""\n"";
        }
        
        file_text_close(file_id);
        
        try
        {
            var save_struct = json_parse(file_content);
            
            if (is_struct(save_struct) && variable_struct_exists(save_struct, ""metadata""))
            {
                var meta = save_struct.metadata;
                var clean_path = string_replace_all(save_path, ""\\"", ""/"");
                var actual_file = filename_name(clean_path);
                var actual_name = string_replace(actual_file, "".save"", """");
                var parent_dir = filename_dir(clean_path);
                var actual_cat_folder = filename_name(parent_dir);
                var actual_cat = """";
                var is_chapter_folder = string_length(actual_cat_folder) >= 3 && string_copy(actual_cat_folder, 1, 2) == ""ch"" && string_digits(actual_cat_folder) != """";
                
                if (!is_chapter_folder && actual_cat_folder != ""debug_save"")
                    actual_cat = actual_cat_folder;
                
                var needs_healing = false;
                
                if (!variable_struct_exists(meta, ""SaveName"") || meta.SaveName != actual_name)
                {
                    meta.SaveName = actual_name;
                    needs_healing = true;
                }
                
                if (!variable_struct_exists(meta, ""Category"") || meta.Category != actual_cat)
                {
                    meta.Category = actual_cat;
                    needs_healing = true;
                }
                
                if (needs_healing)
                {
                    var out_file = file_text_open_write(save_path);
                    file_text_write_string(out_file, json_stringify(save_struct, true));
                    file_text_close(out_file);
                }
                
                var s_name = meta.SaveName;
                var s_cat = meta.Category;
                var s_chap = variable_struct_exists(meta, ""Chapter"") ? meta.Chapter : -1;
                var s_desc = variable_struct_exists(meta, ""Description"") ? meta.Description : ""No description."";
                array_push(unsorted_saves, 
                {
                    path: save_path,
                    name: s_name,
                    cat: s_cat,
                    chap: s_chap,
                    desc: s_desc
                });
            }
        }
        catch (e)
        {
            scr_debug_print(dstr(""Error parsing save file: "", ""Erreur lors de l'analyse du fichier de sauvegarde : "") + filename_name(save_path));
        }
    }
    
    array_sort(unsorted_saves, function(arg0, arg1)
    {
        if (arg0.cat == """" && arg1.cat != """")
            return -1;
        
        if (arg0.cat != """" && arg1.cat == """")
            return 1;
        
        if (arg0.cat != arg1.cat)
        {
            var cat_a = string_lower(arg0.cat);
            var cat_b = string_lower(arg1.cat);
            
            if (cat_a < cat_b)
                return -1;
            
            if (cat_a > cat_b)
                return 1;
        }
        
        var name_a = string_lower(arg0.name);
        var name_b = string_lower(arg1.name);
        
        if (name_a < name_b)
            return -1;
        
        if (name_a > name_b)
            return 1;
        
        return 0;
    });
    
    for (var i = 0; i < array_length(unsorted_saves); i++)
    {
        var s = unsorted_saves[i];
        array_push(debug_save_sections, s.path);
        array_push(debug_save_names, s.name);
        array_push(debug_save_categories, s.cat);
        array_push(debug_save_chapters, s.chap);
        array_push(debug_save_descriptions, s.desc);
    }
    
    return debug_save_sections;
}");


UndertaleScript scr_debug_save_import = Data.Scripts.ByName("scr_debug_save_import");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_save_import",
@"function scr_debug_save_import()
{
    var import_path = get_open_filename(""Save files|*.save;filech*|All files|*.*"", """");
    
    if (import_path == """")
    {
        scr_debug_print(dstr(""Import cancelled"", ""Importation annulée""));
        exit;
    }
    
    var clean_path = string_replace_all(import_path, ""\\"", ""/"");
    var file_only_name = filename_name(clean_path);
    var chapter_num = global.chapter;
    var pos_underscore = string_pos(""_"", file_only_name);
    
    if (pos_underscore > 6)
    {
        var chapter_str = string_copy(file_only_name, 7, pos_underscore - 7);
        
        try
        {
            chapter_num = real(chapter_str);
        }
        catch (e)
        {
        }
    }
    
    var file_id = file_text_open_read(import_path);
    var file_content = """";
    
    while (!file_text_eof(file_id))
    {
        file_content += file_text_read_string(file_id);
        file_text_readln(file_id);
        
        if (!file_text_eof(file_id))
            file_content += ""\n"";
    }
    
    file_text_close(file_id);
    var is_structured = false;
    var import_data = -1;
    
    try
    {
        import_data = json_parse(file_content);
        
        if (is_struct(import_data) && variable_struct_exists(import_data, ""metadata"") && variable_struct_exists(import_data, ""save_file""))
            is_structured = true;
    }
    catch (e)
    {
        is_structured = false;
    }
    
    var meta = {};
    var save_content_out = """";
    
    if (is_structured)
    {
        meta = import_data.metadata;
        save_content_out = import_data.save_file;
        
        if (!variable_struct_exists(meta, ""SaveName"") || meta.SaveName == """")
            meta.SaveName = file_only_name;
        
        if (!variable_struct_exists(meta, ""Category"") || meta.Category == """")
            meta.Category = ""Imported"";
        
        if (!variable_struct_exists(meta, ""Chapter""))
            meta.Chapter = chapter_num;
    }
    else
    {
        meta.SaveName = file_only_name;
        meta.Category = ""Imported"";
        meta.Chapter = chapter_num;
        meta.Plot = 0;
        meta.Description = ""Raw save file imported directly."";
        meta.Name = ""Unknown"";
        meta.Level = 1;
        meta.Love = 1;
        meta.Room = 0;
        meta.Time = 0;
        meta.UraBoss = 0;
        save_content_out = file_content;
    }
    
    var safe_name = scr_debug_sanitize_filename(meta.SaveName);
    var safe_cat = scr_debug_sanitize_filename(meta.Category, true);
    var target_chap = variable_struct_exists(meta, ""Chapter"") ? meta.Chapter : global.chapter;
    var base_dir = ""debug_save/ch"" + string(target_chap) + ""/"";
    
    if (!directory_exists(base_dir))
        directory_create(base_dir);
    
    var cat_dir = base_dir;
    
    if (safe_cat != """")
    {
        cat_dir += (safe_cat + ""/"");
        
        if (!directory_exists(cat_dir))
            directory_create(cat_dir);
    }
    
    var new_file_path = cat_dir + safe_name + "".save"";
    var export_data = 
    {
        metadata: meta,
        save_file: save_content_out
    };
    var out_file = file_text_open_write(new_file_path);
    file_text_write_string(out_file, json_stringify(export_data, true));
    file_text_close(out_file);
    scr_debug_print(dstr(""Save file '"", ""Sauvegarde '"") + file_only_name + dstr(""' imported successfully!"", ""' importée avec succès !""));
    snd_play(snd_shineselect);
}");


UndertaleScript scr_debug_save_scan_imports = Data.Scripts.ByName("scr_debug_save_scan_imports");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_save_scan_imports",
@"function scr_debug_save_scan_imports()
{
    var import_dir = ""debug_save/import/"";
    
    if (!directory_exists(import_dir))
    {
        directory_create(import_dir);
        scr_debug_print(dstr(""Created 'import' folder. Place your folders/saves inside!"", ""Dossier 'import' créé. Placez y vos dossiers/sauvegardes !""));
        snd_play(snd_noise);
        exit;
    }
    
    var dirs_to_scan = [import_dir];
    var files_to_import = [];
    
    while (array_length(dirs_to_scan) > 0)
    {
        var current_dir = array_pop(dirs_to_scan);
        var f_name = file_find_first(current_dir + ""*"", 16);
        
        while (f_name != """")
        {
            if (f_name != ""."" && f_name != "".."")
            {
                var full_path = current_dir + f_name;
                
                if (directory_exists(full_path))
                    array_push(dirs_to_scan, full_path + ""/"");
                else
                    array_push(files_to_import, full_path);
            }
            
            f_name = file_find_next();
        }
        
        file_find_close();
    }
    
    if (array_length(files_to_import) == 0)
    {
        scr_debug_print(dstr(""No files found to import"", ""Aucun fichier à importer trouvé""));
        exit;
    }
    
    var success_count = 0;
    
    for (var f = 0; f < array_length(files_to_import); f++)
    {
        var target_path = files_to_import[f];
        var file_id = file_text_open_read(target_path);
        var file_content = """";
        
        while (!file_text_eof(file_id))
        {
            file_content += file_text_read_string(file_id);
            file_text_readln(file_id);
            
            if (!file_text_eof(file_id))
                file_content += ""\n"";
        }
        
        file_text_close(file_id);
        var is_structured = false;
        var import_data = -1;
        
        try
        {
            import_data = json_parse(file_content);
            
            if (is_struct(import_data) && variable_struct_exists(import_data, ""metadata""))
                is_structured = true;
        }
        catch (e)
        {
            is_structured = false;
        }
        
        var meta = {};
        var save_content = """";
        var clean_path = string_replace_all(target_path, ""\\"", ""/"");
        var clean_import_dir = string_replace_all(import_dir, ""\\"", ""/"");
        var rel_path = string_replace(clean_path, clean_import_dir, """");
        var path_parts = [];
        var cur_part = """";
        
        for (var p = 1; p <= string_length(rel_path); p++)
        {
            var char = string_char_at(rel_path, p);
            
            if (char == ""/"")
            {
                if (cur_part != """")
                    array_push(path_parts, cur_part);
                
                cur_part = """";
            }
            else
            {
                cur_part += char;
            }
        }
        
        if (cur_part != """")
            array_push(path_parts, cur_part);
        
        var p_len = array_length(path_parts);
        var ext_name = ""Untitled"";
        var ext_cat = ""Imported"";
        var file_only_name = path_parts[p_len - 1];
        var chapter_num = global.chapter;
        var pos_underscore = string_pos(""_"", file_only_name);
        
        if (pos_underscore > 6)
        {
            var chapter_str = string_copy(file_only_name, 7, pos_underscore - 7);
            
            try
            {
                chapter_num = real(chapter_str);
            }
            catch (e)
            {
            }
        }
        
        if (p_len >= 3)
        {
            ext_name = path_parts[p_len - 2];
            ext_cat = path_parts[p_len - 3];
        }
        else if (p_len == 2)
        {
            ext_name = path_parts[0];
            ext_cat = ""Imported"";
        }
        else if (p_len == 1)
        {
            ext_name = file_only_name;
            ext_cat = ""Imported"";
        }
        
        if (is_structured)
        {
            meta = import_data.metadata;
            save_content = import_data.save_file;
            
            if (!variable_struct_exists(meta, ""SaveName"") || meta.SaveName == """")
                meta.SaveName = ext_name;
            
            if (!variable_struct_exists(meta, ""Category"") || meta.Category == """")
                meta.Category = ext_cat;
        }
        else
        {
            meta.SaveName = ext_name;
            meta.Category = ext_cat;
            meta.Chapter = chapter_num;
            meta.Plot = 0;
            meta.Description = ""Raw save imported from folder structure."";
            meta.Name = ""Unknown"";
            meta.Level = 1;
            meta.Love = 1;
            meta.Room = 0;
            meta.Time = 0;
            meta.UraBoss = 0;
            save_content = file_content;
        }
        
        var safe_name = scr_debug_sanitize_filename(meta.SaveName);
        var safe_cat = scr_debug_sanitize_filename(meta.Category, true);
        var target_chap = variable_struct_exists(meta, ""Chapter"") ? meta.Chapter : global.chapter;
        var base_dir = ""debug_save/ch"" + string(target_chap) + ""/"";
        
        if (!directory_exists(base_dir))
            directory_create(base_dir);
        
        var cat_dir = base_dir;
        
        if (safe_cat != """")
        {
            cat_dir += (safe_cat + ""/"");
            
            if (!directory_exists(cat_dir))
                directory_create(cat_dir);
        }
        
        var new_file_path = cat_dir + safe_name + "".save"";
        var export_data = 
        {
            metadata: meta,
            save_file: save_content
        };
        var out_file = file_text_open_write(new_file_path);
        file_text_write_string(out_file, json_stringify(export_data, true));
        file_text_close(out_file);
        file_delete(target_path);
        success_count++;
    }
    
    if (directory_exists(import_dir))
        directory_destroy(import_dir);
    
    scr_debug_print(string(success_count) + dstr("" files imported successfully!"", "" fichiers importés avec succès !""));
    snd_play(snd_shineselect);
}");


UndertaleScript scr_debug_save_modify_info = Data.Scripts.ByName("scr_debug_save_modify_info");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_save_modify_info",
@"function scr_debug_save_modify_info(arg0, arg1, arg2)
{
    if (!file_exists(arg0))
    {
        scr_debug_print(dstr(""Error: Save file not found on disk."", ""Erreur : Fichier de sauvegarde introuvable""));
        return """";
    }
    
    var file_id = file_text_open_read(arg0);
    var json_string = """";
    
    while (!file_text_eof(file_id))
    {
        json_string += file_text_read_string(file_id);
        file_text_readln(file_id);
        
        if (!file_text_eof(file_id))
            json_string += ""\n"";
    }
    
    file_text_close(file_id);
    var parsed_data = -1;
    
    try
    {
        parsed_data = json_parse(json_string);
    }
    catch (e)
    {
        scr_debug_print(dstr(""Error: JSON is corrupted"", ""Erreur : JSON corrompu""));
        return """";
    }
    
    if (!is_struct(parsed_data) || !variable_struct_exists(parsed_data, ""metadata""))
    {
        scr_debug_print(dstr(""Error: Invalid save structure"", ""Erreur : Structure de sauvegarde invalide""));
        return """";
    }
    
    variable_struct_set(parsed_data.metadata, arg1, arg2);
    var meta = parsed_data.metadata;
    var safe_name = scr_debug_sanitize_filename(variable_struct_exists(meta, ""SaveName"") ? meta.SaveName : ""Untitled"");
    var safe_cat = scr_debug_sanitize_filename(variable_struct_exists(meta, ""Category"") ? meta.Category : """", true);
    var chapter_num = variable_struct_exists(meta, ""Chapter"") ? meta.Chapter : global.chapter;
    var base_dir = ""debug_save/ch"" + string(chapter_num) + ""/"";
    
    if (!directory_exists(base_dir))
        directory_create(base_dir);
    
    var cat_dir = base_dir;
    
    if (safe_cat != """")
    {
        cat_dir += (safe_cat + ""/"");
        
        if (!directory_exists(cat_dir))
            directory_create(cat_dir);
    }
    
    var new_path = cat_dir + safe_name + "".save"";
    var out_file = file_text_open_write(new_path);
    file_text_write_string(out_file, json_stringify(parsed_data, true));
    file_text_close(out_file);
    
    if (arg0 != new_path)
    {
        file_delete(arg0);
        scr_debug_cleanup_folder(arg0);
    }
    
    snd_play(snd_save);
    scr_debug_print(dstr(""Updated "", ""Mise à jour de "") + arg1 + dstr("" to: "", "" à : "") + string(arg2));
    return new_path;
}");


UndertaleScript scr_debug_save = Data.Scripts.ByName("scr_debug_save");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_save",
@"function scr_debug_sanitize_filename(arg0, arg1 = false)
{
    var bad_chars = [""\\"", ""/"", "":"", ""*"", ""?"", ""\"""", ""<"", "">"", ""|""];
    var clean_name = arg0;
    
    for (var i = 0; i < array_length(bad_chars); i++)
        clean_name = string_replace_all(clean_name, bad_chars[i], ""_"");
    
    clean_name = string_trim(clean_name);
    
    if (clean_name == """")
    {
        if (arg1)
            return """";
        else
            return ""Untitled_Save"";
    }
    
    return clean_name;
}

function scr_debug_save()
{
    if (!variable_global_exists(""debug_save_name""))
        global.debug_save_name = ""Untitled_Save"";
    
    if (!variable_global_exists(""debug_save_category""))
        global.debug_save_category = """";
    
    if (!variable_global_exists(""debug_save_description""))
        global.debug_save_description = dstr(""No description available."", ""Aucune description disponible."");
    
    var temp_id = 999;
    scr_saveprocess(temp_id);
    var raw_file_path = """";
    
    var _route_suffix = """";
    if (variable_global_exists(""filechoice_route"")) 
    {
        _route_suffix = string(global.filechoice_route);
    }

    if (global.debug_saving == 1)
        raw_file_path = ""debug_save/filech"" + string(global.chapter) + ""_"" + string(temp_id) + _route_suffix;
    else
        raw_file_path = ""filech"" + string(global.chapter) + ""_"" + string(temp_id) + _route_suffix;
    
    var safe_name = scr_debug_sanitize_filename(global.debug_save_name);
    var safe_cat = scr_debug_sanitize_filename(global.debug_save_category, true);
    var target_dir = ""debug_save/ch"" + string(global.chapter) + ""/"";
    
    if (!directory_exists(target_dir))
        directory_create(target_dir);
    
    if (safe_cat != """")
    {
        target_dir += (safe_cat + ""/"");
        
        if (!directory_exists(target_dir))
            directory_create(target_dir);
    }
    
    var full_path = target_dir + safe_name + "".save"";
    json_file_path = full_path;
    var uraboss = 0;
    
    if (global.chapter == 1)
    {
        if (global.flag[241] == 6)
            uraboss = 1;
        else if (global.flag[241] == 7)
            uraboss = 2;
    }
    else if (global.chapter == 2)
    {
        if (global.flag[571] == 1)
            uraboss = 1;
        else if (global.flag[571] == 2)
            uraboss = 2;
    }
    else
    {
        uraboss = scr_get_secret_boss_result(global.chapter);
    }
    
    var save_content = """";
    
    if (file_exists(raw_file_path))
    {
        var file_id = file_text_open_read(raw_file_path);
        
        while (!file_text_eof(file_id))
        {
            save_content += (file_text_read_string(file_id) + ""\n"");
            file_text_readln(file_id);
        }
        
        file_text_close(file_id);
        file_delete(raw_file_path);
    }
    
    var current_version = ""Unknown"";
    
    if (variable_global_exists(""versionno""))
        current_version = string(global.versionno);
    else if (variable_global_exists(""version""))
        current_version = string(global.version);
    
    var export_data = 
    {
        metadata: 
        {
            SaveName: global.debug_save_name,
            Category: global.debug_save_category,
            Chapter: global.chapter,
            Plot: global.plot,
            Description: global.debug_save_description,
            Name: global.truename,
            Level: global.lv,
            Love: global.llv,
            Room: scr_get_id_by_room_index(room),
            Time: global.time,
            UraBoss: uraboss,
            Date: date_current_datetime(),
            InitLang: global.flag[912],
            Version: current_version,
            FilechoiceRoute: variable_global_exists(""filechoice_route"") ? string(global.filechoice_route) : """"
        },
        save_file: save_content
    };
    var out_file = file_text_open_write(full_path);
    file_text_write_string(out_file, json_stringify(export_data, true));
    file_text_close(out_file);
    scr_store_ura_result(global.chapter, 999, uraboss);
    ossafe_ini_open(""keyconfig_debug.ini"");
    
    for (var i = 0; i < 10; i += 1)
        ini_write_real(""KEYBOARD_CONTROLS"", string(i), global.input_k[i]);
    
    for (var i = 0; i < 10; i += 1)
        ini_write_real(""GAMEPAD_CONTROLS"", string(i), global.input_g[i]);
    
    ini_write_real(""SHOULDERLB_REASSIGN"", ""SHOULDERLB_REASSIGN"", obj_gamecontroller.gamepad_shoulderlb_reassign);
    ossafe_ini_close();
    ossafe_savedata_save();
    global.debug_save_name = -1;
    global.debug_save_category = """";
    global.debug_overwrite_section = """";
    global.debug_saving = 0;
}

function scr_debug_cleanup_folder(arg0)
{
    var folder_path = filename_dir(arg0) + ""/"";
    var folder_name = filename_name(filename_dir(arg0));
    
    if (string_copy(folder_name, 1, 2) == ""ch"" && string_digits(folder_name) != """")
        exit;
    
    if (folder_name == ""debug_save"")
        exit;
    
    var is_empty = true;
    var file = file_find_first(folder_path + ""*"", 16);
    
    while (file != """")
    {
        if (file != ""."" && file != "".."")
        {
            is_empty = false;
            break;
        }
        
        file = file_find_next();
    }
    
    file_find_close();
    
    if (is_empty && directory_exists(folder_path))
        directory_destroy(folder_path);
}");


UndertaleScript scr_debug_load = Data.Scripts.ByName("scr_debug_load");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_load",
@"function scr_debug_load(arg0)
{
    snd_free_all();
    var keep_inv = false;
    
    if (variable_global_exists(""dload_cur_inv"") && global.dload_cur_inv == 1)
        keep_inv = true;
    
    var cache_truenname = global.truename;
    var cache_othername [];
    for (var i = 0; i < 6; i++)
    {
		cache_othername[i] = global.othername[i];
    }
	var option_flags = [8, 11, 15, 16, 17, 25, 1391];
	var cache_option_flags = [];
	for (var i = 0; i < array_length(option_flags); i++)
    {
		_cur_flag = option_flags[i];
		cache_option_flags[_cur_flag] = global.flag[_cur_flag];
    }
	
    var cache_inv = 0;
    var cache_invc = 0;
    var cache_charweapon = [];
    var cache_chararmor1 = [];
    var cache_chararmor2 = [];
    var cache_weaponstyle = [];
    var cache_item = [];
    var cache_keyitem = [];
    var cache_weapon = [];
    var cache_armor = [];
    var cache_pocketitem = [];
    
    if (keep_inv)
    {
        cache_inv = global.inv;
        cache_invc = global.invc;
        var len_cw = array_length(global.charweapon);
        
        for (var idx = 0; idx < len_cw; idx++)
            cache_charweapon[idx] = global.charweapon[idx];
        
        var len_ca1 = array_length(global.chararmor1);
        
        for (var idx = 0; idx < len_ca1; idx++)
            cache_chararmor1[idx] = global.chararmor1[idx];
        
        var len_ca2 = array_length(global.chararmor2);
        
        for (var idx = 0; idx < len_ca2; idx++)
            cache_chararmor2[idx] = global.chararmor2[idx];
        
        var len_ws = array_length(global.weaponstyle);
        
        for (var idx = 0; idx < len_ws; idx++)
            cache_weaponstyle[idx] = global.weaponstyle[idx];
        
        var len_i = array_length(global.item);
        
        for (var idx = 0; idx < len_i; idx++)
            cache_item[idx] = global.item[idx];
        
        var len_k = array_length(global.keyitem);
        
        for (var idx = 0; idx < len_k; idx++)
            cache_keyitem[idx] = global.keyitem[idx];
        
        var len_w = array_length(global.weapon);
        
        for (var idx = 0; idx < len_w; idx++)
            cache_weapon[idx] = global.weapon[idx];
        
        var len_a = array_length(global.armor);
        
        for (var idx = 0; idx < len_a; idx++)
            cache_armor[idx] = global.armor[idx];
        
        if (variable_global_exists(""pocketitem""))
        {
            var len_p = array_length(global.pocketitem);
            
            for (var idx = 0; idx < len_p; idx++)
                cache_pocketitem[idx] = global.pocketitem[idx];
        }
    }
    
    var file = string(arg0);
    
    if (file == """" || string_length(file) < 3)
    {
        var _route_suffix = """";
        if (variable_global_exists(""filechoice_route""))
            _route_suffix = string(global.filechoice_route);
        
        file = ""debug_save/filech"" + string(global.chapter) + ""_"" + string(arg0) + _route_suffix;
    }
    
    var raw_file_to_read = file;
    var target_chapter = global.chapter;
    
    if (string_copy(file, string_length(file) - 4, 5) == "".save"")
    {
        if (file_exists(file) || ossafe_file_exists(file))
        {
            var temp_id = ossafe_file_text_open_read(file);
            var json_string = """";
            
            while (!ossafe_file_text_eof(temp_id))
            {
                json_string += ossafe_file_text_read_string(temp_id);
                ossafe_file_text_readln(temp_id);
                
                if (!ossafe_file_text_eof(temp_id))
                    json_string += ""\n"";
            }
            
            ossafe_file_text_close(temp_id);
            var parsed_data = -1;
            
            try
            {
                parsed_data = json_parse(json_string);
            }
            catch (e)
            {
            }
            
            if (is_struct(parsed_data))
            {
                if (variable_struct_exists(parsed_data, ""metadata"") && variable_struct_exists(parsed_data.metadata, ""Chapter""))
                    target_chapter = parsed_data.metadata.Chapter;
                
                if (variable_struct_exists(parsed_data, ""metadata"") && variable_struct_exists(parsed_data.metadata, ""FilechoiceRoute""))
                {
                    if (variable_global_exists(""filechoice_route""))
                        global.filechoice_route = parsed_data.metadata.FilechoiceRoute;
                }
                else
                {
                    if (variable_global_exists(""filechoice_route""))
                        global.filechoice_route = """";
                }
                
                if (variable_struct_exists(parsed_data, ""save_file""))
                {
                    var raw_content = parsed_data.save_file;
                    
                    var _route_suffix = """";
                    if (variable_global_exists(""filechoice_route"")) _route_suffix = string(global.filechoice_route);
                    
                    var temp_raw_path = ""filech"" + string(target_chapter) + ""_999"" + _route_suffix;
                    var out_file = ossafe_file_text_open_write(temp_raw_path);
                    ossafe_file_text_write_string(out_file, raw_content);
                    ossafe_file_text_close(out_file);
                    raw_file_to_read = temp_raw_path;
                }
            }
        }
    }
    else
    {
        var fn = filename_name(file);
        
        if (string_pos(""ch1"", fn) > 0)
            target_chapter = 1;
        else if (string_pos(""ch2"", fn) > 0)
            target_chapter = 2;
        else if (string_pos(""ch3"", fn) > 0)
            target_chapter = 3;
        else if (string_pos(""ch4"", fn) > 0)
            target_chapter = 4;
        else if (string_pos(""ch5"", fn) > 0)
            target_chapter = 5;
    }
    
    global.chapter = target_chapter;
    var filechoice_bk = global.filechoice;
    scr_gamestart();
    global.filechoice = filechoice_bk;
    myfileid = ossafe_file_text_open_read(raw_file_to_read);
    global.truename = ossafe_file_text_read_string(myfileid);
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var othername_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(othername_list); i += 1)
            global.othername[i] = ds_list_find_value(othername_list, i);
        
        ds_list_destroy(othername_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (i = 0; i < 6; i += 1)
        {
            global.othername[i] = ossafe_file_text_read_string(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }
    
    global.char[0] = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.char[1] = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.char[2] = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.gold = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.xp = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lv = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.inv = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.invc = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.darkzone = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var hp_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(hp_list); i += 1)
            global.hp[i] = ds_list_find_value(hp_list, i);
        
        ds_list_destroy(hp_list);
        ossafe_file_text_readln(myfileid);
        var maxhp_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(maxhp_list); i += 1)
            global.maxhp[i] = ds_list_find_value(maxhp_list, i);
        
        ds_list_destroy(maxhp_list);
        ossafe_file_text_readln(myfileid);
        var at_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(at_list); i += 1)
            global.at[i] = ds_list_find_value(at_list, i);
        
        ds_list_destroy(at_list);
        ossafe_file_text_readln(myfileid);
        var df_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(df_list); i += 1)
            global.df[i] = ds_list_find_value(df_list, i);
        
        ds_list_destroy(df_list);
        ossafe_file_text_readln(myfileid);
        var mag_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(mag_list); i += 1)
            global.mag[i] = ds_list_find_value(mag_list, i);
        
        ds_list_destroy(mag_list);
        ossafe_file_text_readln(myfileid);
        var guts_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(guts_list); i += 1)
            global.guts[i] = ds_list_find_value(guts_list, i);
        
        ds_list_destroy(guts_list);
        ossafe_file_text_readln(myfileid);
        var charweapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(charweapon_list); i += 1)
            global.charweapon[i] = ds_list_find_value(charweapon_list, i);
        
        ds_list_destroy(charweapon_list);
        ossafe_file_text_readln(myfileid);
        var chararmor1_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor1_list); i += 1)
            global.chararmor1[i] = ds_list_find_value(chararmor1_list, i);
        
        ds_list_destroy(chararmor1_list);
        ossafe_file_text_readln(myfileid);
        var chararmor2_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(chararmor2_list); i += 1)
            global.chararmor2[i] = ds_list_find_value(chararmor2_list, i);
        
        ds_list_destroy(chararmor2_list);
        ossafe_file_text_readln(myfileid);
        var weaponstyle_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(weaponstyle_list); i += 1)
            global.weaponstyle[i] = ds_list_find_value(weaponstyle_list, i);
        
        ds_list_destroy(weaponstyle_list);
        ossafe_file_text_readln(myfileid);
    }
    
    var char_limit = 5;
    
    if (global.chapter == 1)
        char_limit = 4;
    
    for (i = 0; i < char_limit; i += 1)
    {
        if (!global.is_console)
        {
            global.hp[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.maxhp[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.at[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.df[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.mag[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.guts[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.charweapon[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor1[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.chararmor2[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            
            if (global.chapter == 1)
                global.weaponstyle[i] = ossafe_file_text_read_string(myfileid);
            else
                global.weaponstyle[i] = ossafe_file_text_read_real(myfileid);
            
            ossafe_file_text_readln(myfileid);
        }
        
        for (q = 0; q < 4; q += 1)
        {
            global.itemat[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.itemdf[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.itemmag[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.itembolts[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.itemgrazeamt[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.itemgrazesize[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.itemboltspeed[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.itemspecial[i][q] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            
            if (global.chapter != 1)
            {
                global.itemelement[i][q] = ossafe_file_text_read_real(myfileid);
                ossafe_file_text_readln(myfileid);
                global.itemelementamount[i][q] = ossafe_file_text_read_real(myfileid);
                ossafe_file_text_readln(myfileid);
            }
        }
        
        for (j = 0; j < 12; j += 1)
        {
            global.spell[i][j] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }
    
    global.boltspeed = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.grazeamt = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.grazesize = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var item_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(item_list); i += 1)
            global.item[i] = ds_list_find_value(item_list, i);
        
        ds_list_destroy(item_list);
        ossafe_file_text_readln(myfileid);
        var keyitem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(keyitem_list); i += 1)
            global.keyitem[i] = ds_list_find_value(keyitem_list, i);
        
        ds_list_destroy(keyitem_list);
        ossafe_file_text_readln(myfileid);
        var weapon_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(weapon_list); i += 1)
            global.weapon[i] = ds_list_find_value(weapon_list, i);
        
        ds_list_destroy(weapon_list);
        ossafe_file_text_readln(myfileid);
        var armor_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < ds_list_size(armor_list); i += 1)
            global.armor[i] = ds_list_find_value(armor_list, i);
        
        ds_list_destroy(armor_list);
        ossafe_file_text_readln(myfileid);
        
        if (global.chapter != 1)
        {
            var pocket_list = scr_ds_list_read(myfileid);
            
            for (i = 0; i < ds_list_size(pocket_list); i += 1)
                global.pocketitem[i] = ds_list_find_value(pocket_list, i);
            
            ds_list_destroy(pocket_list);
            ossafe_file_text_readln(myfileid);
        }
    }
    else
    {
        switch (global.chapter)
        {
            case 1:
                for (j = 0; j < 13; j += 1)
                {
                    global.item[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                    global.keyitem[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                    global.weapon[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                    global.armor[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                }
                
                break;
            
            default:
                for (j = 0; j < 13; j += 1)
                {
                    global.item[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                    global.keyitem[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                }
                
                for (j = 0; j < 48; j += 1)
                {
                    global.weapon[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                    global.armor[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                }
                
                for (j = 0; j < 72; j += 1)
                {
                    global.pocketitem[j] = ossafe_file_text_read_real(myfileid);
                    ossafe_file_text_readln(myfileid);
                }
                
                break;
        }
    }
    
    global.tension = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.maxtension = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lweapon = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.larmor = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lxp = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.llv = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lgold = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lhp = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lmaxhp = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lat = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.ldf = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.lwstrength = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.ladef = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    
    if (global.is_console)
    {
        var litem_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(litem_list) - 1); i += 1)
            global.litem[i] = ds_list_find_value(litem_list, i);
        
        ds_list_destroy(litem_list);
        ossafe_file_text_readln(myfileid);
        var phone_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(phone_list) - 1); i += 1)
            global.phone[i] = ds_list_find_value(phone_list, i);
        
        ds_list_destroy(phone_list);
        ossafe_file_text_readln(myfileid);
        var flag_list = scr_ds_list_read(myfileid);
        
        for (i = 0; i < (ds_list_size(flag_list) - 1); i += 1)
            global.flag[i] = ds_list_find_value(flag_list, i);
        
        ds_list_destroy(flag_list);
        ossafe_file_text_readln(myfileid);
    }
    else
    {
        for (i = 0; i < 8; i += 1)
        {
            global.litem[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
            global.phone[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
        
        var flag_limit = (global.chapter == 1) ? 9999 : 2500;
        
        for (i = 0; i < flag_limit; i += 1)
        {
            global.flag[i] = ossafe_file_text_read_real(myfileid);
            ossafe_file_text_readln(myfileid);
        }
    }

	global.truename = cache_truenname;
    for (var i = 0; i < 6; i++)
    {
		global.othername[i] = cache_othername[i];
    }
	for (var i = 0; i < array_length(option_flags); i++)
    {
		_cur_flag = option_flags[i];
        global.flag[_cur_flag] = cache_option_flags[_cur_flag];
    }
    
    global.plot = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.currentroom = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    global.time = ossafe_file_text_read_real(myfileid);
    ossafe_file_text_readln(myfileid);
    ossafe_file_text_close(myfileid);
    
    if (keep_inv)
    {
        global.inv = cache_inv;
        global.invc = cache_invc;
        
        for (var idx = 0; idx < array_length(cache_charweapon); idx++)
            global.charweapon[idx] = cache_charweapon[idx];
        
        for (var idx = 0; idx < array_length(cache_chararmor1); idx++)
            global.chararmor1[idx] = cache_chararmor1[idx];
        
        for (var idx = 0; idx < array_length(cache_chararmor2); idx++)
            global.chararmor2[idx] = cache_chararmor2[idx];
        
        for (var idx = 0; idx < array_length(cache_weaponstyle); idx++)
            global.weaponstyle[idx] = cache_weaponstyle[idx];
        
        for (var idx = 0; idx < array_length(cache_item); idx++)
            global.item[idx] = cache_item[idx];
        
        for (var idx = 0; idx < array_length(cache_keyitem); idx++)
            global.keyitem[idx] = cache_keyitem[idx];
        
        for (var idx = 0; idx < array_length(cache_weapon); idx++)
            global.weapon[idx] = cache_weapon[idx];
        
        for (var idx = 0; idx < array_length(cache_armor); idx++)
            global.armor[idx] = cache_armor[idx];
        
        if (global.chapter != 1 && variable_global_exists(""pocketitem""))
        {
            for (var idx = 0; idx < array_length(cache_pocketitem); idx++)
                global.pocketitem[idx] = cache_pocketitem[idx];
        }
    }
    
    global.lastsavedtime = global.time;
    global.lastsavedlv = global.lv;
    audio_group_set_gain(1, global.flag[15], 0);
    audio_set_master_gain(0, global.flag[17]);
    
    switch (global.chapter)
    {
        case 1:
            if (global.plot >= 156)
            {
                for (i = 0; i < 4; i += 1)
                    global.charauto[i] = 0;
            }
            
            var room_id = global.currentroom;
            
            if (room_id < 10000)
            {
                if (global.flag[279] == 0)
                {
                    global.flag[279] = 1;
                    var room_index = room_id;
                    var room_offset = room_index;
                    
                    if (room_index < 281)
                        room_offset = 281 + room_index;
                    
                    room_id = room_offset;
                }
                
                room_id += (global.chapter * 10000);
                global.currentroom = room_id;
                
                if (global.filechoice != 9)
                {
                    var valid_room_index = scr_get_valid_room(global.chapter, global.currentroom);
                    global.currentroom = scr_get_id_by_room_index(valid_room_index);
                    
                    if (global.currentroom == scr_get_id_by_room_index(45) && global.plot >= 33)
                        global.currentroom = scr_get_id_by_room_index(49);
                    
                    if (global.currentroom == scr_get_id_by_room_index(96) && global.plot >= 130)
                        global.currentroom = scr_get_id_by_room_index(97);
                }
            }
            
            global.invc = 1;
            break;
        
        case 2:
            var room_id = global.currentroom;
            
            if (room_id < 10000)
            {
                room_id += (global.chapter * 10000);
                global.currentroom = room_id;
                
                if (global.filechoice != 9)
                {
                    var valid_room_index = scr_get_valid_room(global.chapter, global.currentroom);
                    global.currentroom = scr_get_id_by_room_index(valid_room_index);
                    
                    if (global.currentroom == scr_get_id_by_room_index(61) && global.plot >= 11)
                        global.currentroom = scr_get_id_by_room_index(62);
                    
                    if (global.currentroom == scr_get_id_by_room_index(200))
                        global.currentroom = scr_get_id_by_room_index(199);
                }
            }
            
            break;
        
        case 3:
            if (global.lang == ""en"")
            {
                if (global.flag[1273] == 1)
                {
                    global.flag[1012] = 10;
                    global.flag[1013] = 17;
                    global.flag[1014] = 18;
                }
                else
                {
                    global.flag[1012] = global.flag[1274];
                    global.flag[1013] = global.flag[1275];
                    global.flag[1014] = global.flag[1276];
                }
            }
            else if (global.flag[1273] == 1)
            {
                global.flag[1012] = global.flag[1274];
                global.flag[1013] = global.flag[1275];
                global.flag[1014] = global.flag[1276];
            }
            else
            {
                global.flag[1012] = 0;
                global.flag[1013] = 0;
                global.flag[1014] = 0;
            }
            
            var room_id = global.currentroom;
            
            if (room_id < 10000)
            {
                room_id = scr_get_id_by_room_index(global.currentroom);
                
                if (room_id == -1)
                    room_id += (global.currentroom + (global.chapter * 10000));
                
                global.currentroom = room_id;
            }
            
            break;
        
        default:
            var room_id = global.currentroom;
            
            if (room_id < 10000)
            {
                room_id = scr_get_id_by_room_index(global.currentroom);
                
                if (room_id == room_gms_debug_failsafe)
                    room_id += (global.chapter * 10000);
                
                global.currentroom = room_id;
            }
            
            break;
    }
    
    __loadedroom = scr_get_room_by_id(global.currentroom);
    
    if (scr_dogcheck())
    {
        if (global.chapter == 1)
            __loadedroom = 131;
        else if (global.chapter == 2)
            __loadedroom = choose(226, 271);
        else if (global.chapter == 3)
            __loadedroom = 83;
        else if (global.chapter == 4)
            __loadedroom = 92;
        else if (global.chapter == 5)
            __loadedroom = 98;
    }
    
    scr_tempsave();
    
    if (global.is_console)
        global.tempflag[95] = 1;
    
    with (obj_gamecontroller)
        enable_loading();
    
    if (scr_debug())
    {
        if (room_exists(__loadedroom))
        {
            room_goto(__loadedroom);
        }
        else
        {
            snd_play(snd_error);
            print_message(""LOAD FAILED: ROOM ["" + string(__loadedroom) + ""] DOESN'T EXIST"");
        }
    }
    else
    {
        room_goto(__loadedroom);
    }

    global.dload_cur_inv = 0;
}
");


UndertaleGameObject obj_dmode_xy = new UndertaleGameObject();
obj_dmode_xy.Name = Data.Strings.MakeString("obj_dmode_xy");
obj_dmode_xy.Visible = true;
obj_dmode_xy.Persistent = false;
obj_dmode_xy.Awake = true;
Data.GameObjects.Add(obj_dmode_xy);

importGroup.QueueReplace(obj_dmode_xy.EventHandlerFor(EventType.Create, (uint)0, Data),
@"os = -1
siner = 0;
handmode = 0
obj_spd = 5;

hm_name[0] = dstr(""Absolute Transform"", ""Déplacement absolu"");
hm_name[1] = dstr(""Relative Pointer"", ""Curseur relatif"");
move_interact[0] = dstr(""Arrows"", ""Flèches"");
move_interact[1] = dstr(""Mouse"", ""Souris"");
");


importGroup.QueueReplace(obj_dmode_xy.EventHandlerFor(EventType.Step, (uint)1, Data),
@"siner++;

if (i_ex(sel_obj))
{
    if (sel_obj.sprite_index == -1 || sel_obj.visible == false)
    {
        scr_debug_print(dstr(""Invisible or no sprite#Created immediately"", ""Invisible ou sans sprite#Créé immédiatement""));
        global.interact = 0;
        global.flag[7] = 0;
        instance_destroy();

    }
}

if (keyboard_check_pressed(global.input_k[5]) || keyboard_check_pressed(global.input_k[8]))
{
    obj_spd = (obj_spd % 15) + 5;
}

if (handmode == 0)
{
    if (i_ex(sel_obj))
    {
        if (sel_obj.sprite_index != -1)
        {
            os = sel_obj;
            var _moved = false;

            if (keyboard_check(vk_up))
            {
                os.y -= obj_spd;
                _moved = true;
            }

            if (keyboard_check(vk_left))
            {
                os.x -= obj_spd;
                _moved = true;
            }

            if (keyboard_check(vk_down))
            {
                os.y += obj_spd;
                _moved = true;
            }

            if (keyboard_check(vk_right))
            {
                os.x += obj_spd;
                _moved = true;
            }

            if (_moved)
            {
                with (os.object_index)
                {
                    scr_depth();
                }
            }
        }
    }
}
if (handmode == 1)
{
    if (i_ex(sel_obj))
    {
        if (sel_obj.sprite_index != -1)
        {
            os = sel_obj;
            var _moved = false;

            os.x = mouse_x;
            os.y = mouse_y;

            with (os.object_index)
            {
                scr_depth();
            }
        }
    }
}

// Confirm Z function
if (keyboard_check_pressed(global.input_k[4]) || keyboard_check_pressed(global.input_k[7]))
{
    scr_debug_print(dstr(""Object created!"", ""Objet créé !""));
    io_clear();
    global.interact = 0;
    global.flag[7] = 0;
    instance_destroy();
}

// Switch mode C function
if (keyboard_check_pressed(global.input_k[6]) || keyboard_check_pressed(global.input_k[9]))
{
    handmode = (handmode + 1) % 2;

    if (handmode == 1)
    {
        global.interact = 0;
    }
    else
    {
        global.interact = 1;
    }

    scr_debug_print(dstr(""Mode switched to: "", ""Mode changé en : "") + string(hm_name[handmode]));
    io_clear();
}

// Exit Backspace function
if (keyboard_check_pressed(vk_backspace))
{
    scr_debug_print(dstr(""Object deleted!"", ""Objet supprimé !""));
    io_clear();
    global.interact = 0;
    global.flag[7] = 0;
    with (os)
    {
        instance_destroy();
    }

    instance_destroy();
}

var _data = """";
if (handmode == 0)
{
    _data += ""#"" + dstr(""Move object with arrows"", ""Bouger l'objet avec les flèches"");
}
if (handmode == 1)
{
    _data += ""#"" + dstr(""Move object with mouse"", ""Bouger l'objet avec la souris"");
    _data += ""#"" + dstr(""Move player with arrows"", ""Bouger le joueur avec les flèches"");
}

scr_debug_print_persistent(dstr(""Mode - "") + string(hm_name[handmode]), _data);
");


importGroup.QueueReplace(obj_dmode_xy.EventHandlerFor(EventType.Draw, (uint)0, Data),
@"var camx = camerax();
var camy = cameray();
mx = mouse_x - camx;
my = mouse_y - camy;
var space = 16;
var margin = 10;

linecount = 5;
line[0] = ""["" + string(move_interact[handmode]) + ""] - "" + dstr(""Move object"", ""Bouger l'objet"");
line[1] = dstr(""Confirm"", ""Confirmer"");
line[2] = dstr(""Change move speed: "", ""Changer vitesse objet : "") + string(obj_spd) + "" px"";
line[3] = dstr(""Switch mode"", ""Changer de mode"");
line[4] = dstr(""[Backspace] - Cancel"", ""[Retour arr.] - Annuler"");
but[0] = -1;
but[1] = 4;
but[2] = 5;
but[3] = 6;
but[4] = -1;

var xloc = (camx + 640) - margin;
var yloc = 480 - (space * linecount) - margin;
draw_set_color(c_white);
draw_set_halign(fa_right);
draw_set_font(fnt_main);

for (var i = 0; i < linecount; i++)
{
    if (but[i] != -1)
    {
        fullline = scr_get_input_name(but[i]) + "" - "" + line[i];
    }
    else
    {
        fullline = line[i];
    }

    scr_84_draw_text_outline(xloc, camy + yloc + (space * i), fullline);
}

draw_set_halign(fa_left);

xloc = camx + margin;
yloc = 480 - space - margin;
fullline = dstr(""Object: "", ""Objet : "") + string(object_get_name(sel_obj.object_index));

scr_84_draw_text_outline(xloc, camy + yloc, fullline);

draw_set_font(fnt_mainbig);

if (i_ex(sel_obj))
{
    if (sel_obj.sprite_index != -1)
    {
        os = sel_obj;
        draw_sprite_ext_flash(os.sprite_index, os.image_index, os.x, os.y, os.image_xscale, os.image_yscale, os.image_angle, os.image_blend, (sin(siner / 8) * 0.5) + 0.5);
    }
}

if (handmode == 2)
{
    draw_sprite(spr_maus_cursor, 0, mx, my);
}
");


UndertaleScript scr_debug_fullheal = Data.Scripts.ByName("scr_debug_fullheal");
importGroup.QueueReplace("gml_GlobalScript_scr_debug_fullheal",
@"function scr_debug_fullheal()
{
    var _in_battle = false;
    
    if (variable_global_exists(""charinstance"") && is_array(global.charinstance))
    {
        if (array_length(global.charinstance) > 0 && instance_exists(global.charinstance[0]))
        {
            if (variable_instance_exists(global.charinstance[0], ""myself""))
                _in_battle = true;
        }
    }
    
    if (_in_battle)
    {
        with (obj_dmgwriter)
        {
            if (delaytimer >= 1)
                killactive = 1;
        }
        
        scr_healallitemspell(999);
        
        for (var i = 0; i < 3; i++)
        {
            if (instance_exists(global.charinstance[i]))
            {
                with (global.charinstance[i])
                {
                    if (variable_instance_exists(id, ""tu""))
                        tu--;
                }
            }
        }
    }
    else
    {
        with (obj_dmgwriter)
        {
            if (delaytimer >= 1)
                killactive = 1;
        }
        
        scr_healall(999);
        var _targets = [];
        var _plat_player_idx = asset_get_index(""obj_plat_player"");
        var _mainchara_idx = asset_get_index(""obj_mainchara"");
        
        if (_plat_player_idx != -1 && instance_exists(_plat_player_idx))
        {
            with (_plat_player_idx)
                array_push(_targets, id);
            
            var _plat_follower_idx = asset_get_index(""obj_plat_follower"");
            
            if (_plat_follower_idx != -1)
            {
                with (_plat_follower_idx)
                    array_push(_targets, id);
            }
        }
        else if (_mainchara_idx != -1 && instance_exists(_mainchara_idx))
        {
            with (_mainchara_idx)
                array_push(_targets, id);
            
            var _caterpillar_idx = asset_get_index(""obj_caterpillarchara"");
            
            if (_caterpillar_idx != -1)
            {
                with (_caterpillar_idx)
                    array_push(_targets, id);
            }
        }
        
        for (var i = 0; i < array_length(_targets); i++)
        {
            var _t = _targets[i];
            
            if (instance_exists(_t))
            {
                var healanim = instance_create(_t.x, _t.y, obj_healanim);
                healanim.target = _t;
                var dmgwr = instance_create(_t.x, _t.y - 30, obj_dmgwriter);
                
                with (dmgwr)
                {
                    delay = 4;
                    specialmessage = 3;
                    image_speed = 0;
                }
            }
        }
    }
}");


UndertaleScript scr_turn_skip = Data.Scripts.ByName("scr_turn_skip");
importGroup.QueueReplace("gml_GlobalScript_scr_turn_skip",
@"function scr_turn_skip()
{
    if (global.turntimer > 0 && instance_exists(obj_growtangle) && scr_isphase(""bullets""))
    {
        global.turntimer = 0;
        scr_debug_print(dstr(""Enemy's turn skipped"", ""Tour de l'ennemi passé""));
    }
}");


UndertaleScript scr_dstr = Data.Scripts.ByName("scr_dstr");
importGroup.QueueReplace("gml_GlobalScript_scr_dstr",
@"function scr_dstr()
{
    if (argument_count == 1 || global.dlang != ""fr"")
    {
        return argument[0];
    }
    
    return argument[1];
}

function dstr()
{
    if (argument_count == 1)
    {
        return scr_dstr(argument[0]);
    }
    
    return scr_dstr(argument[0], argument[1]);
}");


UndertaleScript scr_read_keyboard = Data.Scripts.ByName("scr_read_keyboard");
importGroup.QueueReplace("gml_GlobalScript_scr_read_keyboard",
@"function scr_read_keyboard()
{
    var cur_text = global.dkeyboard_text;
    text_changed = 0;
    var backspace_action = dmenu_pressed_key(8);
    
    if (backspace_action > 0)
    {
        if (string_length(cur_text) > 0)
            cur_text = string_delete(cur_text, string_length(cur_text), 1);
        
        keyboard_string = """";
        text_changed = 1;
    }
    else if (keyboard_string != """")
    {
        cur_text += keyboard_string;
        keyboard_string = """";
        text_changed = 1;
    }
    
    global.dkeyboard_text = cur_text;
    return text_changed;
}");


UndertaleScript scr_string_respect_type = Data.Scripts.ByName("scr_string_respect_type");
importGroup.QueueAppend("gml_GlobalScript_scr_string_respect_type",
@"function scr_string_respect_type(arg0, arg1, arg2, arg3)
{
    str = arg0;
    type = arg1;
    check_empty = arg2;
    print_error = arg3;
    
    if (string_length(str) == 0 && check_empty)
    {
        scr_debug_print(dstr(""Empty flag"", ""Flag vide""));
        return 0;
    }
    
    if (type == ""string"")
        return 1;
    
    is_good = 1;
    saw_dot = 0;
    saw_neg = 0;
    var is_var_step = 0;
    
    for (c = 1; c <= string_length(str); c++)
    {
        cur_char = string_char_at(str, c);
        char_is_digit = scr_84_is_digit(cur_char);
        char_is_letter = (cur_char >= ""a"" && cur_char <= ""z"") || (cur_char >= ""A"" && cur_char <= ""Z"");
        
        if (type != ""variable"")
        {
            if (!saw_dot && type == ""real"" && cur_char == ""."")
            {
                saw_dot = 1;
            }
            else if (!saw_neg && type != ""uint"" && cur_char == ""-"")
            {
                saw_neg = 1;
            }
            else if (!char_is_digit)
            {
                if (print_error)
                    scr_debug_print(dstr(""Invalid flag "", ""Flag invalide "") + ""|"" + string(str) + ""|"" + dstr("" because of "", "" à cause de "") + ""|"" + cur_char + ""|"");
                
                is_good = 0;
                break;
            }
        }
        else if ((is_var_step == 0 || is_var_step == 1) && (char_is_letter || cur_char == ""_""))
        {
            is_var_step = 1;
        }
        else if (is_var_step == 1 && cur_char == ""["")
        {
            is_var_step = 2;
        }
        else if ((is_var_step == 2 || is_var_step == 3) && char_is_digit)
        {
            is_var_step = 3;
        }
        else if (is_var_step == 3 && cur_char == ""]"")
        {
            is_var_step = 4;
        }
        else
        {
            if (print_error)
                scr_debug_print(dstr(""Error reading variable |"", ""Erreur de lecture de variable |"") + string(str) + dstr(""| at |"", ""| à |"") + string(cur_char) + ""|"");
            
            is_good = 0;
            break;
        }
    }
    
    if (type == ""variable"" && is_good && (is_var_step != 4 && is_var_step != 1))
    {
        if (print_error)
            scr_debug_print(dstr(""Error: Invalid variable name |"", ""Erreur : Nom de variable invalide |"") + string(str) + ""|"");
        
        is_good = 0;
    }
    
    return is_good;
}

function scr_array_contains(arg0, arg1)
{
    for (var i = 0; i < array_length(arg0); i++)
    {
        if (arg0[i] == arg1)
            return true;
    }
    
    return false;
}");


UndertaleScript scr_debug = Data.Scripts.ByName("scr_debug");
importGroup.QueueReplace("gml_GlobalScript_scr_debug",
@"function scr_debug()
{
    return global.debug;
}");


UndertaleGameObject obj_time = Data.GameObjects.ByName("obj_time");
importGroup.QueueReplace(obj_time.EventHandlerFor(EventType.Draw, (uint)0, Data),
@"if (scr_debug())
{
	cur_font = draw_get_font();
    draw_set_font(fnt_main);
    var text_scale = (global.darkzone == 1) ? 1 : 0.5;
    draw_set_color(c_red);
    draw_text(__view_get(0, 0), __view_get(1, 0), fps);
    draw_set_font(fnt_main);
    draw_set_color(c_green);
    draw_text_transformed((__view_get(0, 0) + __view_get(2, 0)) - (string_width(room_get_name(room)) * text_scale), __view_get(1, 0), room_get_name(room), text_scale, text_scale, 0);
    draw_text_transformed((__view_get(0, 0) + __view_get(2, 0)) - (string_width(""plot "" + string(global.plot)) * text_scale), __view_get(1, 0) + (15 * text_scale), ""plot "" + string(global.plot), text_scale, text_scale, 0);
    draw_set_color(c_white);
    draw_set_font(cur_font);
}
");


importGroup.QueueAppend(obj_time.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (keyboard_check_pressed(vk_f10))
{
    global.debug = !global.debug;
    
    if (global.debug)
        scr_debug_print(dstr(""Debug Mode activated!"", ""Mode Debug activé !""));
    else
        scr_debug_print(dstr(""Debug Mode deactivated!"", ""Mode Debug désactivé !""), true);
}

if (scr_debug() && (!instance_number(obj_dmenu_system) || !global.dreading_custom_flag))
{
    if (keyboard_check_pressed(ord(""G"")))
    {
		global.dgodmode = !global.dgodmode;

        if (global.dgodmode)
			scr_debug_print(dstr(""Godmode enabled"", ""Godmode activé""));
		else
			scr_debug_print(dstr(""Godmode disabled"", ""Godmode désactivé""));
    }
    
    if (keyboard_check_pressed(ord(""P"")) && !keyboard_check(vk_alt))
    {
        if (!variable_global_exists(""speed_fps""))
            global.speed_fps = 30;

        if (global.speed_fps == 30)
        {
            global.speed_fps = 1;
            game_set_speed(1, gamespeed_fps);
            scr_debug_print(dstr(""FPS to 1"", ""FPS à 1""));
        }
        else
        {
            global.speed_fps = 30;
            game_set_speed(30, gamespeed_fps);
            scr_debug_print(dstr(""FPS to 30"", ""FPS à 30""));
        }
    }

    if (keyboard_check_pressed(ord(""O"")))
    {
        if (!variable_global_exists(""speed_fps""))
            global.speed_fps = 30;
        
        if (global.speed_fps == 30)
        {
            global.speed_fps = 60;
            game_set_speed(60, gamespeed_fps);
            scr_debug_print(dstr(""FPS to 60"", ""FPS à 60""));
        }
        else if (global.speed_fps == 60)
        {
            global.speed_fps = 120;
            game_set_speed(120, gamespeed_fps);
            scr_debug_print(dstr(""FPS to 120"", ""FPS à 120""));
        }
        else
        {
            global.speed_fps = 30;
            game_set_speed(30, gamespeed_fps);
            scr_debug_print(dstr(""FPS to 30"", ""FPS à 30""));
        }
    }
}");


importGroup.QueueAppend(obj_time.EventHandlerFor(EventType.Step, (uint)1, Data),
@"if (scr_debug())
{
    if (mouse_check_button_pressed(mb_middle))
        instance_create(0, 0, obj_debug_xy);

    if (keyboard_check_pressed(192))
    {
        if (room_speed == 30)
        {
            room_speed = 150 - (140 * keyboard_check(vk_control));
        }
        else
        {
            room_speed = 30;
        }
    }
}
");


UndertaleGameObject obj_darkcontroller = Data.GameObjects.ByName("obj_darkcontroller");
importGroup.QueueAppend(obj_darkcontroller.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (scr_debug() && (!instance_number(obj_dmenu_system) || !global.dreading_custom_flag))
{
    if (keyboard_check_pressed(ord(""H"")))
    {
        scr_debug_fullheal();
        scr_debug_print(dstr(""Party HP fully restored"", ""PV de l'équipe restaurés""));
    }
    
    if (keyboard_check_pressed(ord(""2"")) && keyboard_check(ord(""M"")))
    {
        if (global.gold >= 100)
        {
            global.gold -= 100;
            scr_debug_print(""- 100 D$"");
        }
        else
        {
            scr_debug_print(""- "" + string(global.gold) + "" D$"");
            global.gold = 0;
        }
    }
    if (keyboard_check_pressed(ord(""1"")) && keyboard_check(ord(""M"")))
    {
        global.gold += 100;
        scr_debug_print(""+ 100 D$"");
    }

    if (keyboard_check_pressed(ord(""S"")))
        instance_create(0, 0, obj_savemenu);

    if (keyboard_check_pressed(ord(""L"")) && keyboard_check(vk_alt))
    {
        with (obj_dmenu_system)
            script_execute(scr_get_debug_save_list);

        obj_dmenu_system.dmenu_popup_launch = 1;
        obj_dmenu_system.dmenu_state = ""debug_save"";
        obj_dmenu_system.dmenu_start_index = 0;
        obj_dmenu_system.dmenu_vertical_index = 0;
        obj_dmenu_system.dmenu_horizontal_index = 0;
        obj_dmenu_system.dmenu_state_history = [];
        obj_dmenu_system.dmenu_horizontal_index_history = [];
        obj_dmenu_system.dmenu_vertical_index_history = [];
        obj_dmenu_system.dmenu_page_index_history = [];
        obj_dmenu_system.dmenu_active = true;
        snd_play(snd_egg);
    }

    if (keyboard_check_pressed(ord(""L"")) && !keyboard_check(vk_alt))
        scr_load();

    if (keyboard_check_pressed(ord(""R"")) && keyboard_check(vk_backspace) && keyboard_check(vk_alt))
        scr_chapterswitch(0);

    if (keyboard_check_pressed(ord(""R"")) && keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
        game_restart_true();

    if (keyboard_check_pressed(ord(""R"")) && !keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
    {
        snd_free_all();
        room_restart();
        global.interact = 0;
    }
}
if (!instance_exists(obj_dmenu_system))
    instance_create(0, 0, obj_dmenu_system);

if (!instance_exists(obj_dconsole_system))
    instance_create_depth(0, 0, -99999, obj_dconsole_system);
");


importGroup.QueueFindReplace("gml_Object_obj_darkcontroller_Step_0",
@"if (scr_debug())",
@"if (0)");


UndertaleGameObject obj_overworldc = Data.GameObjects.ByName("obj_overworldc");
importGroup.QueueAppend(obj_overworldc.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (scr_debug())
{
    if (keyboard_check_pressed(ord(""S"")))
        instance_create(0, 0, obj_savemenu);
    if (keyboard_check_pressed(ord(""L"")) && keyboard_check(vk_alt))
    {
        with (obj_dmenu_system)
            script_execute(scr_get_debug_save_list);

        obj_dmenu_system.dmenu_popup_launch = 1;
        obj_dmenu_system.dmenu_state = ""debug_save"";
        obj_dmenu_system.dmenu_start_index = 0;
        obj_dmenu_system.dmenu_vertical_index = 0;
        obj_dmenu_system.dmenu_horizontal_index = 0;
        obj_dmenu_system.dmenu_state_history = [];
        obj_dmenu_system.dmenu_horizontal_index_history = [];
        obj_dmenu_system.dmenu_vertical_index_history = [];
        obj_dmenu_system.dmenu_page_index_history = [];
        obj_dmenu_system.dmenu_active = true;
        snd_play(snd_egg);
    }
    if (keyboard_check_pressed(ord(""L"")) && !keyboard_check(vk_alt))
        scr_load();

    if (keyboard_check_pressed(ord(""R"")) && keyboard_check(vk_backspace) && keyboard_check(vk_alt))
        scr_chapterswitch(0);

    if (keyboard_check_pressed(ord(""R"")) && keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
        game_restart_true();

    if (keyboard_check_pressed(ord(""R"")) && !keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
    {
        snd_free_all();
        room_restart();
        global.interact = 0;
    }
}
");
importGroup.QueueAppend("gml_Object_obj_overworldc_Step_0",
@"if (scr_debug())
{
    if (keyboard_check_pressed(ord(""S"")))
        instance_create(0, 0, obj_savemenu);
    if (keyboard_check_pressed(ord(""L"")) && keyboard_check(vk_alt))
    {
        with (obj_dmenu_system)
            script_execute(scr_get_debug_save_list);

        obj_dmenu_system.dmenu_popup_launch = 1;
        obj_dmenu_system.dmenu_state = ""debug_save"";
        obj_dmenu_system.dmenu_start_index = 0;
        obj_dmenu_system.dmenu_vertical_index = 0;
        obj_dmenu_system.dmenu_horizontal_index = 0;
        obj_dmenu_system.dmenu_state_history = [];
        obj_dmenu_system.dmenu_horizontal_index_history = [];
        obj_dmenu_system.dmenu_vertical_index_history = [];
        obj_dmenu_system.dmenu_page_index_history = [];
        obj_dmenu_system.dmenu_active = true;
        snd_play(snd_egg);
    }
    if (keyboard_check_pressed(ord(""L"")) && !keyboard_check(vk_alt))
        scr_load();

    if (keyboard_check_pressed(ord(""R"")) && keyboard_check(vk_backspace) && keyboard_check(vk_alt))
        scr_chapterswitch(0);

    if (keyboard_check_pressed(ord(""R"")) && keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
        game_restart_true();

    if (keyboard_check_pressed(ord(""R"")) && !keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
    {
        snd_free_all();
        room_restart();
        global.interact = 0;
    }
}
");
importGroup.QueueFindReplace("gml_Object_obj_overworldc_Step_0",
@"if (scr_debug())",
@"if (scr_debug() && (!instance_number(obj_dmenu_system) || !global.dreading_custom_flag))");


importGroup.QueueAppend(obj_overworldc.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (!instance_exists(obj_dmenu_system))
    instance_create(0, 0, obj_dmenu_system);

if (!instance_exists(obj_dconsole_system))
    instance_create_depth(0, 0, -99999, obj_dconsole_system);");


UndertaleGameObject obj_battlecontroller = Data.GameObjects.ByName("obj_battlecontroller");
importGroup.QueueAppend(obj_battlecontroller.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (scr_debug() && (!instance_number(obj_dmenu_system) || !global.dreading_custom_flag))
{
    if (keyboard_check_pressed(ord(""P"")) && keyboard_check(vk_alt))
    {
        global.dpause_dialog = !global.dpause_dialog;

        if (global.dpause_dialog)
            scr_debug_print(dstr(""Dialog autoskip disabled"", ""Autoskip des dialogues désactivé""));
        else
            scr_debug_print(dstr(""Dialog autoskip enabled (default)"", ""Autoskip des dialogues activé (par défault)""));
    }
    
    if (keyboard_check_pressed(ord(""T"")))
    {
        if (global.tension < 250)
        {
            global.tension = 250;
            scr_debug_print(dstr(""TP to 250%"", ""PT à 250 %""));
        }
        else
        {
            global.tension = 0;
            scr_debug_print(dstr(""TP to 0%"", ""PT à 0 %""));
        }
    }
    
    if (keyboard_check_pressed(ord(""V"")))
        scr_turn_skip();
        
    if (keyboard_check_pressed(ord(""W"")))
    {
        scr_wincombat();
        scr_debug_print(dstr(""Fight skipped"", ""Combat passé""));
    }
}");


importGroup.QueueFindReplace("gml_Object_obj_battlecontroller_Step_0",
@"if (scr_debug())",
@"if (0)");


UndertaleScript scr_wincombat = Data.Scripts.ByName("scr_wincombat");
importGroup.QueueFindReplace("gml_GlobalScript_scr_wincombat",
@"scr_monsterdefeat();",
@"if (keyboard_check(vk_shift))
{
    scr_spareanim();
    scr_recruit();
}

scr_monsterdefeat();");


UndertaleScript scr_damage_all_overworld = Data.Scripts.ByName("scr_damage_all_overworld");
importGroup.QueueFindReplace("gml_GlobalScript_scr_damage_all_overworld",
@"    if (global.inv < 0)",
@"    if (global.dgodmode)
        exit;
    if (global.inv < 0)");


UndertaleScript scr_damage = Data.Scripts.ByName("scr_damage");
importGroup.QueueFindReplace("gml_GlobalScript_scr_damage",
@"    if (global.inv < 0)",
@"    if (global.dgodmode)
        exit;
    if (global.inv < 0)");


UndertaleGameObject obj_mainchara = Data.GameObjects.ByName("obj_mainchara");
importGroup.QueueAppend("gml_Object_obj_mainchara_Create_0",
@"siner = 0;");


importGroup.QueueAppend(obj_mainchara.EventHandlerFor(EventType.Step, (uint)0, Data),
@"if (scr_debug())
{
    siner++;
    var _debug_xy = asset_get_index(""obj_debug_xy"");
    
    if (mouse_check_button(mb_right) && (_debug_xy == -1 || !instance_exists(_debug_xy)))
    {
        if (sprite_index != -1)
        {
            if (keyboard_check(vk_up))
                y -= 3;
            
            if (keyboard_check(vk_left))
                x -= 3;
            
            if (keyboard_check(vk_down))
                y += 3;
            
            if (keyboard_check(vk_right))
                x += 3;
        }
    }
}");


importGroup.QueueAppend("gml_Object_obj_mainchara_Draw_0",
@"if (scr_debug())
{
    var _debug_xy = asset_get_index(""obj_debug_xy"");
    
    if (mouse_check_button(mb_right) && (_debug_xy == -1 || !instance_exists(_debug_xy)))
    {
        if (sprite_index != -1)
            draw_sprite_ext_flash(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, (sin(siner / 8) * 0.5) + 0.5);
    }
}");


UndertaleGameObject obj_dialoguer = Data.GameObjects.ByName("obj_dialoguer");
importGroup.QueueFindReplace("gml_Object_obj_dialoguer_Draw_0",
@"if (keyboard_check_pressed(ord(""D"")))",
@"if (keyboard_check_pressed(vk_f2))");


UndertaleScript scr_blconskip = Data.Scripts.ByName("scr_blconskip");
importGroup.QueueFindReplace("gml_GlobalScript_scr_blconskip",
@"if (arg0 >= 0)",
@"if (global.dpause_dialog)
{
    if (button1_p())
    {
        talktimer = talkmax;
        
        with (obj_writer)
            instance_destroy();
        
        global.mnfight = 2;
    }
    
    exit;
}

if (arg0 >= 0)");


UndertaleGameObject obj_dconsole_system = new UndertaleGameObject();
obj_dconsole_system.Name = Data.Strings.MakeString("obj_dconsole_system");
obj_dconsole_system.Visible = true;
obj_dconsole_system.Persistent = true;
obj_dconsole_system.Awake = true;
Data.GameObjects.Add(obj_dconsole_system);

importGroup.QueueReplace(obj_dconsole_system.EventHandlerFor(EventType.Create, (uint)0, Data),
@"dconsole_active = false;
dinput_text = """";
dconsole_history = [];
dconsole_log = [];
blink_cursor = ""|"";
dconsole_height = 200;
dconsole_max_lines = floor((dconsole_height - 65) / 20) + 1;
blink_timer = 0;
dbackspace_timer = 0;
dleft_timer = 0;
dright_timer = 0;
dup_timer = 0;
ddown_timer = 0;
sel_history_count = 0;
dconsole_scroll = 0;
dcursor_pos = 0;
dselect_all = false;");


importGroup.QueueReplace(obj_dconsole_system.EventHandlerFor(EventType.Step, (uint)1, Data),
@"dconsole_prefix = ""["" + global.truename + ""]: "";

if (keyboard_check_pressed(vk_f5) && global.dreading_custom_flag != 1)
{
    if (!dconsole_active)
    {
        dinteract_bk = global.interact;
        global.interact = 1;
        dconsole_active = true;
        keyboard_string = """";
        dinput_text = """";
        sel_history_count = 0;
    }
}

if (keyboard_check_pressed(vk_escape))
{
    if (dconsole_active)
    {
        global.interact = dinteract_bk;
        dconsole_active = false;
        sel_history_count = 0;
        io_clear();
    }
}

if (dconsole_active)
{
    if (mouse_wheel_up() || keyboard_check_pressed(vk_pageup))
    {
        var _max_scroll = max(0, array_length(dconsole_log) - 1);
        dconsole_scroll = min(dconsole_scroll + 1, _max_scroll);
    }
    
    if (mouse_wheel_down() || keyboard_check_pressed(vk_pagedown))
        dconsole_scroll = max(dconsole_scroll - 1, 0);
    
    if (keyboard_check_direct(vk_control))
    {
        if (keyboard_check_pressed(ord(""A"")))
        {
            if (dinput_text != """")
                dselect_all = true;
        }
        
        keyboard_string = """";
    }
    
    if (keyboard_check_direct(vk_left))
    {
        dleft_timer++;
        
        if (dleft_timer == 1 || (dleft_timer > 15 && (dleft_timer % 1) == 0))
        {
            dselect_all = false;
            dcursor_pos = max(0, dcursor_pos - 1);
            blink_cursor = ""|"";
            blink_timer = 0;
        }
    }
    else
    {
        dleft_timer = 0;
    }
    
    if (keyboard_check_direct(vk_right))
    {
        dright_timer++;
        
        if (dright_timer == 1 || (dright_timer > 15 && (dright_timer % 1) == 0))
        {
            dselect_all = false;
            dcursor_pos = min(string_length(dinput_text), dcursor_pos + 1);
            blink_cursor = ""|"";
            blink_timer = 0;
        }
    }
    else
    {
        dright_timer = 0;
    }
    
    if (keyboard_string != """")
    {
        if (dselect_all)
        {
            dinput_text = """";
            dcursor_pos = 0;
            dselect_all = false;
        }
        
        dinput_text = string_insert(keyboard_string, dinput_text, dcursor_pos + 1);
        dcursor_pos += string_length(keyboard_string);
        keyboard_string = """";
        blink_cursor = ""|"";
        blink_timer = 0;
    }
    
    if (keyboard_check_direct(vk_backspace))
    {
        dbackspace_timer++;
        
        if (dbackspace_timer == 1 || (dbackspace_timer > 15 && (dbackspace_timer % 1) == 0))
        {
            if (dselect_all)
            {
                dinput_text = """";
                dcursor_pos = 0;
                dselect_all = false;
            }
            else if (dcursor_pos > 0)
            {
                dinput_text = string_delete(dinput_text, dcursor_pos, 1);
                dcursor_pos--;
            }
            
            blink_cursor = ""|"";
            blink_timer = 0;
        }
    }
    else
    {
        dbackspace_timer = 0;
    }
    
    if (keyboard_string != """")
    {
        if (dselect_all)
        {
            dinput_text = """";
            dcursor_pos = 0;
            dselect_all = false;
        }
        
        dinput_text = string_insert(keyboard_string, dinput_text, dcursor_pos + 1);
        dcursor_pos += string_length(keyboard_string);
        keyboard_string = """";
        blink_cursor = ""|"";
        blink_timer = 0;
    }
    
    if (keyboard_check_pressed(vk_enter))
    {
        if (dinput_text != """")
        {
            array_push(dconsole_log, dconsole_prefix + dinput_text);
            array_push(dconsole_history, dinput_text);
            
            if (string_char_at(dinput_text, 1) == ""/"")
                scr_dconsole_command(dinput_text);
            
            dinput_text = """";
            keyboard_string = """";
            sel_history_count = 0;
            dcursor_pos = 0;
            dselect_all = false;
            dconsole_scroll = 0;
            blink_cursor = ""|"";
            blink_timer = 0;
        }
    }
    
    if (keyboard_check_direct(vk_up))
    {
        dup_timer++;
        
        if (dup_timer == 1 || (dup_timer > 20 && (dup_timer % 5) == 0))
        {
            var _len = array_length(dconsole_history);
            
            if (_len > 0 && sel_history_count < _len)
            {
                sel_history_count++;
                var _entry = _len - sel_history_count;
                dinput_text = dconsole_history[_entry];
                dcursor_pos = string_length(dinput_text);
                dselect_all = false;
                blink_cursor = ""|"";
                blink_timer = 0;
            }
        }
    }
    else
    {
        dup_timer = 0;
    }
    
    if (keyboard_check_direct(vk_down))
    {
        ddown_timer++;
        
        if (ddown_timer == 1 || (ddown_timer > 20 && (ddown_timer % 5) == 0))
        {
            if (sel_history_count > 0)
            {
                sel_history_count--;
                
                if (sel_history_count == 0)
                {
                    dinput_text = """";
                }
                else
                {
                    var _len = array_length(dconsole_history);
                    var _entry = _len - sel_history_count;
                    dinput_text = dconsole_history[_entry];
                }
                
                dcursor_pos = string_length(dinput_text);
                dselect_all = false;
                blink_cursor = ""|"";
                blink_timer = 0;
            }
        }
    }
    else
    {
        ddown_timer = 0;
    }
    
    blink_timer++;
    
    if (blink_timer > 30)
    {
        blink_cursor = (blink_cursor == ""|"") ? """" : ""|"";
        blink_timer = 0;
    }
    
    io_clear();
}");


importGroup.QueueReplace(obj_dconsole_system.EventHandlerFor(EventType.Draw, (uint)64, Data),
@"if (!dconsole_active)
    exit;

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, display_get_gui_width(), dconsole_height, false);
draw_set_color(c_dkgray);
draw_set_alpha(1);
draw_line(0, dconsole_height, display_get_gui_width(), dconsole_height);
draw_set_font(fnt_dotumche);
var _text_y = dconsole_height - 30;

if (dselect_all && dinput_text != """")
{
    var _prefix_width = string_width(""> "");
    var _full_width = string_width(dinput_text);
    draw_set_color(c_blue);
    draw_set_alpha(0.6);
    draw_rectangle(15 + _prefix_width, _text_y, 15 + _prefix_width + _full_width, _text_y + string_height(""A""), false);
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_text(15, _text_y, ""> "" + dinput_text);

if (!dselect_all && blink_cursor == ""|"")
{
    var _text_before_cursor = string_copy(dinput_text, 1, dcursor_pos);
    var _cursor_x = 15 + string_width(""> "" + _text_before_cursor);
    draw_line(_cursor_x, _text_y + 2, _cursor_x, (_text_y + string_height(""A"")) - 2);
}

var _max_width = display_get_gui_width() - 30;
var _line_spacing = string_height(""A"") + 6;
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
    
    if (string_copy(_log_str, 1, 5) == ""  -> "")
    {
        _pw = string_width(""  -> "");
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
    var _prefix = """";
    var _text = _log_str;
    
    if (string_copy(_log_str, 1, 5) == ""  -> "")
    {
        _prefix = ""  -> "";
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
}");


UndertaleScript scr_dconsole_command = Data.Scripts.ByName("scr_dconsole_command");
importGroup.QueueReplace("gml_GlobalScript_scr_dconsole_command",
@"function scr_dconsole_command(arg0)
{
    static _commands = 
    {
        help: function(arg0, arg1, arg2)
        {
            var _names = variable_struct_get_names(arg2);
            array_sort(_names, true);
            var _list_string = """";
            
            for (var _i = 0; _i < array_length(_names); _i++)
            {
                _list_string += (""/"" + _names[_i]);
                
                if (_i < (array_length(_names) - 1))
                    _list_string += "", "";
            }
            
            arg1(dstr(""Available commands: "", ""Commandes disponibles : "") + _list_string);
        },
        
        clear: function(arg0, arg1, arg2)
        {
            obj_dconsole_system.dconsole_log = [];
        },
        
        debug: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _val = string_lower(string(arg0[1]));
                
                if (_val == ""on"" || _val == ""true"" || _val == ""1"" || _val == ""enable"")
                {
                    global.debug = 1;
                    scr_debug_print(dstr(""Debug Mode activated!"", ""Mode Debug activé !""));
                    arg1(dstr(""Debug Mode activated!"", ""Mode Debug activé !""));
                }
                else if (_val == ""off"" || _val == ""false"" || _val == ""0"" || _val == ""disable"")
                {
                    global.debug = 0;
                    scr_debug_print(dstr(""Debug Mode deactivated!"", ""Mode Debug désactivé !""));
                    arg1(dstr(""Debug Mode deactivated!"", ""Mode Debug désactivé !""));
                }
                else
                {
                    arg1(dstr(""Error: Invalid input. "", ""Erreur : Saisie invalide. "") + ""Usage -> /debug opt:[on/off]"");
                }
            }
            else
            {
                global.debug = !global.debug;
                
                if (global.debug)
                {
                    scr_debug_print(dstr(""Debug Mode activated!"", ""Mode Debug activé !""));
                    arg1(dstr(""Debug Mode activated!"", ""Mode Debug activé !""));
                }
                else
                {
                    scr_debug_print(dstr(""Debug Mode deactivated!"", ""Mode Debug désactivé !""));
                    arg1(dstr(""Debug Mode deactivated!"", ""Mode Debug désactivé !""));
                }
            }
        },
        
        godmode: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _val = string_lower(string(arg0[1]));
                
                if (_val == ""on"" || _val == ""true"" || _val == ""1"" || _val == ""enable"")
                {
                    global.dgodmode = 1;
                    scr_debug_print(dstr(""Godmode enabled"", ""Godmode activé""));
                    arg1(dstr(""Godmode enabled"", ""Godmode activé""));
                }
                else if (_val == ""off"" || _val == ""false"" || _val == ""0"" || _val == ""disable"")
                {
                    global.dgodmode = 0;
                    scr_debug_print(dstr(""Godmode disabled"", ""Godmode désactivé""));
                    arg1(dstr(""Godmode disabled"", ""Godmode désactivé""));
                }
                else
                {
                    arg1(dstr(""Error: Invalid input. "", ""Erreur : Saisie invalide. "") + ""Usage -> /godmode opt:[on/off]"");
                }
            }
            else
            {
                global.dgodmode = !global.dgodmode;
                
                if (global.dgodmode)
                {
                    scr_debug_print(dstr(""Godmode enabled"", ""Godmode activé""));
                    arg1(dstr(""Godmode enabled"", ""Godmode activé""));
                }
                else
                {
                    scr_debug_print(dstr(""Godmode disabled"", ""Godmode désactivé""));
                    arg1(dstr(""Godmode disabled"", ""Godmode désactivé""));
                }
            }
        },
        
        setfps: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _fps_val = real(arg0[1]);
                global.speed_fps = _fps_val;
                game_set_speed(_fps_val, gamespeed_fps);
                scr_debug_print(dstr(""FPS to "", ""FPS à "") + string(_fps_val));
                arg1(dstr(""FPS was set to "", ""Le nombre de FPS a été fixé à "") + string(_fps_val));
            }
            else
            {
                arg1(dstr(""Error: Missing argument. Usage -> /fps [value]"", ""Erreur : Argument manquant. Usage -> /fps [valeur]""));
            }
        },
        
        money: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _money_val = real(arg0[1]);
                var gold_bk = global.gold;
                global.gold = _money_val;
                var _diff_val = _money_val - gold_bk;
                
                if (_diff_val >= 0)
                    scr_debug_print(dstr(""+ D$ "", ""+ "") + string(_diff_val) + dstr("""", "" $""));
                else
                    scr_debug_print(dstr(""- D$ "", ""- "") + string(abs(_diff_val)) + dstr("""", "" $""));
                
                arg1(dstr(""Money set to D$ "", ""La somme d'argent a été fixée à "") + string(_money_val) + dstr("""", "" $""));
            }
            else
            {
                arg1(dstr(""Error: Missing argument. Usage -> /money [value]"", ""Erreur : Argument manquant. Usage -> /money [valeur]""));
            }
        },
        
        vol: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _volume_val = real(arg0[1]);
                global.flag[17] = _volume_val / 100;
                audio_set_master_gain(0, global.flag[17]);
                scr_debug_print(dstr(""Master volume set to "", ""Volume principal réglé à "") + string(_volume_val) + dstr(""%"", "" %""));
                arg1(dstr(""Master volume set to "", ""Volume principal réglé à "") + string(_volume_val) + dstr(""%"", "" %""));
            }
            else
            {
                arg1(dstr(""Error: Missing argument. Usage -> /vol [value]"", ""Erreur : Argument manquant. Usage -> /vol [valeur]""));
            }
        }
    };
    
    var _clean_string = string_delete(arg0, 1, 1);
    var _args = string_split(_clean_string, "" "");
    
    if (array_length(_args) == 0)
        exit;
    
    var _cmd = string_lower(_args[0]);
    
    var _log = function(arg0)
    {
        if (dconsole_active)
            array_push(obj_dconsole_system.dconsole_log, ""  -> "" + arg0);
    };
    
    if (variable_struct_exists(_commands, _cmd))
    {
        var _func = variable_struct_get(_commands, _cmd);
        _func(_args, _log, _commands);
    }
    else
    {
        _log(dstr(""Unknown command: /"", ""Commande inconnue : /"") + _cmd + dstr("". Type /help to get a list of available commands"", "". Tapez /help pour voir la liste des commandes disponibles""));
    }
}");


UndertaleGameObject obj_dmenu_system = new UndertaleGameObject();
obj_dmenu_system.Name = Data.Strings.MakeString("obj_dmenu_system");
obj_dmenu_system.Visible = true;
obj_dmenu_system.Persistent = true;
obj_dmenu_system.Awake = true;
Data.GameObjects.Add(obj_dmenu_system);

importGroup.QueueReplace(obj_dmenu_system.EventHandlerFor(EventType.Create, (uint)0, Data),
@"dmenu_active = false;
dmenu_popup_launch = 0;
dmenu_box = 0;
dbutton_layout = 0;
dmenu_start_index = 0;
dbutton_max_visible = 5;
dmenu_arrow_timer = 0;
dscroll_timer = 0;
dscroll_cur_key = 0;
dscroll_delay = 15;
dscroll_speed = 1;
dbackspace_timer = 0;
dmenu_title = dstr(""Debug Menu"", ""Menu Debug"");
dbutton_options_original = [[dstr(""Warps"", ""Sauts""), dstr(""Items""), dstr(""Recruits"", ""Recrues""), dstr(""Flags"")], [dstr(""Globals""), dstr(""Debug save""), dstr(""Game Obj"")]];
dnumber_litems = [0, 11, 14, 14, 18, 23];
dlight_weapons = [];
dlight_armors = [[3, dstr(""Bandage"", ""Pansement"")], [14, dstr(""Wristwatch"", ""Montre"")]];
dlight_objects = [[1, dstr(""Hot Chocolate"", ""Chocolat Chaud"")], [2, dstr(""Pencil"", ""Crayon"")], [3, dstr(""Bandage"", ""Pansement"")], [4, dstr(""Bouquet"")], [5, dstr(""Ball of Junk"", ""Boule de Trucs"")], [6, dstr(""Halloween Pencil"", ""Crayon Halloween"")], [7, dstr(""Lucky Pencil"", ""Crayon Fétiche"")], [8, dstr(""Egg"", ""Œuf"")], [9, dstr(""Cards"", ""Cartes"")], [10, dstr(""Box of Heart Candy"", ""Boîte de ChocoCœurs"")], [11, dstr(""Glass"", ""Verre"")], [12, dstr(""Eraser"", ""Gomme"")], [13, dstr(""Mech. Pencil"", ""Critérium"")], [14, dstr(""Wristwatch"", ""Montre"")], [15, dstr(""Holiday Pencil"", ""Crayon de Noël"")], [16, dstr(""CactusNeedle"", ""Épine de Cactus"")], [17, dstr(""BlackShard"", ""ÉclatNoir"")], [18, dstr(""QuillPen"", ""Stylo-Plume"")], [19, dstr(""Honey Toast"", ""Tartine de Miel"")], [20, dstr(""Bread"", ""Pain"")], [21, dstr(""Seeds"", ""Graines"")], [22, dstr(""Pencil2"", ""Crayon2"")], [23, dstr(""Petal"", ""Pétale"")]];
dhinter_active = false;
itemdescb = """";
armordesctemp = """";
weapondesctemp = """";
tempkeyitemdesc = """";
dhinter_text = """";
global.dload_cur_inv = 0;
dtemp_text = """";
dtemp_num = 0;

if (global.chapter >= 4)
{
    dtemp_lst = get_lw_dw_weapon_list();
    
    for (i = 0; i < array_length(dtemp_lst); i++)
        array_push(dlight_weapons, dlight_objects[dtemp_lst[i].lw_id - 1]);
}
else
{
    dlight_weapons = [[2, dstr(""Pencil"", ""Crayon"")], [6, dstr(""Halloween Pencil"", ""Crayon Halloween"")], [7, dstr(""Lucky Pencil"", ""Crayon Fétiche"")], [12, dstr(""Eraser"", ""Gomme"")], [13, dstr(""Mech. Pencil"", ""Critérium"")]];
}

for (i = 0; i < array_length(dlight_objects); i++)
{
    if (dlight_objects[i][0] > dnumber_litems[global.chapter])
        array_delete(dlight_objects, i--, 1);
}

if (global.chapter == 1)
{
    array_delete(dlight_weapons, 3, 2);
    array_delete(dlight_armors, 1, 1);
    array_delete(dlight_objects, 8, 1);
    array_delete(dlight_objects, 8, 1);
}

if (global.chapter < 3)
    array_delete(dbutton_options_original[0], 2, 1);

dbutton_options = [];
dbutton_options_2d = dbutton_options_original;
dmenu_state = ""debug"";
dvertical_index = 0;
dhorizontal_page = 0;
dhorizontal_index = 0;
dmenu_state_history = [];
dmenu_vertical_index_history = [];
dmenu_horizontal_index_history = [];
dmenu_page_index_history = [];
dgiver_menu_state = 0;
dgiver_button_selected = 0;
dgiver_amount = 1;
dgiver_bname = 0;
dbutton_indices = [];
ditem_types = [""objects"", ""armors"", ""weapons"", ""keyitems""];
ditem_chap = global.chapter;

global.ditem_data = [
    [],
    [ { start_id: 1,  count: 15 } ],
    [ { start_id: 16, count: 18 } ],
    [ { start_id: 34, count: 6  } ],
    [ { start_id: 60, count: 4  } ],
    [ { start_id: 40, count: 4  }, { start_id: 64, count: 7 } ]
];

global.darmor_data = [
    [],
    [ { start_id: 1,  count: 7 } ],
    [ { start_id: 8, count: 15 } ],
    [ { start_id: 23, count: 5  } ],
    [ { start_id: 50, count: 5  } ],
    [ { start_id: 30, count: 9  }]
];

global.dweapon_data = [
    [],
    [ { start_id: 1,  count: 10 } ],
    [ { start_id: 11, count: 12 } ],
    [ { start_id: 23, count: 4  } ],
    [ { start_id: 50, count: 5  } ],
    [ { start_id: 30, count: 8  }]
];

global.dkeyitem_data = [
    [],
    [ { start_id: 1,  count: 7 } ],
    [ { start_id: 8, count: 8 } ],
    [ { start_id: 16, count: 4  } ],
    [ { start_id: 30, count: 2  } ],
    [ { start_id: 20, count: 10  }, { start_id: 32, count: 2} ]
];

dpop_history = function()
{
    dmenu_skip_reindexing = true;
    dkeyboard_input = """";
    
    if (array_length(dmenu_state_history) > 0)
    {
        dmenu_state = array_pop(dmenu_state_history);
    }
    else
    {
        if (!(dmenu_popup_launch == 1 && dmenu_state == ""debug_save""))
            global.interact = 0;
        
        dmenu_popup_launch = 0;
        dmenu_active = !dmenu_active;
        dmenu_state = ""debug"";
        dbutton_options = dbutton_options_original;
        dmenu_state_history = [];
        dmenu_vertical_index_history = [];
        dmenu_horizontal_index_history = [];
        dmenu_page_index_history = [];
        dvertical_index = 0;
        dmenu_state_update();
    }
    
    if (array_length(dmenu_vertical_index_history) > 0)
        dvertical_index = array_pop(dmenu_vertical_index_history);
    
    if (array_length(dmenu_horizontal_index_history) > 0)
        dhorizontal_index = array_pop(dmenu_horizontal_index_history);
    
    if (array_length(dmenu_page_index_history) > 0)
        dhorizontal_page = array_pop(dmenu_page_index_history);
    
    dmenu_state_update();
    dmenu_start_index = clamp(dvertical_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
};

dremove_false_history = function()
{
    if (array_length(dmenu_state_history) > 0)
        array_pop(dmenu_state_history);
    
    if (array_length(dmenu_vertical_index_history) > 0)
        array_pop(dmenu_vertical_index_history);
    
    if (array_length(dmenu_horizontal_index_history) > 0)
        array_pop(dmenu_horizontal_index_history);
    
    if (array_length(dmenu_page_index_history) > 0)
        array_pop(dmenu_page_index_history);
};

ditem_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.ditem_data)) {
        return []; 
    }
    
    return global.ditem_data[_chap];
};

darmor_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.darmor_data)) {
        return []; 
    }
    
    return global.darmor_data[_chap];
};

dweapon_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.dweapon_data)) {
        return []; 
    }
    
    return global.dweapon_data[_chap];
};

dkeyitem_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.dkeyitem_data)) {
        return []; 
    }
    
    return global.dkeyitem_data[_chap];
};

extract_global_infos = function(arg0)
{
};

cate_enum = 0;
GONER = cate_enum++;
SUPERBOSS = cate_enum++;
WEIRD2 = cate_enum++;
SEAM = cate_enum++;
ZOEUFS = cate_enum++;
ONION_SAN = cate_enum++;
MISC1 = cate_enum++;
MISC2 = cate_enum++;
LOT = cate_enum++;
SWORD3 = cate_enum++;
MISC3 = cate_enum++;
MISC4 = cate_enum++;
MOUSSE = cate_enum++;
ROBOTEUR = cate_enum++;
dother_categories = [dstr(""Vessel Sequence"", ""Séquence Vaisseau""), dstr(""Superbosses""), dstr(""Weird Route""), dstr(""Seam""), dstr(""Eggs"", ""Œufs""), dstr(""Onion San""), dstr(""Misc Chap 1"", ""Divers chap 1""), dstr(""Misc Chap 2"", ""Divers chap 2""), dstr(""Legend of Tenna""), dstr(""Sword Route""), dstr(""Misc Chap 3"", ""Divers chap 3""), dstr(""Misc Chap 4"", ""Divers chap 4""), dstr(""Moss"", ""Mousse""), dstr(""Thrash Machine"", ""Roboteur"")];
dother_all_options = [];
dother_options = [];

if (global.chapter >= 0)
{
    array_push(dother_all_options, [GONER, dstr(""FAVORITE FOOD"", ""NOURRITURE""), 903, [[dstr(""SWEET"", ""SUCRÉE""), 0], [dstr(""SOFT"", ""TENDRE""), 1], [dstr(""BITTER"", ""AMÈRE""), 2], [dstr(""SALTY"", ""SALÉE""), 3], [dstr(""PAIN"", ""DOULEUR""), 4], [dstr(""COLD"", ""FROIDE""), 5]]]);
    array_push(dother_all_options, [GONER, dstr(""BLOOD TYPE"", ""GROUPE SANGUIN""), 904, [[""A"", 0], [""AB"", 1], [""B"", 2], [""C"", 3], [""D"", 4]]]);
    array_push(dother_all_options, [GONER, dstr(""FAVORITE COLOR"", ""COULEUR""), 905, [[dstr(""RED"", ""ROUGE""), 0], [dstr(""BLUE"", ""BLEU""), 1], [dstr(""GREEN"", ""VERT""), 2], [dstr(""CYAN""), 3]]]);
    array_push(dother_all_options, [GONER, dstr(""GIFT"", ""PRÉSENT""), 909, [[dstr(""KINDNESS"", ""GENTILLESSE""), -1], [dstr(""MIND"", ""ESPRIT""), 0], [dstr(""AMBITION""), 1], [dstr(""BRAVERY"", ""BRAVOURE""), 2], [dstr(""VOICE"", ""VOIX""), 3]]]);
    array_push(dother_all_options, [GONER, dstr(""OPINION"", ""SENTIMENT ÉPROUVÉ""), 906, [[dstr(""LOVE"", ""AMOUR""), 0], [dstr(""HOPE"", ""ESPOIR""), 1], [dstr(""DISGUST"", ""DÉGOÛT""), 2], [dstr(""FEAR"", ""PEUR""), 3]]]);
    array_push(dother_all_options, [GONER, dstr(""ANSWERED HONESTLY"", ""RÉPONDU HONNÊTEMENT""), 907, [[dstr(""Yes"", ""Oui""), 0], [dstr(""No"", ""Non""), 1]]]);
    array_push(dother_all_options, [GONER, dstr(""CONSENT TO CRISES"", ""CONSENTIR AUX CRISES""), 908, [[dstr(""Yes"", ""Oui""), 0], [dstr(""No"", ""Non""), 1]]]);
}

if (global.chapter >= 1)
{
    array_push(dother_all_options, [ROBOTEUR, dstr(""Thrash Head"", ""Tête Roboteur""), 220, [[dstr(""Laser""), 0], [dstr(""Sword"", ""Épée""), 1], [dstr(""Flame"", ""Flamme""), 2], [dstr(""Duck"", ""Canard""), 3]]]);
    array_push(dother_all_options, [ROBOTEUR, dstr(""Thrash Body"", ""Corps Roboteur""), 221, [[dstr(""Simple"", ""Sobre""), 0], [dstr(""Wheel"", ""Roue""), 1], [dstr(""Tank""), 2], [dstr(""Duck"", ""Canard""), 3]]]);
    array_push(dother_all_options, [ROBOTEUR, dstr(""Thrash Legs"", ""Jambes Roboteur""), 222, [[dstr(""Sneakers"", ""Baskets""), 0], [dstr(""Tires"", ""Pneus""), 1], [dstr(""Tracks"", ""Chaînes""), 2], [dstr(""Duck"", ""Canard""), 3]]]);
    array_push(dother_all_options, [MISC1, dstr(""Gang Name"", ""Nom du gang""), 214, [[dstr(""The Guys (unused)"", ""Les Types (unused)""), 0], [dstr(""The $!$! Squad"", ""L'Escouade $?$!$""), 1], [dstr(""Lancer Fan Club"", ""Le Fan Club Lancer""), 2], [dstr(""The Fun Gang"", ""Le Fun Gang""), 3]]]);
    array_push(dother_all_options, [MISC1, dstr(""Prophecy heard"", ""Prophétie entendu""), 203, [[dstr(""No"", ""Non""), 1], [dstr(""Yes"", ""Oui""), 0]]]);
    array_push(dother_all_options, [MISC1, dstr(""Manual thrown"", ""Manuel jeté""), 207, [[dstr(""No"", ""Non""), 0], [dstr(""Tried"", ""A tenté""), 1], [dstr(""Thrown"", ""L'a jeté""), 2]]]);
    array_push(dother_all_options, [MISC1, dstr(""Cake returned"", ""Gâteau rendu""), 253, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC1, dstr(""Starwalker""), 254, [[""Pissing me off"", 0], [""I will join"", 1]]]);
    array_push(dother_all_options, [MISC1, dstr(""Donation Goal"", ""Objectif de Donation""), 216, [[dstr(""No"", ""Non""), 0], [dstr(""Reached"", ""Atteint""), 1]]]);
    array_push(dother_all_options, [MISC1, dstr(""Asgore's Flowers"", ""Fleurs d'Asgore""), 262, [[dstr(""Not seen"", ""Pas vu""), 0], [dstr(""No"", ""Non""), 2], [dstr(""Given"", ""Données""), 4]]]);
    array_push(dother_all_options, [MISC1, dstr(""Noelle outside"", ""Noelle dehors""), 276, [[dstr(""No"", ""Non""), 0], [dstr(""No"", ""Non""), 1], [dstr(""Talked to Susie"", ""A parlé à Susie""), 2]]]);
    array_push(dother_all_options, [MISC1, dstr(""Sink inspected (ch 1)"", ""Évier inspecté (chap 1)""), 278, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [ZOEUFS, dstr(""Egg obtained (ch 1)"", ""Œuf obtenu (chap 1)""), 911, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr(""Jevil defeated"", ""Jevil vaincu""), 241, [[dstr(""No"", ""Non""), 0], [dstr(""Via violence""), 6], [dstr(""Via mercy"", ""Via clémence""), 7]]]);
    array_push(dother_all_options, [ONION_SAN, dstr(""Relation (ch 1)"", ""Relation (chap 1)""), 258, [[dstr(""Not seen"", ""Pas vu""), 0], [dstr(""Friends"", ""Amis""), 2], [dstr(""Not friends"", ""Pas amis""), 3]]]);
    array_push(dother_all_options, [ONION_SAN, dstr(""Kris's Name"", ""Nom de Kris""), 259, [[dstr(""No"", ""Non""), 0], [""Kris"", 1], [dstr(""Hippo"", ""Hippopotame""), 2]]]);
    array_push(dother_all_options, [ONION_SAN, dstr(""Onion's Name"", ""Nom d'Onion""), 260, [[dstr(""No"", ""Non""), 0], [dstr(""Onyx"", ""Oignon""), 1], [dstr(""Beauty"", ""Beauté""), 2], [dstr(""Asriel II""), 3], [dstr(""Stinky"", ""Dégoûtant""), 4]]]);
    array_push(dother_all_options, [MOUSSE, dstr(""Moss eaten (ch 1)"", ""Mousse mangée (chap 1)""), 106, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
}

if (global.chapter >= 2)
{
    array_push(dother_all_options, [MISC2, dstr(""Plushie"", ""Peluche""), 307, [[dstr(""Not given"", ""Pas donnée""), 0], [""Ralsei"", 1], [""Susie"", 2], [""Noëlle"", 3], [""Berdly"", 4]]]);
    array_push(dother_all_options, [MISC2, dstr(""Hacker recruited"", ""Hacker recruté""), 659, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC2, dstr(""Berdly's Arm"", ""Bras de Berdly""), 457, [[dstr(""Burnt"", ""Brûlé""), 0], [dstr(""Ok""), 1]]]);
    array_push(dother_all_options, [MISC2, dstr(""Mettaton 'Fan'"", ""\""Fan\"" de Mettaton""), 422, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC2, dstr(""Susie Statue collected"", ""Statue de Susie récupérée""), 393, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC2, dstr(""ICE-E collected"", ""ICE-E récupéré""), 394, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC2, dstr(""Sink inspected (ch 2)"", ""Évier inspecté (chap 2)""), 461, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC2, dstr(""Shelter scene seen"", ""Scène de l'abri vue""), 315, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [WEIRD2, dstr(""Progress"", ""Avancée""), 915, [[dstr(""No"", ""Non""), 0], [dstr(""Addison killed"", ""Nikomercant tué""), 3], [dstr(""Berdly frozen"", ""Berdly gelé""), 6], [dstr(""Talked to Susie"", ""A parlé à Susie""), 9], [dstr(""Noelle at hospital"", ""Noëlle à l'hôpital""), 20]]]);
    array_push(dother_all_options, [WEIRD2, dstr(""Canceled Weird Route"", ""A annulé la weird route""), 916, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [ZOEUFS, dstr(""Egg obtained (ch 2)"", ""Œuf obtenu (chap 2)""), 918, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr(""Spamton defeated"", ""Spamton vaincu""), 309, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 9]]]);
    array_push(dother_all_options, [ONION_SAN, dstr(""Relation (ch 2)"", ""Relation (chap 2)""), 425, [[dstr(""Not seen"", ""Pas vu""), 0], [dstr(""Friends"", ""Amis""), 1], [dstr(""Not friends anymore"", ""Plus amis""), 2]]]);
    array_push(dother_all_options, [MOUSSE, dstr(""Moss eaten (ch 2)"", ""Mousse mangée (chap 2)""), 920, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr(""... with Noelle"", ""... avec Noëlle""), 921, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr(""... with Susie"", ""... avec Susie""), 922, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SEAM, dstr(""Seam gave up quest"", ""Seam a abandonné la quête""), 961, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SEAM, dstr(""Jevil's Crystal given"", ""Cristal de Jevil donné""), 954, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SEAM, dstr(""Spamton's Crystal given"", ""Cristal de Spamton donné""), 353, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SEAM, dstr(""Talked to Seam"", ""A parlé à Seam tout court""), 312, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
}

if (global.chapter >= 3)
{
    array_push(dother_all_options, [LOT, dstr(""LOT Board 1 Rank"", ""LOT Rang Board 1""), 1173, [[""Z"", 0], [""C"", 1], [""B"", 2], [""A"", 3], [""S"", 4], [""T"", 5]]]);
    array_push(dother_all_options, [LOT, dstr(""LOT Board 2 Rank"", ""LOT Rang Board 2""), 1174, [[""Z"", 0], [""C"", 1], [""B"", 2], [""A"", 3], [""S"", 4], [""T"", 5]]]);
    array_push(dother_all_options, [SWORD3, dstr(""Sword Route Progress"", ""Avancée Sword Route""), 1055, [[dstr(""Not seen"", ""Pas vu""), 0], [dstr(""Ice Key obtained"", ""Clé de glace obtenue""), 1], [dstr(""Dungeon (Floor 2)"", ""Donjon (plateau 2)""), 1.5], [dstr(""Key used"", ""Clé utilisée""), 2], [dstr(""Shelter Key obtained"", ""Clé de l'abri obtenue""), 3], [dstr(""Dungeon (Floor 3)"", ""Donjon (plateau 3)""), 4], [dstr(""Shelter Key used"", ""Clé de l'abri utilisée""), 5], [dstr(""ERAM defeated"", ""ERAM vaincu""), 6]]]);
    array_push(dother_all_options, [SWORD3, dstr(""Susie attacked"", ""Susie attaquée""), 1268, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [ZOEUFS, dstr(""Egg obtained (ch 3)"", ""Œuf obtenu (chap 3)""), 930, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr(""Knight defeated"", ""Chevalier vaincu""), 1047, [[dstr(""No"", ""Non""), 2], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC3, dstr(""Fountain"", ""Fontaine""), 1144, [[dstr(""Not seen"", ""Pas vu""), 0], [dstr(""Flirted (no curtain)"", ""A flirté (pas au rideau)""), 1], [dstr(""No flirt"", ""Pas flirté""), 2], [dstr(""Flirted (talked to curtain)"", ""A flirté (au rideau)""), 3]]]);
    array_push(dother_all_options, [MISC3, dstr(""Tenna Statue collected"", ""Statue de Tenna récupérée""), 1222, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr(""Moss eaten (ch 3)"", ""Mousse mangée (chap 3)""), 1078, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SEAM, dstr(""Knight's Crystal given"", ""Cristal du Chevalier donné""), 856, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
}

if (global.chapter >= 4)
{
    array_push(dother_all_options, [ZOEUFS, dstr(""Egg obtained (ch 4)"", ""Œuf obtenu (chap 4)""), 931, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr(""Gerson defeated"", ""Gerson vaincu""), 1629, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr(""Moss eaten (ch 4)"", ""Mousse mangée (chap 4)""), 1592, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1], [dstr(""Refused"", ""Refusée""), 2]]]);
    array_push(dother_all_options, [MISC4, dstr(""Ralsei's Room"", ""Chambre de Ralsei""), 710, [[dstr(""Not seen"", ""Pas vu""), 0], [dstr(""Seen"", ""Vu""), 2]]]);
    array_push(dother_all_options, [MISC4, dstr(""QC's with Susie"", ""QC avec Susie""), 701, [[dstr(""No"", ""Non""), 0], [dstr(""Visited"", ""Y est allé""), 1]]]);
    array_push(dother_all_options, [MISC4, dstr(""Tea with Ralsei"", ""Thé avec Ralsei""), 1514, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC4, dstr(""Prayer"", ""Prière""), 1507, [[dstr(""No"", ""Non""), 0], [dstr(""For Susie"", ""Pour Susie""), 1], [dstr(""For Noelle"", ""Pour Noëlle""), 2], [dstr(""For Asriel"", ""Pour Asriel""), 3]]]);
    array_push(dother_all_options, [MISC4, dstr(""Tenna given"", ""Tenna donné""), 779, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 2]]]);
    array_push(dother_all_options, [MISC4, dstr(""Noelle's Phone"", ""Tel. de Noëlle""), 714, [[dstr(""Not inspected"", ""Pas inspecté""), 0], [dstr(""Didn't answer"", ""Pas répondu""), 1], [dstr(""Go to festival"", ""Allez au festival""), 2], [dstr(""Wrong number song""), 3]]]);
    array_push(dother_all_options, [MISC4, dstr(""Susie's Prize collected"", ""Prix Susie récupéré""), 747, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC4, dstr(""Stain removed"", ""Tache retirée""), 748, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC4, dstr(""Ladder collected"", ""Échelle récupérée""), 864, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
    array_push(dother_all_options, [MISC4, dstr(""Pillow collected"", ""Oreiller récupéré""), 865, [[dstr(""No"", ""Non""), 0], [dstr(""Yes"", ""Oui""), 1]]]);
}

dflag_categories_len = [];

for (i = 0; i < array_length(dother_categories); i++)
    array_push(dflag_categories_len, 0);

for (i = 0; i < array_length(dother_all_options); i++)
    dflag_categories_len[dother_all_options[i][0]] += 1;

dglobal_changer_options = [[""Custom"", ""string"", -1]];
array_push(dglobal_changer_options, [""truename"", ""string"", -1]);
array_push(dglobal_changer_options, [""othername"", ""string"", 6]);
array_push(dglobal_changer_options, [""gold"", ""int"", -1]);
array_push(dglobal_changer_options, [""maxhp"", ""uint"", 5]);
array_push(dglobal_changer_options, [""hp"", ""int"", 5]);
array_push(dglobal_changer_options, [""at"", ""int"", 5]);
array_push(dglobal_changer_options, [""df"", ""int"", 5]);
array_push(dglobal_changer_options, [""mag"", ""int"", 5]);
global.dreading_custom_flag = 0;
dcustom_flag_text = ["""", """"];
dkeys_helper = 0;
dkeys_data = [];
drooms_id = scr_get_room_list();
drooms = [];
drooms_options = 
{
    target_room: ROOM_INITIALIZE,
    target_plot: global.plot,
    target_is_darkzone: global.darkzone,
    target_member_2: global.char[1],
    target_member_3: global.char[2]
};
dkeyboard_input = """";

for (i = 0; i < array_length(drooms_id); i++)
    array_push(drooms, room_get_name(drooms_id[i].room_index));

obj_list = [];
all_obj_list = [];
var index = 0;

while (true)
{
    var obj_name = object_get_name(index);

    if (obj_name == ""<undefined>"" || obj_name == """")
    {
        break;
    }

    array_push(all_obj_list, obj_name);
    index++;
}

find_subarray_index = function(arg0, arg1)
{
    value = global.flag[arg0];
    lst = arg1;
    prev = 0;
    
    for (i = 0; i < array_length(lst); i++)
    {
        if (lst[i][1] > value)
            break;
        
        prev = i;
    }
    
    return prev;
};

draw_monospace = function(arg0, arg1, arg2)
{
    draw_x = arg0;
    sep = (global.darkzone == 1) ? 15 : 8;
    
    for (i = 0; i < string_length(arg2); i++)
    {
        draw_text(draw_x, arg1, string_char_at(arg2, i + 1));
        draw_x += sep;
    }
};

draw_monospace_ext = function(arg0, arg1, arg2, arg3, arg4)
{
    var _start_x = arg0;
    var _start_y = arg1;
    var _text = string(arg2);
    var _line_sep = arg3;
    var _max_width = arg4;
    var _char_sep = (global.darkzone == 1) ? 15 : 8;
    var _draw_x = _start_x;
    var _draw_y = _start_y;
    var _current_word = """";
    var _text_len = string_length(_text);
    
    for (var i = 1; i <= _text_len; i++)
    {
        var _char = string_char_at(_text, i);
        
        if (_char != "" "" && _char != ""\n"")
            _current_word += _char;
        
        if (_char == "" "" || _char == ""\n"" || i == _text_len)
        {
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
            
            _current_word = """";
            
            if (_char == "" "")
            {
                _draw_x += _char_sep;
            }
            else if (_char == ""\n"")
            {
                _draw_x = _start_x;
                _draw_y += _line_sep;
            }
        }
    }
};

set_keyboard_reader = function(arg0)
{
    global.dreading_custom_flag = arg0;
    keyboard_string = """";
    dcustom_flag_text = ["""", """"];
    global.dkeyboard_text = """";
};

dload_options = 
{
    target_save: -1,
    target_with_cur_inv: global.dload_cur_inv
};

function parse_var_str(arg0, arg1)
{
    str = arg0;
    check_error = arg1;
    is_good = scr_string_respect_type(str, ""variable"", 1, check_error);
    dtemp_text = """";
    dtemp_num = 0;
    
    if (!is_good)
        return 0;
    
    brack_start = string_pos(""["", str);
    
    if (brack_start == 0)
    {
        dtemp_text = str;
        dtemp_num = -1;
    }
    else
    {
        dtemp_text = string_copy(str, 1, brack_start - 1);
        dtemp_num = real(string_copy(str, brack_start + 1, string_length(str) - brack_start - 1));
    }
    
    return 1;
}

dmenu_expanded = {};
dmenu_last_search = """";
dmenu_was_searching = false;
my_options = [];

function dmenu_process_submenus(arg0, arg1 = """")
{
    my_options = array_create(array_length(dbutton_options));
    array_copy(my_options, 0, dbutton_options, 0, array_length(dbutton_options));
    var _state_tracker = variable_struct_exists(dmenu_expanded, dmenu_state) ? variable_struct_get(dmenu_expanded, dmenu_state) : array_create(array_length(dbutton_options), false);
    
    while (array_length(_state_tracker) < array_length(my_options))
        array_push(_state_tracker, false);
    
    var _search = string_lower(arg1);
    var _search_changed = dmenu_last_search != _search;
    dmenu_last_search = _search;
    
    if (_search == """" && dmenu_was_searching)
    {
        for (var k = 0; k < array_length(_state_tracker); k++)
            _state_tracker[k] = false;
        
        dmenu_was_searching = false;
    }
    else if (_search != """")
    {
        dmenu_was_searching = true;
    }
    
    var _temp_options = [];
    var _temp_indices = [];
    var _temp_base_indices = [];
    var _needs_struct_save = false;
    
    for (var i = 0; i < array_length(my_options); i++)
    {
        var _base_name = my_options[i];
        var _is_dropdown = i < array_length(arg0) && is_array(arg0[i]);
        var _original_index = (i < array_length(dbutton_indices)) ? dbutton_indices[i] : -1;
        var _is_persistent = _original_index == -2;
        var _cat_match = true;
        var _sub_match = false;
        
        if (_search != """" && !_is_persistent)
        {
            _cat_match = string_pos(_search, string_lower(_base_name)) > 0;
            
            if (_is_dropdown)
            {
                var _submenu = arg0[i];
                
                for (var j = 0; j < array_length(_submenu); j++)
                {
                    if (string_pos(_search, string_lower(_submenu[j])) > 0)
                        _sub_match = true;
                }
                
                if (_search_changed && _state_tracker[i] != _sub_match)
                {
                    _state_tracker[i] = _sub_match;
                    _needs_struct_save = true;
                }
            }
            
            if (!_cat_match && !_sub_match)
                continue;
        }
        
        var _is_open = _is_dropdown && _state_tracker[i] == true;
        var _display_name = _base_name;
        
        if (_is_dropdown)
            _display_name += (_is_open ? "" ^"" : "" v"");
        
        array_push(_temp_options, _display_name);
        array_push(_temp_indices, _original_index);
        array_push(_temp_base_indices, i);
        
        if (_is_open)
        {
            var _submenu = arg0[i];
            var _subindices = (array_length(arg0) > (i + 1000) && is_array(arg0[i + 1000])) ? arg0[i + 1000] : [];
            
            for (var j = 0; j < array_length(_submenu); j++)
            {
                if (_search == """" || _cat_match || string_pos(_search, string_lower(_submenu[j])) > 0)
                {
                    array_push(_temp_options, ""- "" + _submenu[j]);
                    var exact_index = (array_length(_subindices) > j) ? _subindices[j] : -1;
                    array_push(_temp_indices, exact_index);
                    array_push(_temp_base_indices, i);
                }
            }
        }
    }
    
    if (_needs_struct_save || !variable_struct_exists(dmenu_expanded, dmenu_state))
        variable_struct_set(dmenu_expanded, dmenu_state, _state_tracker);
    
    dbutton_options = _temp_options;
    dbutton_indices = _temp_indices;
    dbutton_base_indices = _temp_base_indices;
}

function dmenu_interact_submenus(arg0)
{
    var _clicked_index = -1;
    
    for (var i = 0; i < array_length(my_options); i++)
    {
        var _base_name = my_options[i];
        
        if (arg0 == (_base_name + "" v"") || arg0 == (_base_name + "" ^""))
        {
            _clicked_index = i;
            break;
        }
    }
    
    if (_clicked_index != -1 && variable_struct_exists(dmenu_expanded, dmenu_state))
    {
        var _state_tracker = variable_struct_get(dmenu_expanded, dmenu_state);
        
        if (_clicked_index < array_length(_state_tracker))
        {
            _state_tracker[_clicked_index] = !_state_tracker[_clicked_index];
            variable_struct_set(dmenu_expanded, dmenu_state, _state_tracker);
            dmenu_skip_reindexing = true;
            dremove_false_history();
            return true;
        }
    }
    
    return false;
}
");


importGroup.QueueReplace(obj_dmenu_system.EventHandlerFor(EventType.Step, (uint)0, Data),
@"dmenu_arrow_timer += 1;

if (dmenu_popup_launch == 1)
{
    dmenu_state_update();
    global.interact = 1;
}

if (dmenu_state == ""debug_save"")
{
    if (keyboard_check_pressed(ord(""I"")) && keyboard_check(vk_alt) && !global.dreading_custom_flag)
    {
        scr_debug_save_scan_imports();
        scr_get_debug_save_list();
        dmenu_state_update();
    }
    else if (keyboard_check_pressed(ord(""I"")) && !keyboard_check(vk_alt) && !global.dreading_custom_flag)
    {
        scr_debug_save_import();
        scr_get_debug_save_list();
        dmenu_state_update();
    }
}

if (dmenu_popup_launch != 1)
{
    if (!global.dreading_custom_flag && keyboard_check_pressed(ord(""D"")))
    {
        dmenu_active = !dmenu_active;
        
        if (dmenu_active)
        {
            dmenu_previous_interact = global.interact;
            snd_play(snd_egg);
            global.interact = 1;
        }
        else
        {
            snd_play(snd_smallswing);
            global.interact = dmenu_previous_interact;
        }
    }
}

function dmenu_pressed_key(arg0)
{
    if (arg0 != 40 && arg0 != 38 && arg0 != 37 && arg0 != 39 && arg0 != 8)
        return 0;
    
    if (keyboard_check_pressed(arg0))
    {
        dscroll_cur_key = arg0;
        dscroll_timer = 0;
        return 1;
    }
    
    if (arg0 != dscroll_cur_key)
        return 0;
    
    if (keyboard_check(arg0))
    {
        dscroll_timer += 1;
        
        if (dscroll_timer >= dscroll_delay)
        {
            if ((dscroll_timer % dscroll_speed) == 0)
                return 2;
        }
    }
    else if (arg0 == dscroll_cur_key)
    {
        dscroll_timer = 0;
        dscroll_cur_key = 0;
    }
    
    return 0;
}

function vmove_menu(arg0, arg1)
{
    pressed_up = arg0;
    pressed_down = arg1;
    
    if (pressed_up != 0 || pressed_down != 0)
    {
        if (pressed_up == 1 && dvertical_index == 0)
        {
            dvertical_index = array_length(dbutton_options);
            dmenu_start_index = dvertical_index - 2;
        }
        else if (pressed_down == 1 && dvertical_index == (array_length(dbutton_options) - 1))
        {
            dvertical_index = -1;
            dmenu_start_index = 0;
        }
        
        increment = pressed_up ? -1 : 1;
        
        if ((pressed_up && dvertical_index != 0) || (pressed_down && dvertical_index != (array_length(dbutton_options) - 1)))
        {
            dvertical_index += increment;
            snd_play(snd_menumove);
            
            if (pressed_up && dvertical_index < dmenu_start_index)
                dmenu_start_index += increment;
            else if (pressed_down && (dvertical_index + 1) > (dmenu_start_index + dbutton_max_visible))
                dmenu_start_index += increment;
            
            if (dmenu_state == ""flag_misc"")
            {
                new_options = dother_options[dvertical_index];
                dhorizontal_index = find_subarray_index(new_options[2], new_options[3]);
            }
        }
    }
}

function evaluate_custom_flag(arg0, arg1)
{
    scr_debug_print(""Checking for "" + string(arg1));
    proper_exit = arg0;
    
    if (!proper_exit)
    {
        set_keyboard_reader(0);
        return 0;
    }
    
    first_type = arg1;
    proper_exit = scr_string_respect_type(dcustom_flag_text[0], first_type, 1, 1);
    
    if (dmenu_state != ""flag_categories"")
        return proper_exit;
    
    proper_exit = scr_string_respect_type(dcustom_flag_text[1], ""real"", 0, 1);
    
    if (string_length(dcustom_flag_text[1]) == 0)
    {
        if (proper_exit)
            scr_debug_print(""global.flag["" + string(real(dcustom_flag_text[0])) + ""] = |"" + string(global.flag[real(dcustom_flag_text[0])]) + ""|"");
        else
            scr_debug_print(dstr(""Empty value"", ""Valeur vide""));
        
        proper_exit = 0;
    }
    
    if (proper_exit)
    {
        scr_debug_print(dstr(""Updated "", ""Mise à jour de "") + ""global.flag["" + string(real(dcustom_flag_text[0])) + ""]"" + dstr("" from "", "" de "") + ""|"" + string(global.flag[real(dcustom_flag_text[0])]) + ""|"" + dstr("" to "", "" à "") + ""|"" + dcustom_flag_text[1] + ""|"");
        global.flag[real(dcustom_flag_text[0])] = real(dcustom_flag_text[1]);
    }
    
    if (proper_exit)
    {
        dmenu_active = 0;
        global.interact = 0;
    }
    
    return proper_exit;
}

if (keyboard_check_pressed(vk_left) && !global.dreading_custom_flag)
{
    if (variable_instance_exists(id, ""dbutton_base_indices"") && array_length(dbutton_base_indices) > dvertical_index)
    {
        var target_base_index = dbutton_base_indices[dvertical_index];
        var state_tracker = variable_struct_get(dmenu_expanded, dmenu_state);
        
        if (is_array(state_tracker) && state_tracker[target_base_index] == true)
        {
            state_tracker[target_base_index] = false;
            variable_struct_set(dmenu_expanded, dmenu_state, state_tracker);
            
            for (var idx = 0; idx < array_length(dbutton_base_indices); idx++)
            {
                if (dbutton_base_indices[idx] == target_base_index)
                {
                    dvertical_index = idx;
                    break;
                }
            }
            
            if (dvertical_index < dmenu_start_index)
                dmenu_start_index = dvertical_index;
            
            dmenu_state_update();
            
            if (variable_instance_exists(id, ""dbutton_max_visible""))
                dmenu_start_index = clamp(dmenu_start_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
            
            snd_play(snd_select);
            keyboard_clear(vk_left);
        }
    }
}

if (dmenu_active && global.dreading_custom_flag)
{
    update_visu = 1;
    will_exit = 0;
    reading_double_flag = dmenu_state == ""flag_categories"" || (dmenu_state == ""globals_changer"" && dvertical_index == 0);
    
    if (!reading_double_flag)
        dkeyboard_input = dcustom_flag_text[0];
    
    will_exit = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(global.input_k[7]);
    will_exit |= (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down));
    
    if (will_exit)
    {
        clean_exit = !keyboard_check_pressed(vk_escape);
        
        if (clean_exit)
        {
            if (dmenu_state == ""flag_categories"" || dmenu_state == ""warp_options"" || dmenu_state == ""globals_changer"")
            {
                check_type = ""uint"";
                
                if (dmenu_state == ""warp_options"")
                    check_type = ""real"";
                
                if (dmenu_state == ""globals_changer"")
                {
                    if (dvertical_index == 0)
                    {
                        check_type = ""variable"";
                        dglobal_changer_options[dvertical_index][1] = ""string"";
                        
                        if (scr_string_respect_type(dcustom_flag_text[1], ""real"", 1, 0))
                            dglobal_changer_options[dvertical_index][1] = ""real"";
                    }
                    else
                    {
                        check_type = dglobal_changer_options[dvertical_index][1];
                    }
                }
                
                if (dcustom_flag_text[0] != """")
                {
                    flags_good = evaluate_custom_flag(clean_exit, check_type);
                    
                    if (flags_good && dmenu_state == ""warp_options"")
                        drooms_options.target_plot = real(dkeyboard_input);
                    
                    snd_play(array_get([299, 420], flags_good));
                }
            }
        }
        else
        {
            set_keyboard_reader(0);
            dkeyboard_input = """";
            dcustom_flag_text = ["""", """"];
            snd_play(snd_error);
        }
        
        if (keyboard_check_pressed(vk_down))
            vmove_menu(0, 1);
        else if (keyboard_check_pressed(vk_up))
            vmove_menu(1, 0);
        
        if (dmenu_state != ""warp_options"")
        {
            if (keyboard_check_pressed(global.input_k[4]) || keyboard_check_pressed(global.input_k[7]))
            {
                snd_play(snd_select);
                
                if (dmenu_state == ""globals_changer"" && flags_good)
                    dmenu_state_interact();
            }
            else if (keyboard_check_pressed(vk_escape))
            {
                snd_play(snd_error);
            }
            else
            {
                snd_play(snd_menumove);
            }
        }
        
        if (!clean_exit)
            dkeyboard_input = """";
        
        set_keyboard_reader(0);
        will_exit = 1;
    }
    else if (reading_double_flag && keyboard_check_pressed(vk_left) && dhorizontal_index != 0)
    {
        snd_play(snd_menumove);
        global.dkeyboard_text = dcustom_flag_text[--dhorizontal_index];
    }
    else if (reading_double_flag && keyboard_check_pressed(vk_right) && dhorizontal_index != 1)
    {
        snd_play(snd_menumove);
        global.dkeyboard_text = dcustom_flag_text[++dhorizontal_index];
    }
    else
    {
        update_visu = scr_read_keyboard();
        flag_index = 0;
        
        if (reading_double_flag)
            flag_index = dhorizontal_index;
        
        dcustom_flag_text[flag_index] = global.dkeyboard_text;
    }
    
    if (update_visu)
    {
        if (!will_exit)
            dkeyboard_input = dcustom_flag_text[0];
        
        dmenu_state_update();
    }
}
else if (dmenu_active)
{
    if (dbutton_layout == 0 && dkeys_helper == 0)
    {
        moved = 1;
        
        if (keyboard_check_pressed(vk_up))
        {
            dvertical_index--;
            
            if (dvertical_index == -1)
                dvertical_index = array_length(dbutton_options_2d) - 1;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        }
        else if (keyboard_check_pressed(vk_down))
        {
            dvertical_index++;
            
            if (dvertical_index == array_length(dbutton_options_2d))
                dvertical_index = 0;
            
            dhorizontal_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        }
        else if (keyboard_check_pressed(vk_left))
        {
            dhorizontal_index--;
            
            if (dhorizontal_index == -1)
            {
                dvertical_index--;
                
                if (dvertical_index == -1)
                    dvertical_index = array_length(dbutton_options_2d) - 1;
                
                dhorizontal_index = array_length(dbutton_options_2d[dvertical_index]) - 1;
            }
        }
        else if (keyboard_check_pressed(vk_right))
        {
            dhorizontal_index++;
            
            if (dhorizontal_index == array_length(dbutton_options_2d[dvertical_index]))
            {
                dvertical_index++;
                
                if (dvertical_index == array_length(dbutton_options_2d))
                    dvertical_index = 0;
                
                dhorizontal_index = 0;
            }
        }
        else
        {
            moved = 0;
        }
        
        if (moved)
            snd_play(snd_menumove);
    }
    
    if (dbutton_layout == 1)
    {
        og_horizontal_index = dhorizontal_index;
        pressed_right = dmenu_pressed_key(39);
        pressed_left = dmenu_pressed_key(37);
        
        if (dmenu_state == ""flag_misc"")
        {
            cur_options = dother_options[dvertical_index];
            cur_options_len = array_length(cur_options[3]);
            playsound = 1;
            
            if (keyboard_check_pressed(vk_right) && dhorizontal_index < (cur_options_len - 1))
                dhorizontal_index++;
            else if (keyboard_check_pressed(vk_left) && dhorizontal_index != 0)
                dhorizontal_index--;
            else
                playsound = 0;
            
            if (playsound)
            {
                global.flag[cur_options[2]] = cur_options[3][dhorizontal_index][1];
                scr_debug_print(dstr(""Updated "", ""Mise à jour de "") + ""global.flag["" + string(cur_options[2]) + ""]"" + dstr("" to "", "" à "") + ""|"" + string(cur_options[3][dhorizontal_index][1]) + ""|"");
                snd_play(snd_menumove);
            }
        }
        else if (dmenu_state == ""globals_changer"")
        {
            cur_global_array_limit = dglobal_changer_options[dvertical_index][2];
            
            if (pressed_left == 1 && dhorizontal_index != 0)
                dhorizontal_index--;
            
            if (pressed_right == 1 && dhorizontal_index != (cur_global_array_limit - 1))
                dhorizontal_index++;
            
            if (dhorizontal_index != og_horizontal_index)
                snd_play(snd_menumove);
        }
        
        if (pressed_left && pressed_right)
            pressed_right = 0;
        
        if (pressed_right || pressed_left)
        {
            if (dmenu_state == ""recruits"")
            {
                if (dvertical_index != 0)
                {
                    var real_index = dbutton_indices[dvertical_index];
                    scr_recruit_info(real_index);
                    recruit_count = global.flag[real_index + 600];
                    to_add = 1 / _recruitcount;
                    
                    if (pressed_left)
                    {
                        to_add = -to_add;
                        
                        if (recruit_count == 0)
                            to_add = -1;
                    }
                    else if (pressed_right && recruit_count == -1)
                    {
                        to_add = 1;
                    }
                    
                    if ((pressed_right && (recruit_count * _recruitcount) < _recruitcount) || (pressed_left && (recruit_count * _recruitcount) > -1))
                    {
                        global.flag[600 + real_index] = recruit_count + to_add;
                        dmenu_state_update();
                        snd_play(snd_sparkle_gem);
                    }
                    else
                    {
                        snd_play(snd_error);
                    }
                }
                else if ((pressed_right && dhorizontal_page != global.chapter) || (pressed_left && dhorizontal_page != 0))
                {
                    dhorizontal_page++;
                    
                    if (pressed_left)
                        dhorizontal_page -= 2;
                    
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if (dmenu_state == ""warp_options"" && (dvertical_index == 3 || dvertical_index == 4))
            {
                cur_party = array_get([drooms_options.target_member_2, drooms_options.target_member_3], dvertical_index - 3);
                new_party = -1;
                
                if (pressed_left && cur_party != 0)
                    new_party = cur_party - 1;
                else if (pressed_right && cur_party != (4 - (global.chapter == 1)))
                    new_party = cur_party + 1;
                
                if (new_party == 1)
                    new_party += (pressed_right - pressed_left);
                
                if (new_party != -1)
                {
                    if (dvertical_index == 3)
                        drooms_options.target_member_2 = new_party;
                    else
                        drooms_options.target_member_3 = new_party;
                    
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if (dmenu_state == ""debug_save_options"" && dvertical_index == 0)
            {
                var new_setting = -1;
                
                if (pressed_left && global.dload_cur_inv != 0)
                    new_setting = 0;
                else if (pressed_right && global.dload_cur_inv != 1)
                    new_setting = 1;
                
                if (new_setting != -1)
                {
                    global.dload_cur_inv = new_setting;
                    snd_play(snd_menumove);
                    dmenu_state_update();
                }
            }
            else if ((dmenu_state == ""objects"" || dmenu_state == ""weapons"" || dmenu_state == ""armors"") && (pressed_left + pressed_right) == 1)
            {
                dhorizontal_page = !dhorizontal_page;
                dmenu_start_index = 0;
                dvertical_index = 0;
                snd_play(snd_menumove);
                dmenu_state_update();
            }
        }
        
        pressed_up = dmenu_pressed_key(38);
        pressed_down = dmenu_pressed_key(40);
        
        if (dmenu_state == ""globals_changer"" && (pressed_up || pressed_down))
            dhorizontal_index = 0;
        
        if (pressed_up && pressed_down)
            pressed_up = 0;
        
        vmove_menu(pressed_up, pressed_down);
        dmenu_start_index = clamp(dmenu_start_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
        
        if (dhorizontal_index != og_horizontal_index)
            dmenu_state_update();
    }
    
    if (dbutton_layout == 2)
    {
        if (keyboard_check_pressed(vk_left))
        {
            var owned_count = 0;
            
            switch (dgiver_menu_state)
            {
                case ""objects"":
                    if (dhorizontal_page == 0)
                        scr_itemcheck(dbutton_indices[dgiver_button_selected - 1]);
                    else
                        scr_litemcheck(dbutton_indices[dgiver_button_selected - 1]);
                    
                    owned_count = itemcount;
                    break;
                
                case ""armors"":
                    scr_armorcheck_inventory(dbutton_indices[dgiver_button_selected - 1]);
                    owned_count = itemcount;
                    break;
                
                case ""weapons"":
                    scr_weaponcheck_inventory(dbutton_indices[dgiver_button_selected - 1]);
                    owned_count = itemcount;
                    break;
                
                case ""keyitems"":
                    scr_keyitemcheck(dbutton_indices[dgiver_button_selected - 1]);
                    owned_count = itemcount;
                    break;
                
                default:
                    owned_count = 0;
            }
            
            if (dgiver_amount > -owned_count)
            {
                dgiver_amount -= 1;
                snd_play(snd_menumove);
            }
            else
            {
                snd_play(snd_error);
            }
        }
        
        if (keyboard_check_pressed(vk_right))
        {
            var owned_count = 0;
            
            switch (dgiver_menu_state)
            {
                case ""objects"":
                    if (dhorizontal_page == 0)
                        scr_itemcheck(0);
                    else
                        scr_litemcheck(0);
                    
                    owned_count = itemcount;
                    break;
                
                case ""armors"":
                    scr_armorcheck_inventory(0);
                    owned_count = itemcount;
                    break;
                
                case ""weapons"":
                    scr_weaponcheck_inventory(0);
                    owned_count = itemcount;
                    break;
                
                case ""keyitems"":
                    scr_keyitemcheck(0);
                    owned_count = itemcount;
                    break;
                
                case ""recruits"":
                    real_indice = dbutton_indices[dvertical_index];
                    recruited_nbr = global.flag[real_indice + 600];
                    global.flag[real_indice + 600] = recruited_nbr + 1;
                    break;
                
                default:
                    owned_count = 0;
            }
            
            if (dgiver_amount < owned_count)
            {
                dgiver_amount += 1;
                snd_play(snd_menumove);
            }
            else
            {
                snd_play(snd_error);
            }
        }
    }
    
    if (dbutton_layout == 3)
    {
        if (dvertical_index != 0)
        {
            if (keyboard_check_pressed(vk_left))
            {
                dhorizontal_index--;
                
                if (dhorizontal_index == -1)
                {
                    var TODO = ""change this to a proper array_len later"";
                    dhorizontal_index = 1;
                }
                
                snd_play(snd_menumove);
            }
            
            if (keyboard_check_pressed(vk_right))
            {
                dhorizontal_index++;
                
                if (dhorizontal_index == 2)
                    dhorizontal_index = 0;
                
                snd_play(snd_menumove);
            }
        }
        
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(vk_down))
        {
            dvertical_index ^= 1;
            snd_play(snd_menumove);
        }
    }
    
    if (keyboard_check_pressed(global.input_k[4]) || keyboard_check_pressed(global.input_k[7]))
    {
        if (!(dmenu_state == ""new_debug_save"" && dvertical_index == 0))
            snd_play(snd_select);
        
        array_push(dmenu_state_history, dmenu_state);
        array_push(dmenu_vertical_index_history, dvertical_index);
        array_push(dmenu_horizontal_index_history, dhorizontal_index);
        array_push(dmenu_page_index_history, dhorizontal_page);
        
        if (dmenu_state == ""flag_categories"" && dvertical_index == 0)
        {
            global.dreading_custom_flag = 1;
            dhorizontal_index = 0;
            keyboard_string = """";
        }
        
        if (scr_array_contains(ditem_types, dmenu_state))
        {
            switch (dmenu_state)
            {
                case ""objects"":
                    if (dhorizontal_page != 0 || dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        
                        if (dhorizontal_page == 0)
                        {
                            scr_iteminfo(real_index);
                            dgiver_bname = itemnameb;
                        }
                        else
                        {
                            for (var i = 0; i < array_length(dlight_objects); i++)
                            {
                                if (dlight_objects[i][0] == real_index)
                                {
                                    real_index = i;
                                    break;
                                }
                            }
                            
                            dgiver_bname = dlight_objects[real_index][1];
                        }
                        
                        scr_debug_print(dgiver_bname + dstr("" selected!"", "" sélectionné !""));
                    }
                    
                    break;
                
                case ""armors"":
                    if (dhorizontal_page != 0 || dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        
                        if (dhorizontal_page == 0)
                        {
                            scr_armorinfo(real_index);
                            dgiver_bname = armornametemp;
                        }
                        else
                        {
                            dgiver_bname = dlight_armors[real_index][1];
                        }
                        
                        scr_debug_print(string(dgiver_bname) + dstr("" selected!"", "" sélectionné !""));
                    }
                    
                    break;
                
                case ""weapons"":
                    if (dhorizontal_page != 0 || dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        
                        if (dhorizontal_page == 0)
                        {
                            scr_weaponinfo(real_index);
                            dgiver_bname = weaponnametemp;
                        }
                        else
                        {
                            dgiver_bname = dlight_weapons[real_index][1];
                        }
                        
                        scr_debug_print(string(dgiver_bname) + dstr("" selected!"", "" sélectionné !""));
                    }
                    
                    break;
                
                case ""keyitems"":
                    if (dvertical_index != 0)
                    {
                        var real_index = dbutton_indices[dvertical_index];
                        scr_keyiteminfo(real_index);
                        dgiver_bname = tempkeyitemname;
                        scr_debug_print(string(dgiver_bname) + dstr("" selected!"", "" sélectionné !""));
                    }
                    
                    break;
            }
        }
        else if (dmenu_state == ""warp"" && dvertical_index == 1)
        {
            scr_debug_print(dstr(""Search selected!"", ""Recherche sélectionné !""));
        }
        else if (dmenu_state != ""givertab"" && dmenu_state != ""flag_misc"" && dmenu_state != ""warp_options"" && (dmenu_state != ""recruits"" || dvertical_index == 0) && dmenu_state != ""new_debug_save"")
        {
            option_name = """";
            
            if (dbutton_layout == 0)
                option_name = string(dbutton_options_2d[dvertical_index][dhorizontal_index]);
            else
                option_name = string(dbutton_options[dvertical_index]);
            
            scr_debug_print(option_name + dstr("" selected!"", "" sélectionné !""));
        }
        
        dmenu_skip_reindexing = false;
        dmenu_state_interact();
        
        if (!dmenu_skip_reindexing)
        {
            dmenu_start_index = 0;
            dvertical_index = 0;
            dhorizontal_index = 0;
        }
        
        dmenu_state_update();
    }
    
    if (keyboard_check_pressed(global.input_k[5]) || keyboard_check_pressed(global.input_k[8]))
    {
        snd_play(snd_smallswing);
        
        if (dmenu_state == ""debug_save"")
        {
            if (dmenu_popup_launch == 1)
            {
                if (!instance_exists(obj_savemenu))
                {
                    instance_create(0, 0, obj_savemenu);
                    obj_savemenu.menuno = 1;
                    obj_savemenu.mpos = 3;
                    global.interact = 1;
                }
            }
        }
        
        dpop_history();
    }
    
    if (dhinter_active)
    {
        if (dmenu_state == ""warp_options"")
        {
            new_room = drooms_options.target_room;
            
            if (new_room == -1)
                new_room = room;
            
            dhinter_text = dstr(""Selected room: "", ""Salle sélectionnée : "") + room_get_name(new_room);
        }
        
        if (dmenu_state == ""debug_save"")
        {
            if (dvertical_index == 0)
            {
                dhinter_text = dstr(""[I] - Import individual\n[Alt+I] - Batch import"", ""[I] - Importation unique\n[Alt+I] - Importation par lot"");
            }
            else if (dvertical_index > 0 && dvertical_index < array_length(dbutton_options))
            {
                var real_index = (dvertical_index < array_length(dbutton_indices)) ? dbutton_indices[dvertical_index] : -1;
                
                if (real_index >= 0 && real_index < array_length(debug_save_descriptions))
                    dhinter_text = debug_save_descriptions[real_index];
                else
                    dhinter_text = """";
            }
        }
        
        if (dmenu_state == ""debug_save_options"")
        {
            var target_path = global.debug_selected_save_section;
            var found_desc = ""No description available."";
            
            for (var i = 0; i < array_length(debug_save_sections); i++)
            {
                if (debug_save_sections[i] == target_path)
                {
                    found_desc = debug_save_descriptions[i];
                    break;
                }
            }
            
            dhinter_text = found_desc;
        }
        
        if (scr_array_contains(ditem_types, dmenu_state))
        {
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dhinter_text = dstr(""Press "", ""Appuyez sur "") + scr_get_input_name(4) + dstr("" to change chapter"", "" pour changer de chapitre"");
            }
            else if (dhorizontal_page == 0 && dvertical_index != 0)
            {
                var hover_id = dbutton_indices[dvertical_index];
                
                if (hover_id != -1)
                {
                    var raw_desc = """";
                    
                    switch (dmenu_state)
                    {
                        case ""objects"":
                            scr_iteminfo(hover_id);
                            raw_desc = itemdescb;
                            break;
                        
                        case ""armors"":
                            scr_armorinfo(hover_id);
                            raw_desc = armordesctemp;
                            break;
                        
                        case ""weapons"":
                            scr_weaponinfo(hover_id);
                            raw_desc = weapondesctemp;
                            break;
                        
                        case ""keyitems"":
                            scr_keyiteminfo(hover_id);
                            raw_desc = tempkeyitemdesc;
                            break;
                    }
                    
                    dhinter_text = string_replace_all(raw_desc, ""#"", "" "");
                    var max_w = (menu_width - (x_padding * 2)) * d;
                    var line_sep = 18 * d;
                    var max_h = line_sep * 2;
                    
                    if (!variable_instance_exists(id, ""dhinter_cached_raw"") || dhinter_cached_raw != dhinter_text)
                    {
                        dhinter_cached_raw = dhinter_text;
                        var temp_text = dhinter_text;
                        
                        if (string_height_ext(temp_text, line_sep, max_w) > max_h)
                        {
                            while (string_height_ext(temp_text + ""..."", line_sep, max_w) > max_h && string_length(temp_text) > 0)
                                temp_text = string_delete(temp_text, string_length(temp_text), 1);
                            
                            temp_text += ""..."";
                        }
                        
                        dhinter_cached_display = temp_text;
                    }
                    
                    dhinter_text = dhinter_cached_display;
                }
                else
                {
                    dhinter_text = ""---"";
                }
            }
            else
            {
                dhinter_text = """";
            }
        }
    }
}

if ((dmenu_active == 1 && dmenu_state == ""debug"") || dkeys_helper == 1)
{
    if (keyboard_check_pressed(ord(""M"")))
    {
        if (dkeys_helper == 0)
            snd_play(snd_select);
        else
            snd_play(snd_smallswing);
        
        dkeys_helper = !dkeys_helper;
    }
}

if (dmenu_active == 1 && dmenu_state == ""debug"")
{
    if (keyboard_check_pressed(ord(""F"")))
    {
        global.dlang = (global.dlang == ""en"") ? ""fr"" : ""en"";
        
        with (obj_dmenu_system)
        {
            event_perform(ev_create, 0); 
        }

        scr_debug_print(dstr(""Debug menu now in English!"", ""Menu debug désormais en français !""));
        global.interact = 0;
    }
}");


importGroup.QueueReplace(obj_dmenu_system.EventHandlerFor(EventType.Step, (uint)1, Data),
@"function dmenu_state_update()
{
    switch (dmenu_state)
    {
        case ""debug"":
            dmenu_title = dstr(""Debug Menu"", ""Menu Debug"");
            dbutton_options_2d = dbutton_options_original;
            dmenu_box = 0;
            dbutton_layout = 0;
            break;
        case ""obj_handler"":
            dmenu_title = dstr(""Game Object List"", ""Liste de Game Objects"");
            dbutton_options = [dstr(""Create object instance"", ""Créer instance d'objet""), dstr(""Search"", ""Recherche"")];
            dbutton_indices = [-1, -1];
            if (global.dreading_custom_flag || dkeyboard_input != """")
            {
                dbutton_options[1] = dstr(""Contains: "", ""Contient : "");
            }
            else
            {
                dbutton_options[1] = dstr(""Search"", ""Recherche"");
            }
            dbutton_options[1] += dkeyboard_input;
            for (var i = 0; i < array_length(obj_list); i++)
            {
                if (!string_pos(dkeyboard_input, obj_list[i]))
                {
                    continue;
                }
                var combined = obj_list[i];
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, combined);
            }
            dbutton_layout = 1;
            dmenu_box = 1;
            break;
        case ""obj_create"":
            dmenu_title = dstr(""Create Game Object"", ""Créer un Game Object"");
            dbutton_options = [dstr(""Search"", ""Recherche"")];
            dbutton_indices = [-1];
            if (global.dreading_custom_flag || dkeyboard_input != """")
            {
                dbutton_options[0] = dstr(""Name: "", ""Nom : "");
            }
            else
            {
                dbutton_options[0] = dstr(""Search"", ""Recherche"");
            }
            dbutton_options[0] += dkeyboard_input;
            for (var i = 0; i < array_length(all_obj_list); i++)
            {
                if (!string_pos(dkeyboard_input, all_obj_list[i]))
                {
                    continue;
                }
                var combined = all_obj_list[i];
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, combined);
            }
            dbutton_layout = 1;
            dmenu_box = 1;
            break;
        case ""debug_save"":
            dmenu_title = ""Debug save"";
            dbutton_options = [dstr(""New save"", ""Nouvelle sauvegarde""), dstr(""Search"", ""Recherche"")];
            dbutton_indices = [-2, -2];
            var subs = [];
            if (global.dreading_custom_flag || dkeyboard_input != """")
            {
                dbutton_options[1] = dstr(""Contains: "", ""Contient : "") + dkeyboard_input;
            }
            else
            {
                dbutton_options[1] = dstr(""Search"", ""Recherche"") + dkeyboard_input;
            }
            for (var i = 0; i < array_length(debug_save_names); i++)
            {
                var s_chap = debug_save_chapters[i];
                if (s_chap != -1 && s_chap != global.chapter)
                {
                    continue;
                }
                var s_name = debug_save_names[i];
                var s_cat = debug_save_categories[i];
                if (s_cat != """")
                {
                    var cat_index = -1;
                    for (var j = 0; j < array_length(dbutton_options); j++)
                    {
                        if (dbutton_options[j] == s_cat)
                        {
                            cat_index = j;
                            break;
                        }
                    }
                    if (cat_index == -1)
                    {
                        cat_index = array_length(dbutton_options);
                        array_push(dbutton_options, s_cat);
                        array_push(dbutton_indices, -1);
                        subs[cat_index] = [];
                        subs[cat_index + 1000] = [];
                    }
                    array_push(subs[cat_index], s_name);
                    array_push(subs[cat_index + 1000], i);
                }
                else
                {
                    array_push(dbutton_options, s_name);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_process_submenus(subs, dkeyboard_input);
            dmenu_box = 1;
            dbutton_layout = 1;
            break;
        case ""debug_save_options"":
            dmenu_title = dstr(""Options: "", ""Options : "") + string(global.debug_selected_save_name);
            dbutton_options = [dstr(""Load"", ""Charger""), dstr(""Save"", ""Sauver""), dstr(""Export"", ""Exporter""), dstr(""Save management"", ""Gestion sauvegardes""), dstr(""Delete"", ""Supprimer"")];
            dbutton_indices = [-2, -2, -1, -1, -2];
            var subs = array_create(array_length(dbutton_options), 0);
            subs[2] = [dstr(""Debug mode save"", ""Sauvegarde mode debug""), dstr(""Default Deltarune save"", ""Sauvegarde Deltarune par défaut"")];
            subs[3] = [dstr(""Rename"", ""Renommer""), dstr(""Edit description"", ""Modifier description""), dstr(""Change category"", ""Changer catégorie"")];
            dmenu_process_submenus(subs, """");
            if (!variable_global_exists(""dload_cur_inv""))
            {
                global.dload_cur_inv = 0;
            }
            var load_options = ["" (Normal)"", dstr(""  (Current inventory)"", ""  (Inventaire actuel)"")];
            dbutton_options[0] += load_options[global.dload_cur_inv];
            dmenu_box = 1;
            dbutton_layout = 1;
            break;
        case ""dsave_edit_name"":
        case ""dsave_edit_desc"":
        case ""dsave_edit_cat"":
            if (dmenu_state == ""dsave_edit_name"")
            {
                dmenu_title = dstr(""Rename save"", ""Renommer sauvegarde"");
            }
            else if (dmenu_state == ""dsave_edit_desc"")
            {
                dmenu_title = dstr(""Edit description"", ""Modifier description"");
            }
            else if (dmenu_state == ""dsave_edit_cat"")
            {
                dmenu_title = dstr(""Change category"", ""Changer catégorie"");
            }
            dbutton_options_2d = [[""""], [dstr(""Save"", ""Sauver""), dstr(""Cancel"", ""Annuler"")]];
            dbutton_options = ["""", """"];
            var target_path = global.debug_selected_save_section;
            var default_text = """";
            if (dmenu_state == ""dsave_edit_name"")
            {
                default_text = dstr(""Enter save name"", ""Entrer nom de sauvegarde"");
            }
            else if (dmenu_state == ""dsave_edit_desc"")
            {
                default_text = dstr(""Enter description"", ""Entrer description"");
            }
            else if (dmenu_state == ""dsave_edit_cat"")
            {
                default_text = dstr(""Enter category"", ""Entrer catégorie"");
            }
            for (var i = 0; i < array_length(debug_save_sections); i++)
            {
                if (debug_save_sections[i] == target_path)
                {
                    if (dmenu_state == ""dsave_edit_name"")
                    {
                        default_text = debug_save_names[i];
                    }
                    else if (dmenu_state == ""dsave_edit_desc"")
                    {
                        default_text = debug_save_descriptions[i];
                    }
                    else if (dmenu_state == ""dsave_edit_cat"")
                    {
                        default_text = debug_save_categories[i];
                    }
                    break;
                }
            }
            var cur_btn = default_text;
            if (global.dreading_custom_flag || dkeyboard_input != """")
            {
                cur_btn = dkeyboard_input;
            }
            dbutton_options_2d[0][0] = cur_btn;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var text_x = x_start + x_padding + xx;
            var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
            var max_width = box_right_edge - text_x;
            var cursor_x = text_x;
            var is_multiline = false;
            var current_word = """";
            var str_len = string_length(cur_btn);
            for (var i = 1; i <= str_len; i++)
            {
                var _char = string_char_at(cur_btn, i);
                if (_char != "" "" && _char != ""\n"")
                {
                    current_word += _char;
                }
                if (_char == "" "" || _char == ""\n"" || i == str_len)
                {
                    var _word_width = string_length(current_word) * mono_spacing;
                    if (max_width > 0 && ((cursor_x + _word_width) - text_x) > max_width)
                    {
                        if (cursor_x != text_x)
                        {
                            is_multiline = true;
                        }
                    }
                    for (var w = 1; w <= string_length(current_word); w++)
                    {
                        if (max_width > 0 && ((cursor_x + mono_spacing) - text_x) > max_width)
                        {
                            is_multiline = true;
                        }
                        cursor_x += mono_spacing;
                    }
                    current_word = """";
                    if (_char == "" "")
                    {
                        cursor_x += mono_spacing;
                    }
                    else if (_char == ""\n"")
                    {
                        is_multiline = true;
                    }
                }
            }
            dmenu_box = is_multiline ? 1 : 0;
            dbutton_layout = 3;
            break;
        case ""new_debug_save"":
            dmenu_title = ""New debug save"";
            dbutton_options_2d = [[dstr(""Enter save name"", ""Entrer nom de sauvegarde"")], [dstr(""Save"", ""Sauver""), dstr(""Cancel"", ""Annuler"")]];
            var cur_btn = dstr(""Enter save name"", ""Entrer nom de sauvegarde"");
            if (global.dreading_custom_flag || dkeyboard_input != """")
            {
                cur_btn = dkeyboard_input;
                dbutton_options_2d[0][0] = cur_btn;
            }
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var text_x = x_start + x_padding + xx;
            var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
            var max_width = box_right_edge - text_x;
            var cursor_x = text_x;
            var is_multiline = false;
            var current_word = """";
            var str_len = string_length(cur_btn);
            for (var i = 1; i <= str_len; i++)
            {
                var _char = string_char_at(cur_btn, i);
                if (_char != "" "" && _char != ""\n"")
                {
                    current_word += _char;
                }
                if (_char == "" "" || _char == ""\n"" || i == str_len)
                {
                    var _word_width = string_length(current_word) * mono_spacing;
                    if (max_width > 0 && ((cursor_x + _word_width) - text_x) > max_width)
                    {
                        if (cursor_x != text_x)
                        {
                            is_multiline = true;
                        }
                    }
                    for (var w = 1; w <= string_length(current_word); w++)
                    {
                        if (max_width > 0 && ((cursor_x + mono_spacing) - text_x) > max_width)
                        {
                            is_multiline = true;
                        }
                        cursor_x += mono_spacing;
                    }
                    current_word = """";
                    if (_char == "" "")
                    {
                        cursor_x += mono_spacing;
                    }
                    else if (_char == ""\n"")
                    {
                        is_multiline = true;
                    }
                }
            }
            dmenu_box = is_multiline ? 1 : 0;
            dbutton_layout = 3;
            break;
        case ""warp"":
            dmenu_title = dstr(""Room List"", ""Liste des salles"");
            dbutton_options = [dstr(""Current Room"", ""Salle actuelle""), dstr(""Search"", ""Recherche"")];
            dbutton_indices = [-1, -1];
            if (global.dreading_custom_flag || dkeyboard_input != """")
            {
                dbutton_options[1] = dstr(""Contains: "", ""Contient : "");
            }
            else
            {
                dbutton_options[1] = dstr(""Search"", ""Recherche"");
            }
            dbutton_options[1] += dkeyboard_input;
            for (var i = 0; i < array_length(drooms); i++)
            {
                if (!string_pos(dkeyboard_input, drooms[i]))
                {
                    continue;
                }
                var combined = drooms[i];
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, drooms_id[i].room_index);
            }
            dbutton_layout = 1;
            dmenu_box = 1;
            break;
        case ""warp_options"":
            dmenu_title = dstr(""Warp Options"", ""Options du saut"");
            dbutton_options = [dstr(""Cancel"", ""Annuler""), dstr(""Is Darkworld: "", ""Est un Darkworld : ""), dstr(""Plot Value: "", ""Valeur de plot : ""), dstr(""Teammate 2:  "", ""Équipier 2 :  ""), dstr(""Teammate 3:  "", ""Équipier 3 :  ""), dstr(""Warp"", ""Sauter"")];
            dbutton_indices = [0, 1, 2, 3, 4, 5];
            dbutton_options[1] += drooms_options.target_is_darkzone ? dstr(""Yes"", ""Oui"") : dstr(""No"", ""Non"");
            if (global.dreading_custom_flag)
            {
                dbutton_options[2] += dkeyboard_input;
            }
            else
            {
                dbutton_options[2] += string(drooms_options.target_plot);
            }
            teammates = [dstr(""Nobody"", ""Personne""), ""Kris"", ""Susie"", ""Ralsei"", ""Noëlle""];
            dbutton_options[3] += teammates[drooms_options.target_member_2];
            dbutton_options[4] += teammates[drooms_options.target_member_3];
            break;
        case ""give"":
            dmenu_title = dstr(""Item Type"", ""Type d'items"");
            dbutton_options_2d = [[dstr(""Items"", ""Objets""), dstr(""Armors"", ""Armures""), dstr(""Weapons"", ""Armes""), dstr(""Key Items"", ""Obj Clés"")]];
            dmenu_box = 0;
            dbutton_layout = 0;
            break;
        case ""objects"":
            dmenu_title = dstr(""Item List"", ""Liste d'objets"");
            dbutton_options = [dstr(""Chapter: "", ""Chapitre : "")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = ditem_index_data(ditem_chap);
            if (dhorizontal_page == 0)
            {
                for (var r = 0; r < array_length(_ranges); r++)
                {
                    var my_start = _ranges[r].start_id;
                    var my_count = _ranges[r].count;
                    for (var i = my_start; i < (my_start + my_count); i++)
                    {
                        scr_iteminfo(i);
                        var cleaned_desc = string_replace_all(itemdescb, ""#"", "" "");
                        var combined = itemnameb;
                        if (string_length(combined) > max_len)
                        {
                            combined = string_copy(combined, 1, max_len - 3) + ""..."";
                        }
                        array_push(dbutton_options, combined);
                        array_push(dbutton_indices, i);
                    }
                }
            }
            else
            {
                array_delete(dbutton_options, 0, 1);
                array_delete(dbutton_indices, 0, 1);
                for (var i = 0; i < array_length(dlight_objects); i++)
                {
                    scr_litemcheck(dlight_objects[i][0]);
                    var combined = dlight_objects[i][1] + "" - "" + string(itemcount) + "" "" + dstr(""held"", ""possédé(s)"");
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, dlight_objects[i][0]);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case ""armors"":
            dmenu_title = dstr(""Armor List"", ""Liste d'armures"");
            dbutton_options = [dstr(""Chapter: "", ""Chapitre : "")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = darmor_index_data(ditem_chap);
            if (dhorizontal_page == 0)
            {
                for (var r = 0; r < array_length(_ranges); r++)
                {
                    var my_start = _ranges[r].start_id;
                    var my_count = _ranges[r].count;
                    for (var i = my_start; i < (my_start + my_count); i++)
                    {
                        scr_armorinfo(i);
                        var cleaned_desc = string_replace_all(armordesctemp, ""#"", "" "");
                        var combined = armornametemp;
                        if (string_length(combined) > max_len)
                        {
                            combined = string_copy(combined, 1, max_len - 3) + ""..."";
                        }
                        array_push(dbutton_options, combined);
                        array_push(dbutton_indices, i);
                    }
                }
            }
            else
            {
                array_delete(dbutton_options, 0, 1);
                array_delete(dbutton_indices, 0, 1);
                for (var i = 0; i < array_length(dlight_armors); i++)
                {
                    var combined = dlight_armors[i][1];
                    if (global.larmor == dlight_armors[i][0])
                    {
                        combined += ("" ("" + dstr(""Equipped"", ""Équipé"") + "")"");
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case ""weapons"":
            dmenu_title = dstr(""Weapon List"", ""Liste d'armes"");
            dbutton_options = [dstr(""Chapter: "", ""Chapitre : "")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = dweapon_index_data(ditem_chap);
            if (dhorizontal_page == 0)
            {
                for (var r = 0; r < array_length(_ranges); r++)
                {
                    var my_start = _ranges[r].start_id;
                    var my_count = _ranges[r].count;
                    for (var i = my_start; i < (my_start + my_count); i++)
                    {
                        scr_weaponinfo(i);
                        var cleaned_desc = string_replace_all(weapondesctemp, ""#"", "" "");
                        var combined = weaponnametemp;
                        if (string_length(combined) > max_len)
                        {
                            combined = string_copy(combined, 1, max_len - 3) + ""..."";
                        }
                        array_push(dbutton_options, combined);
                        array_push(dbutton_indices, i);
                    }
                }
            }
            else
            {
                array_delete(dbutton_options, 0, 1);
                array_delete(dbutton_indices, 0, 1);
                for (var i = 0; i < array_length(dlight_weapons); i++)
                {
                    var combined = dlight_weapons[i][1];
                    if (global.lweapon == dlight_weapons[i][0])
                    {
                        combined += ("" ("" + dstr(""Equipped"", ""Équipé"") + "")"");
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case ""keyitems"":
            dmenu_title = dstr(""Key Item List"", ""Liste d'objets clés"");
            dbutton_options = [dstr(""Chapter: "", ""Chapitre : "")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = dkeyitem_index_data(ditem_chap);
            for (var r = 0; r < array_length(_ranges); r++)
            {
                var my_start = _ranges[r].start_id;
                var my_count = _ranges[r].count;
                for (var i = my_start; i < (my_start + my_count); i++)
                {
                    scr_keyiteminfo(i);
                    var cleaned_desc = string_replace_all(tempkeyitemdesc, ""#"", "" "");
                    var combined = tempkeyitemname;
                    if (string_length(combined) > max_len)
                    {
                        combined = string_copy(combined, 1, max_len - 3) + ""..."";
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case ""givertab"":
            dmenu_title = dstr(""Add how many to inventory?"", ""Ajouter combien à l'inventaire ?"");
            dgiver_amount = 1;
            dmenu_box = 0;
            dbutton_layout = 2;
            break;
        case ""recruits"":
            dmenu_title = dstr(""Recruit List"", ""Liste des recrues"");
            dbutton_options = [dstr(""Presets"", ""Préréglages"")];
            dbutton_indices = [dstr(""Presets"", ""Préréglages"")];
            var max_len = 40;
            if (dhorizontal_page != 0)
            {
                dbutton_options[0] = "" "" + dbutton_options[0];
                dbutton_indices[0] = "" "" + dbutton_indices[0];
            }
            if (dhorizontal_page != 0)
            {
                var test_lst = scr_get_chapter_recruit_data(dhorizontal_page);
                for (var i = 0; i < array_length(test_lst); i++)
                {
                    var enemy_id = test_lst[i];
                    scr_recruit_info(enemy_id);
                    var combined = _name + "" - ["" + string(max(floor(global.flag[enemy_id + 600] * _recruitcount), -1)) + ""/"" + string(_recruitcount) + ""]"";
                    if (string_length(combined) > max_len)
                    {
                        combined = string_copy(combined, 1, max_len - 3) + ""..."";
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, enemy_id);
                }
            }
            if (dhorizontal_page != 0)
            {
                dmenu_box = 1;
            }
            else
            {
                dmenu_box = 0;
            }
            dbutton_layout = 1;
            break;
        case ""recruit_presets"":
            dmenu_title = dstr(""Recruit Presets"", ""Préréglages des recrues"");
            dbutton_options = [dstr(""Recruit All"", ""Recruter tous""), dstr(""Lose All"", ""Perdre tous"")];
            if (dhorizontal_page)
            {
                dmenu_title += ("" ("" + dstr(""chap"") + "" "" + string(dhorizontal_page) + "")"");
                dbutton_options[0] += "" "" + dstr(""of chapter"", ""du chapitre"") + "" "" + string(dhorizontal_page);
                dbutton_options[1] += "" "" + dstr(""of chapter"", ""du chapitre"") + "" "" + string(dhorizontal_page);
            }
            dmenu_box = 0;
            dbutton_layout = 1;
            break;
        case ""flag_categories"":
            dmenu_title = dstr(""Flags"");
            dbutton_options = [];
            dbutton_indices = [-1];
            categories_len = array_length(dother_categories);
            var max_len = 40;
            if (!global.dreading_custom_flag)
            {
                array_push(dbutton_options, dstr(""Custom""));
            }
            else
            {
                array_push(dbutton_options, ""global.flag["" + dcustom_flag_text[0] + ""] = |"" + dcustom_flag_text[1] + ""|"");
            }
            for (var i = 0; i < categories_len; i++)
            {
                if (dflag_categories_len[i] == 0)
                {
                    continue;
                }
                array_push(dbutton_options, dother_categories[i]);
                array_push(dbutton_indices, i);
            }
            dmenu_box = 1;
            dbutton_layout = 1;
            break;
        case ""flag_misc"":
            dmenu_title = dstr(""Flags"");
            dbutton_options = [];
            dbutton_indices = [];
            other_len = array_length(dother_options);
            var max_len = 40;
            for (var i = 0; i < other_len; i++)
            {
                cur_option = dother_options[i];
                flag_number = global.flag[cur_option[2]];
                var combined = cur_option[1] + "" - "" + dstr(""problem lol"", ""problème lol"");
                if (i == dvertical_index)
                {
                    option_index = dhorizontal_index;
                }
                else
                {
                    option_index = find_subarray_index(cur_option[2], cur_option[3]);
                }
                combined = cur_option[1] + "" -  "" + cur_option[3][option_index][0];
                if (string_length(combined) > max_len)
                {
                    combined = string_copy(combined, 1, max_len - 3) + ""..."";
                }
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, i);
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case ""globals_changer"":
            dmenu_title = dstr(""Global changer"", ""Changeur de global"");
            dbutton_options = [];
            dmenu_box = 1;
            dbutton_layout = 1;
            reading_double_flag = dvertical_index == 0 && global.dreading_custom_flag;
            for (var i = 0; i < array_length(dglobal_changer_options); i++)
            {
                array_push(dbutton_indices, i);
                name = dglobal_changer_options[i][0];
                limit = dglobal_changer_options[i][2];
                if (i == 0 && reading_double_flag)
                {
                    name = dcustom_flag_text[0];
                    is_good = parse_var_str(name, 0);
                    if (is_good)
                    {
                        name = dtemp_text;
                        limit = dtemp_num;
                    }
                }
                text = name;
                if (i == 0 && reading_double_flag)
                {
                    text = ""global."" + name;
                }
                cur_global_value = """";
                var_exist = variable_global_exists(name);
                if (var_exist)
                {
                    cur_global_value = variable_global_get(name);
                }
                if (limit != -1)
                {
                    lookup_index = 0;
                    if (i == dvertical_index && i == 0)
                    {
                        lookup_index = limit;
                    }
                    else if (i == dvertical_index)
                    {
                        lookup_index = dhorizontal_index;
                    }
                    text += (""["" + string(lookup_index) + ""]"");
                    if (typeof(cur_global_value) != ""array"")
                    {
                        cur_global_value = dstr(""(Not an array)"", ""(Pas une array)"");
                    }
                    else if (lookup_index >= array_length(cur_global_value))
                    {
                        cur_global_value = dstr(""(Index too high)"", ""(Index trop élevé)"");
                    }
                    else
                    {
                        cur_global_value = cur_global_value[lookup_index];
                    }
                }
                if (global.dreading_custom_flag && i == dvertical_index)
                {
                    if (i != 0 || dcustom_flag_text[1] != """" || !var_exist)
                    {
                        cur_global_value = dcustom_flag_text[reading_double_flag];
                    }
                }
                if (!(i == 0 && dvertical_index == 0 && !global.dreading_custom_flag))
                {
                    text += ("" = |"" + string(cur_global_value) + ""|"");
                }
                array_push(dbutton_options, text);
            }
            break;
        default:
            dmenu_box = 0;
            dbutton_layout = 0;
            dbutton_options = [];
    }
}

function dmenu_state_interact()
{
    selected_name = """";
    if (dbutton_layout == 0 || dbutton_layout == 3)
    {
        var safe_h_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        selected_name = string(dbutton_options_2d[dvertical_index][safe_h_index]);
    }
    else
    {
        selected_name = string(dbutton_options[dvertical_index]);
    }
    switch (dmenu_state)
    {
        case ""debug"":
            dvertical_index = 0;
            if (selected_name == dstr(""Warps"", ""Sauts""))
            {
                drooms_id = scr_get_room_list();
                drooms = [];
                for (var i = 0; i < array_length(drooms_id); i++)
                {
                    array_push(drooms, room_get_name(drooms_id[i].room_index));
                }
                dmenu_state = ""warp"";
                dhorizontal_index = 0;
                dkeyboard_input = """";
                drooms_options.target_plot = global.plot;
                drooms_options.target_is_darkzone = global.darkzone;
            }
            else if (selected_name == dstr(""Items""))
            {
                dmenu_state = ""give"";
            }
            else if (selected_name == dstr(""Recruits"", ""Recrues""))
            {
                dmenu_state = ""recruits"";
                dhorizontal_page = 0;
            }
            else if (selected_name == dstr(""Flags""))
            {
                dmenu_state = ""flag_categories"";
            }
            else if (selected_name == ""Globals"")
            {
                dmenu_state = ""globals_changer"";
            }
            else if (selected_name == ""Debug save"")
            {
                scr_get_debug_save_list();
                dmenu_state = ""debug_save"";
            }
            else if (selected_name == ""Game Obj"")
            {
                var obj_list = [];
                with (all)
                {
                    var _name = object_get_name(object_index);
                    if (!scr_array_contains(other.obj_list, _name))
                    {
                        array_push(other.obj_list, _name);
                    }
                }
                dmenu_state = ""obj_handler"";
            }
            break;
        case ""obj_handler"":
            if (dvertical_index == 0)
            {
                dmenu_state = ""obj_create"";
                global.dreading_custom_flag = 1;
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state_update();
            }
            else if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state_update();
            }
            break;
        case ""obj_create"":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            if (dvertical_index == 0)
            {
                global.dreading_custom_flag = 1;
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state_update();
            }
            else
            {
                global.flag[7] = 1;
                instance_create(0, 0, obj_dmode_xy);
                var obj_id = asset_get_index(string(dbutton_indices[dvertical_index]));
                var obj_new = instance_create(obj_mainchara.x, obj_mainchara.y, obj_id);

                with (obj_dmode_xy)
                    sel_obj = obj_new;

                dpop_history();
                dmenu_active = false;
            }
            break;
        case ""debug_save"":
            if (dvertical_index == 0)
            {
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state = ""new_debug_save"";
                break;
            }
            if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state_update();
                break;
            }
            if (dmenu_interact_submenus(selected_name))
            {
                break;
            }
            var real_index = dbutton_indices[dvertical_index];
            if (real_index >= 0)
            {
                global.debug_selected_save_section = debug_save_sections[real_index];
                global.debug_selected_save_name = debug_save_names[real_index];
                dmenu_state = ""debug_save_options"";
                dmenu_state_update();
            }
            break;
        case ""debug_save_options"":
            var check_name = selected_name;
            if (string_ends_with(check_name, "" v"") || string_ends_with(check_name, "" ^""))
            {
                check_name = string_copy(check_name, 1, string_length(check_name) - 2);
            }
            if (dmenu_interact_submenus(selected_name))
            {
                break;
            }
            var target_sec = global.debug_selected_save_section;
            var target_name = global.debug_selected_save_name;
            if (check_name == dstr(""Save"", ""Sauver""))
            {
                var target_path = global.debug_selected_save_section;
                global.debug_save_category = """";
                global.debug_save_name = target_name;
                global.debug_save_description = dstr(""No description available."", ""Aucune description disponible."");
                if (file_exists(target_path))
                {
                    var file_id = file_text_open_read(target_path);
                    var file_content = """";
                    while (!file_text_eof(file_id))
                    {
                        file_content += file_text_read_string(file_id);
                        file_text_readln(file_id);
                    }
                    file_text_close(file_id);
                    try
                    {
                        var parsed_struct = json_parse(file_content);
                        if (is_struct(parsed_struct) && variable_struct_exists(parsed_struct, ""metadata""))
                        {
                            var meta = parsed_struct.metadata;
                            if (variable_struct_exists(meta, ""Category""))
                            {
                                global.debug_save_category = meta.Category;
                            }
                            if (variable_struct_exists(meta, ""Description""))
                            {
                                global.debug_save_description = meta.Description;
                            }
                        }
                    }
                    catch (e)
                    {
                    }
                }
                global.debug_overwrite_section = target_path;
                global.debug_saving = 1;
                dmenu_popup_launch = 0;
                dmenu_state = ""debug"";
                dbutton_options = dbutton_options_original;
                dmenu_state_history = [];
                dmenu_vertical_index_history = [];
                dvertical_index = 0;
                dbutton_layout = 0;
                dmenu_active = false;
                dkeyboard_input = """";
                global.interact = 0;
                scr_debug_save();
                scr_debug_print(dstr(""Overwrote save: "", ""Sauvegarde écrasée : "") + target_name);
                snd_play(snd_save);
            }
            else if (string_copy(check_name, 1, (global.dlang == ""en"") ? 4 : 7) == dstr(""Load"", ""Charger""))
            {
                var target_path = global.debug_selected_save_section;
                if (file_exists(target_path))
                {
                    dmenu_popup_launch = 0;
                    dmenu_state = ""debug"";
                    dbutton_options = dbutton_options_original;
                    dmenu_state_history = [];
                    dmenu_vertical_index_history = [];
                    dvertical_index = 0;
                    dbutton_layout = 0;
                    dmenu_active = false;
                    dkeyboard_input = """";
                    global.interact = 0;
                    scr_debug_load(target_path);
                }
                else
                {
                    snd_play(snd_error);
                    scr_debug_print(dstr(""Error: Save file '"", ""Erreur : Le fichier de sauvegarde '"") + target_name + dstr(""' could not be found on disk"", ""' n'a pu être trouvé""));
                }
            }
            else if (check_name == dstr(""Delete"", ""Supprimer""))
            {
                dremove_false_history();
                var target_path = global.debug_selected_save_section;
                if (file_exists(target_path))
                {
                    file_delete(target_path);
                    scr_debug_cleanup_folder(target_path);
                    scr_debug_print(dstr(""Save file permanently deleted"", ""Fichier de sauvegarde supprimé""));
                    snd_play(snd_badexplosion);
                    scr_get_debug_save_list();
                }
                else
                {
                    scr_debug_print(dstr(""Error: File already missing"", ""Erreur : Fichier déjà manquant""));
                }
                dpop_history();
                dvertical_index = 0;
                dbutton_layout = 0;
                dmenu_start_index = 0;
            }
            else if (check_name == (""- "" + dstr(""Debug mode save"", ""Sauvegarde mode debug"")))
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                var source_file = global.debug_selected_save_section;
                target_name = global.debug_selected_save_name;
                var export_path = get_save_filename(""Debug save (*.save)|*.save"", string(target_name) + "".save"");
                if (export_path != """")
                {
                    if (file_exists(source_file))
                    {
                        if (file_exists(export_path))
                        {
                            file_delete(export_path);
                        }
                        file_copy(source_file, export_path);
                        scr_debug_print(dstr(""Exported custom .save successfully!"", ""Fichier .save exporté avec succès !""));
                        snd_play(snd_shineselect);
                    }
                    else
                    {
                        scr_debug_print(dstr(""Error: Base save file not found"", ""Erreur : Fichier de sauvegarde de base introuvable""));
                        snd_play(snd_error);
                    }
                }
            }
            else if (check_name == (""- "" + dstr(""Default Deltarune save"", ""Sauvegarde Deltarune par défaut"")))
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                var source_file = global.debug_selected_save_section;
                target_name = global.debug_selected_save_name;
                if (file_exists(source_file) || ossafe_file_exists(source_file))
                {
                    var _route_suffix = """";
                    if (variable_global_exists(""filechoice_route""))
                    {
                        _route_suffix = string(global.filechoice_route);
                    }
                    var suggested_name = ""filech"" + string(global.chapter) + ""_0"" + _route_suffix;
                    var export_path = get_save_filename(""Deltarune Save|*"", suggested_name);
                    if (export_path != """")
                    {
                        if (file_exists(export_path))
                        {
                            file_delete(export_path);
                        }
                        if (string_copy(source_file, string_length(source_file) - 4, 5) == "".save"")
                        {
                            var file_id = file_text_open_read(source_file);
                            var json_string = """";
                            while (!file_text_eof(file_id))
                            {
                                json_string += file_text_read_string(file_id);
                                file_text_readln(file_id);
                                if (!file_text_eof(file_id))
                                {
                                    json_string += ""\n"";
                                }
                            }
                            file_text_close(file_id);
                            var parsed_data = -1;
                            try
                            {
                                parsed_data = json_parse(json_string);
                            }
                            catch (e)
                            {
                            }
                            if (is_struct(parsed_data) && variable_struct_exists(parsed_data, ""save_file""))
                            {
                                var raw_content = parsed_data.save_file;
                                var out_file = file_text_open_write(export_path);
                                file_text_write_string(out_file, raw_content);
                                file_text_close(out_file);
                            }
                            else
                            {
                                file_copy(source_file, export_path);
                            }
                        }
                        else
                        {
                            file_copy(source_file, export_path);
                        }
                        scr_debug_print(""'"" + string(target_name) + ""' exporté avec succès !"");
                        snd_play(snd_shineselect);
                    }
                    else
                    {
                        scr_debug_print(dstr(""Export cancelled"", ""Exportation annulée""));
                    }
                }
                else
                {
                    scr_debug_print(dstr(""Error: Could not find the source save file"", ""Erreur : Impossible de trouver le fichier de sauvegarde source""));
                    snd_play(snd_error);
                }
            }
            else if (check_name == (""- "" + dstr(""Rename"", ""Renommer"")) || check_name == (""- "" + dstr(""Edit description"", ""Modifier description"")) || check_name == (""- "" + dstr(""Change category"", ""Changer description"")))
            {
                if (check_name == (""- "" + dstr(""Rename"", ""Renommer"")))
                {
                    dmenu_state = ""dsave_edit_name"";
                    keyboard_string = """";
                    dkeyboard_input = """";
                }
                if (check_name == (""- "" + dstr(""Edit description"", ""Modifier description"")))
                {
                    dmenu_state = ""dsave_edit_desc"";
                    keyboard_string = """";
                    dkeyboard_input = """";
                }
                if (check_name == (""- "" + dstr(""Change category"", ""Changer description"")))
                {
                    dmenu_state = ""dsave_edit_cat"";
                    keyboard_string = """";
                    dkeyboard_input = """";
                }
            }
            break;
        case ""dsave_edit_name"":
        case ""dsave_edit_desc"":
        case ""dsave_edit_cat"":
            if (dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state_update();
            }
            else if (dvertical_index == 1 && dhorizontal_index == 0)
            {
                dremove_false_history();
                var target_sec = global.debug_selected_save_section;
                var final_text = dkeyboard_input;
                var ini_key = """";
                if (dmenu_state == ""dsave_edit_name"")
                {
                    ini_key = ""SaveName"";
                }
                else if (dmenu_state == ""dsave_edit_desc"")
                {
                    ini_key = ""Description"";
                }
                else if (dmenu_state == ""dsave_edit_cat"")
                {
                    ini_key = ""Category"";
                }
                var new_path = scr_debug_save_modify_info(target_sec, ini_key, final_text);
                if (ini_key == ""SaveName"" && final_text != """")
                {
                    global.debug_selected_save_name = final_text;
                }
                if (new_path != """")
                {
                    global.debug_selected_save_section = new_path;
                }
                global.dreading_custom_flag = 0;
                dkeyboard_input = """";
                scr_get_debug_save_list();
                dpop_history();
            }
            else
            {
                dremove_false_history();
                global.dreading_custom_flag = 0;
                dkeyboard_input = """";
                dpop_history();
            }
            break;
        case ""new_debug_save"":
            if (dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state_update();
            }
            else if (dvertical_index == 1 && dhorizontal_index == 0)
            {
                if (dkeyboard_input != """")
                {
                    global.debug_save_name = dkeyboard_input;
                }
                else
                {
                    global.debug_save_name = dstr(""Untitled"", ""Sans titre"");
                }
                dkeyboard_input = """";
                scr_debug_print(dstr(""Save created: "", ""Sauvegarde créée : "") + string(global.debug_save_name));
                global.debug_saving = 1;
                scr_debug_save();
                dmenu_popup_launch = 0;
                dmenu_state = ""debug"";
                dbutton_layout = 0;
                dbutton_options = dbutton_options_original;
                dmenu_state_history = [];
                dmenu_vertical_index_history = [];
                dvertical_index = 0;
                dmenu_active = false;
                global.interact = 0;
                snd_play(snd_save);
            }
            else
            {
                dkeyboard_input = """";
                dmenu_popup_launch = 0;
                dmenu_state = ""debug"";
                dbutton_layout = 0;
                dbutton_options = dbutton_options_original;
                dmenu_state_history = [];
                dmenu_vertical_index_history = [];
                dvertical_index = 0;
                dmenu_active = false;
                global.interact = 0;
            }
            break;
        case ""warp"":
            if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = """";
                dkeyboard_input = """";
                dmenu_state_update();
            }
            else
            {
                drooms_options.target_room = -1;
                if (dvertical_index != 0)
                {
                    drooms_options.target_room = dbutton_indices[dvertical_index];
                }
                drooms_options.target_plot = global.plot;
                drooms_options.target_is_darkzone = global.darkzone;
                drooms_options.target_member_2 = global.char[1];
                drooms_options.target_member_3 = global.char[2];
                dmenu_state = ""warp_options"";
                dkeyboard_input = """";
            }
            break;
        case ""warp_options"":
            if (dvertical_index == 0)
            {
                dkeyboard_input = """";
                dmenu_state = ""warp"";
            }
            else if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                drooms_options.target_is_darkzone ^= 1;
            }
            else if (dvertical_index >= 2 && dvertical_index <= 4)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                if (dvertical_index == 2)
                {
                    global.dreading_custom_flag = 1;
                    keyboard_string = """";
                }
            }
            else if (dvertical_index == 5)
            {
                new_room = drooms_options.target_room;
                if (new_room == -1)
                {
                    new_room = room;
                }
                global.plot = drooms_options.target_plot;
                global.darkzone = drooms_options.target_is_darkzone;
                global.char[1] = drooms_options.target_member_2;
                global.char[2] = drooms_options.target_member_3;
                global.interact = 0;
                dmenu_active = false;
                room_goto(new_room);
            }
            break;
        case ""give"":
            if (dhorizontal_index == 0)
            {
                dmenu_state = ""objects"";
            }
            else if (dhorizontal_index == 1)
            {
                dmenu_state = ""armors"";
            }
            else if (dhorizontal_index == 2)
            {
                dmenu_state = ""weapons"";
            }
            else if (dhorizontal_index == 3)
            {
                dmenu_state = ""keyitems"";
            }
            dhorizontal_page = !global.darkzone;
            if (dhorizontal_index == 3)
            {
                dhorizontal_page = 0;
            }
            dvertical_index = 0;
            dhorizontal_index = 0;
            break;
        case ""objects"":
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dvertical_index = clamp(dvertical_index, 0, array_length(dbutton_options));
                dgiver_button_selected = dvertical_index;
                dmenu_state = ""givertab"";
                dvertical_index = 0;
            }
            break;
        case ""armors"":
            if (dhorizontal_page == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.larmor = dlight_armors[dvertical_index][0];
                break;
            }
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dgiver_button_selected = dvertical_index;
                dmenu_state = ""givertab"";
                dvertical_index = 0;
            }
            break;
        case ""weapons"":
            if (dhorizontal_page == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.lweapon = dlight_weapons[dvertical_index][0];
                break;
            }
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dgiver_button_selected = dvertical_index;
                dmenu_state = ""givertab"";
                dvertical_index = 0;
            }
            break;
        case ""keyitems"":
            if (dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dgiver_button_selected = dvertical_index;
                dmenu_state = ""givertab"";
                dvertical_index = 0;
            }
            break;
        case ""givertab"":
            dremove_false_history();
            if (dgiver_amount == 0)
            {
                scr_debug_print(dstr(""Cancelled"", ""Annulé""));
                break;
            }
            if (dgiver_menu_state == ""objects"")
            {
                var real_index = dbutton_indices[dgiver_button_selected];
                for (var i = 0; i < abs(dgiver_amount); i++)
                {
                    if (dgiver_amount < 0)
                    {
                        if (dhorizontal_page == 0)
                        {
                            scr_itemremove(real_index);
                        }
                        else
                        {
                            scr_litemremove(real_index);
                        }
                    }
                    else if (dhorizontal_page == 0)
                    {
                        scr_itemget(real_index);
                    }
                    else
                    {
                        scr_litemget(real_index);
                    }
                }
                if (dgiver_amount < 0)
                {
                    scr_debug_print(string(abs(dgiver_amount)) + "" "" + dgiver_bname + dstr("" removed from inventory"", "" retiré de l'inventaire""));
                }
                else
                {
                    scr_debug_print(string(dgiver_amount) + "" "" + dgiver_bname + dstr("" added to inventory"", "" ajouté à l'inventaire""));
                }
            }
            if (dgiver_menu_state == ""armors"")
            {
                if (dgiver_amount > 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < dgiver_amount; i++)
                    {
                        scr_armorget(real_index);
                    }
                    scr_debug_print(string(dgiver_amount) + "" "" + dgiver_bname + dstr("" added to inventory"", "" ajouté à l'inventaire""));
                }
                else if (dgiver_amount < 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < abs(dgiver_amount); i++)
                    {
                        scr_armorremove(real_index);
                    }
                    scr_debug_print(string(abs(dgiver_amount)) + "" "" + dgiver_bname + dstr("" removed from inventory"", "" retiré de l'inventaire""));
                }
            }
            if (dgiver_menu_state == ""weapons"")
            {
                if (dgiver_amount > 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < dgiver_amount; i++)
                    {
                        scr_weaponget(real_index);
                    }
                    scr_debug_print(string(dgiver_amount) + "" "" + dgiver_bname + dstr("" added to inventory"", "" ajouté à l'inventaire""));
                }
                else if (dgiver_amount < 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < abs(dgiver_amount); i++)
                    {
                        scr_weaponremove(real_index);
                    }
                    scr_debug_print(string(abs(dgiver_amount)) + "" "" + dgiver_bname + dstr("" removed from inventory"", "" retiré de l'inventaire""));
                }
            }
            if (dgiver_menu_state == ""keyitems"")
            {
                if (dgiver_amount > 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < dgiver_amount; i++)
                    {
                        scr_keyitemget(real_index);
                    }
                    scr_debug_print(string(dgiver_amount) + "" "" + dgiver_bname + dstr("" added to inventory"", "" ajouté à l'inventaire""));
                }
                else if (dgiver_amount < 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < abs(dgiver_amount); i++)
                    {
                        scr_keyitemremove(real_index);
                    }
                    scr_debug_print(string(abs(dgiver_amount)) + "" "" + dgiver_bname + dstr("" removed from inventory"", "" retiré de l'inventaire""));
                }
            }
            dpop_history();
            dmenu_active = false;
            global.interact = 0;
            break;
        case ""flag_categories"":
            if (dvertical_index > 0)
            {
                dother_options = [];
                var real_index = dbutton_indices[dvertical_index];
                for (var i = 0; i < array_length(dother_all_options); i++)
                {
                    options = dother_all_options[i];
                    if (options[0] == real_index)
                    {
                        array_push(dother_options, options);
                    }
                }
                dmenu_skip_reindexing = true;
                dmenu_state = ""flag_misc"";
                dmenu_start_index = 0;
                dvertical_index = 0;
                dhorizontal_index = find_subarray_index(dother_options[0][2], dother_options[0][3]);
            }
            else
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                dhorizontal_index = 0;
                keyboard_string = """";
            }
            break;
        case ""flag_misc"":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            break;
        case ""recruits"":
            dremove_false_history();
            if (dvertical_index != 0)
            {
                dmenu_skip_reindexing = true;
            }
            if (dvertical_index == 0)
            {
                dmenu_state = ""recruit_presets"";
            }
            break;
        case ""recruit_presets"":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            for (var c = 1; c <= global.chapter; c++)
            {
                if (dhorizontal_page != 0)
                {
                    c = dhorizontal_page;
                }
                var test_lst = scr_get_chapter_recruit_data(c);
                for (var i = 0; i < array_length(test_lst); i++)
                {
                    var enemy_id = test_lst[i];
                    scr_recruit_info(enemy_id);
                    if (dvertical_index == 0)
                    {
                        global.flag[enemy_id + 600] = 1;
                    }
                    else
                    {
                        global.flag[enemy_id + 600] = -1;
                    }
                }
                if (dhorizontal_page != 0)
                {
                    break;
                }
            }
            if (dvertical_index == 0)
            {
                snd_play(snd_pirouette);
            }
            else
            {
                snd_play(snd_weirdeffect);
            }
            dpop_history();
            break;
        case ""globals_changer"":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            if (global.dreading_custom_flag)
            {
                var value = 0;
                cur_global_array = dglobal_changer_options[dvertical_index];
                reading_double_flag = dvertical_index == 0;
                glob_name = cur_global_array[0];
                glob_index = -1;
                if (reading_double_flag)
                {
                    parse_var_str(dcustom_flag_text[0], 1);
                    glob_name = dtemp_text;
                    glob_index = dtemp_num;
                }
                else if (cur_global_array[2] != -1)
                {
                    glob_index = dhorizontal_index;
                }
                scr_debug_print(string(cur_global_array));
                switch (cur_global_array[1])
                {
                    case ""string"":
                        value = string(dcustom_flag_text[reading_double_flag]);
                        break;
                    case ""int"":
                    case ""uint"":
                    case ""real"":
                        value = real(dcustom_flag_text[reading_double_flag]);
                        break;
                    default:
                        scr_debug_print(""Unrecognized type |"" + string(cur_global_array[1]) + ""|"");
                }
                if (glob_index != -1)
                {
                    base = variable_global_get(glob_name);
                    base[glob_index] = value;
                    value = base;
                }
                variable_global_set(glob_name, value);
                scr_debug_print(""Changed global."" + string(glob_name) + "" to |"" + string(value) + ""|"");
            }
            else if (dvertical_index == 0)
            {
                dhorizontal_index = 0;
            }
            set_keyboard_reader(global.dreading_custom_flag ^ 1);
            break;
        default:
            snd_play(snd_error);
            scr_debug_print(dstr(""Invalid selection!"", ""Sélection invalide !""));
    }
}
");


importGroup.QueueReplace(obj_dmenu_system.EventHandlerFor(EventType.Draw, (uint)0, Data),
@"xx = __view_get(e__VW.XView, 0);
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
    
    if (dmenu_state == ""debug"")
    {
        draw_set_halign(fa_right);
        draw_set_font(fnt_main);
        var text_scale = (global.darkzone == 1) ? 1 : 0.5;
        draw_set_color(c_gray);
        
        var str_ = string(dstr(""M - Keys"", ""M - Touches""));
        
        var draw_x = (((xcenter + (menu_width / 2)) - 10) * d) + xx;
        var draw_y = (((ycenter + (menu_length / 2)) - 15) * d) + yy;
        
        draw_text_transformed(draw_x, draw_y, str_, text_scale, text_scale, 0);
        
        var _fnt = (global.darkzone == 1) ? fnt_mainbig : fnt_main;
        draw_set_font(_fnt);
        draw_set_halign(fa_left);
    }

    if (dmenu_state == ""debug"")
    {
        draw_set_halign(fa_right);
        draw_set_font(fnt_main);
        var text_scale = (global.darkzone == 1) ? 1 : 0.5;
        draw_set_color(c_gray);
        var str_ = string(dstr(""F - French"", ""F - Anglais""));
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
        draw_text(draw_x, draw_y, string(dstr(""Esc - Cancel"", ""Esc - Annuler"")));
        draw_set_halign(fa_left);
    }
    
    if (global.dreading_custom_flag)
    {
        if (dmenu_state == ""flag_categories"")
        {
            var base_x = x_start + xx;
            var base_y = (((110 - (dmenu_start_index * 20)) + 2) * d) + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var thickness = 1 * d;
            var visual_offset = -5;
            var cursor_padding = 3 * d;
            var w_prefix = string_length(""global.flag["") * mono_spacing;
            var w_name = string_length(string(dcustom_flag_text[0])) * mono_spacing;
            var w_middle = string_length(""] = |"") * mono_spacing;
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
        else if (dmenu_state == ""warp"" || dmenu_state == ""debug_save"")
        {
            var base_x = x_start + xx;
            var base_y = (((130 - (dmenu_start_index * 20)) + 2) * d) + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var thickness = 1 * d;
            var visual_offset = -2;
            var cursor_padding = 3 * d;
            var w_prefix = string_length(string(dstr(""Contains: "", ""Contient : ""))) * mono_spacing;
            var w_name = string_length(string(dkeyboard_input)) * mono_spacing;
            var x1_start = base_x + w_prefix;
            var x2_start = x1_start + w_name;
            draw_set_color(c_yellow);
            var draw_w_name = (w_name == 0) ? (mono_spacing / 4) : w_name;
            
            if (dhorizontal_index == 0)
                draw_rectangle((x1_start + visual_offset) - cursor_padding, base_y, x1_start + draw_w_name + visual_offset + cursor_padding, base_y + thickness, false);
        }
        else if (dmenu_state == ""warp_options"")
        {
            var base_x = x_start + xx;
            var base_y = (((150 - (dmenu_start_index * 20)) + 2) * d) + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var thickness = 1 * d;
            var visual_offset = -2;
            var cursor_padding = 3 * d;
            var w_prefix = string_length(string(dstr(""Plot Value: "", ""Valeur de plot : ""))) * mono_spacing;
            var w_name = string_length(string(dkeyboard_input)) * mono_spacing;
            var x1_start = base_x + w_prefix;
            var x2_start = x1_start + w_name;
            draw_set_color(c_yellow);
            var draw_w_name = (w_name == 0) ? (mono_spacing / 4) : w_name;
            
            if (dhorizontal_index == 0)
                draw_rectangle((x1_start + visual_offset) - cursor_padding, base_y, x1_start + draw_w_name + visual_offset + cursor_padding, base_y + thickness, false);
        }
        else if (dmenu_state == ""new_debug_save"" || dmenu_state == ""dsave_edit_name"" || dmenu_state == ""dsave_edit_desc"" || dmenu_state == ""dsave_edit_cat"")
        {
            var base_x = x_start + x_padding + xx;
            var base_y = y_start + yy;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
            var max_width = box_right_edge - base_x;
            var line_sep = 16 * d;
            var cursor_x = base_x;
            var cursor_y = base_y;
            var current_word = """";
            var input_str = string(dkeyboard_input);
            var str_len = string_length(input_str);
            
            for (var i = 1; i <= str_len; i++)
            {
                var _char = string_char_at(input_str, i);
                
                if (_char != "" "" && _char != ""\n"")
                    current_word += _char;
                
                if (_char == "" "" || _char == ""\n"" || i == str_len)
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
                    
                    current_word = """";
                    
                    if (_char == "" "")
                    {
                        cursor_x += mono_spacing;
                    }
                    else if (_char == ""\n"")
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
                var needs_arrows = (is_cur_line && dmenu_state == ""flag_misc"") || (dmenu_state == ""warp_options"" && (button_index == 3 || button_index == 4)) || (dmenu_state == ""debug_save_options"" && button_index == 0);
                
                if (needs_arrows)
                {
                    var show_left = false;
                    
                    if (dmenu_state == ""flag_misc"" && dhorizontal_index != 0)
                        show_left = true;
                    else if (dmenu_state == ""warp_options"" && array_get([drooms_options.target_member_2, drooms_options.target_member_3], button_index - 3) != 0)
                        show_left = true;
                    else if (dmenu_state == ""debug_save_options"" && global.dload_cur_inv != 0)
                        show_left = true;
                    
                    if (show_left)
                    {
                        for (dash_pos = 0; 1; dash_pos++)
                        {
                            var check_char = ""-"";
                            
                            if (dmenu_state == ""warp_options"")
                                check_char = "":"";
                            else if (dmenu_state == ""debug_save_options"")
                                check_char = ""("";
                            
                            if (dash_pos > 4 && string_char_at(cur_btn, dash_pos) == check_char)
                                break;
                        }
                        
                        if (dmenu_state != ""debug_save_options"")
                            dash_pos++;
                        else
                            dash_pos -= 2;
                        
                        draw_sprite_ext(spr_morearrow, 0, x_start + ((dash_pos * mono_spacing) + floor(mono_spacing / 2)) + dmenu_arrow_yoffset + xx, y_start + (i * y_spacing) + side_arrows_mult[0] + yy, darrow_scale, -darrow_scale, 90, c_white, 1);
                    }
                    
                    var show_right = false;
                    
                    if (dmenu_state == ""flag_misc"" && dhorizontal_index < (array_length(dother_options[dvertical_index][3]) - 1))
                        show_right = true;
                    else if (dmenu_state == ""warp_options"" && array_get([drooms_options.target_member_2, drooms_options.target_member_3], button_index - 3) != (4 - (global.chapter == 1)))
                        show_right = true;
                    else if (dmenu_state == ""debug_save_options"" && global.dload_cur_inv != 1)
                        show_right = true;
                    
                    if (show_right)
                        draw_sprite_ext(spr_morearrow, 0, (x_start + xx + ((string_length(cur_btn) + 1) * mono_spacing)) - floor(mono_spacing / 2) - dmenu_arrow_yoffset, y_start + yy + (i * y_spacing) + side_arrows_mult[1], darrow_scale, -darrow_scale, 270, c_white, 1);
                }
                else if (dmenu_state == ""recruits"" && button_index == 0)
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
    
    if (dmenu_state == ""recruits"" || dmenu_state == ""weapons"" || dmenu_state == ""armors"" || dmenu_state == ""objects"")
    {
        draw_set_halign(fa_right);
        var draw_y = (((ycenter - (menu_length / 2)) + 8) * d) + yy;
        var draw_x = x_start + (200 * d) + xx;
        
        if (dmenu_state == ""recruits"")
        {
            if (dhorizontal_page != 0)
                draw_text(draw_x, draw_y, ""("" + string(dstr(""chap"")) + "" "" + string(dhorizontal_page) + "")"");
            else
                draw_text(draw_x, draw_y, string(dstr(""(all chap)"", ""(tout chap)"")));
        }
        else if (dhorizontal_page == 0)
        {
            draw_text(draw_x + 30 + (global.darkzone * 30), draw_y, string(dstr(""(Darkworld)"")));
            draw_sprite_ext(spr_morearrow, 0, draw_x + 35 + (global.darkzone * 35) + dmenu_arrow_yoffset, draw_y + side_arrows_mult[1], darrow_scale, -darrow_scale, 270, c_white, 1);
        }
        else
        {
            draw_text(draw_x + 30 + (global.darkzone * 30), draw_y, string(dstr(""(Lightworld)"")));
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
        var itemreminder = """";
        
        if (dgiver_menu_state == ""objects"")
        {
            itemreminder = ""["" + string(dgiver_bname) + ""]"";
            
            if (dhorizontal_page == 0)
                scr_itemcheck(0);
            else
                scr_litemcheck(0);
            
            max_items = (dhorizontal_page == 0) ? 12 : 8;
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr(""ITEMs: "", ""OBJETs : "")) + string(max_items - itemcount) + "" / "" + string(max_items));
        }
        
        if (dgiver_menu_state == ""armors"")
        {
            itemreminder = ""["" + string(dgiver_bname) + ""]"";
            scr_armorcheck_inventory(0);
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr(""ARMORs: "", ""ARMUREs : "")) + string(48 - itemcount) + "" / 48"");
        }
        
        if (dgiver_menu_state == ""weapons"")
        {
            itemreminder = ""["" + string(dgiver_bname) + ""]"";
            scr_weaponcheck_inventory(0);
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr(""WEAPONs: "", ""ARMEs : "")) + string(48 - itemcount) + "" / 48"");
        }
        
        if (dgiver_menu_state == ""keyitems"")
        {
            itemreminder = ""["" + string(dgiver_bname) + ""]"";
            scr_keyitemcheck(0);
            draw_text(x_start + xx, ((ycenter + 25) * d) + yy, string(dstr(""KEY ITEMs: "", ""OBJETs CLÉs : "")) + string(12 - itemcount) + "" / 12"");
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
        var current_word = """";
        var str_len = string_length(cur_btn);
        
        for (var i = 1; i <= str_len; i++)
        {
            var _char = string_char_at(cur_btn, i);
            
            if (_char != "" "" && _char != ""\n"")
                current_word += _char;
            
            if (_char == "" "" || _char == ""\n"" || i == str_len)
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
                
                current_word = """";
                
                if (_char == "" "")
                {
                    cursor_x += mono_spacing;
                }
                else if (_char == ""\n"")
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
        else if (dkeyboard_input != """")
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
    
    if (dhinter_active && dhinter_text != """" && (scr_array_contains(ditem_types, dmenu_state) || dmenu_state == ""warp_options"" || dmenu_state == ""debug_save"" || dmenu_state == ""debug_save_options""))
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
    dkeys_data = [string(dstr(""F10 - Toggle debug mode"", ""F10 - Activer/désactiver le debug mode"")), string(dstr(""S - Save game"", ""S - Sauvegarder la partie"")), string(dstr(""L - Load last save"", ""L - Charger la dernière sauvegarde"")), string(dstr(""R - Reload room | Backspace+R - Restart game"", ""R - Charger la salle | Retour arrière+R - Redémarrer le jeu"")), string(dstr(""M+1 | M+2 - Add/remove 100 D$"", ""M+1 | M+2 - Ajouter/retirer 100 D$"")), string(dstr(""Delete - Go to previous room"", ""Suppr - Se rendre à la salle précédente"")), string(dstr(""Insert - Go to next room"", ""Insert - Se rendre à la salle suivante"")), string(dstr(""G - Toggle godmode"", ""G - Activer/désactiver le godmode"")), string(dstr(""W - Skip battle | Shift+W - Skip battle with recruit"", ""W - Passer un combat | Shift+W - Passer un combat avec recrue"")), string(dstr(""V - Skip enemy turn"", ""V - Passer le tour de l'ennemi"")), string(dstr(""H - Restore party HP"", ""H - Restaurer les HP du party"")), string(dstr(""T - Fill/empty TP bar"", ""T - Remplir/vider la barre de TP"")), string(dstr(""P -Set game to 1 FPS | Alt+P - Disable/restore bubble dialog autoskip"", ""P - Mettre le jeu à 1 FPS | Alt+P - Désactiver l'autoskip des bulles de combat"")), string(dstr(""O - Toggle 30, 60, 120 FPS"", ""O - Basculer entre 30, 60 et 120 FPS"")), string(dstr(""Backspace - Skip intro sequence (Ch1)"", ""Retour arrière - Passer le segment d'intro (Ch1)"")), string(dstr(""Middle Click - Room Editor"", ""Clic milieu - Éditeur de salle""))];
    
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
    
    draw_text_transformed(draw_x, draw_y, string(dstr(""M - Close"", ""M - Fermer"")), text_scale, text_scale, 0);
    
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    draw_text_transformed(x_start + xx, (((ycenter - (menu_length / 2)) + 8) * d) + yy, string(dstr(""Debug Mode Keys"", ""Touches du debug mode"")), text_scale, text_scale, 0);
    
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
}");

importGroup.Import();

ScriptMessage("Mode Debug du Chapitre 2 ajouté.\r\n" + "Pour activer le Mode Debug en jeu, appuyer sur F10.");