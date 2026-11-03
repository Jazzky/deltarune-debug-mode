if (keyboard_check_pressed(vk_f10))
{
    global.debug = !global.debug;
    
    if (global.debug)
        scr_debug_print(dstr("Debug Mode activated!", "Mode Debug activé !"));
    else
        scr_debug_print(dstr("Debug Mode deactivated!", "Mode Debug désactivé !"), true);
}

if (scr_debug() && !dutils_reading_kb())
{
    if (keyboard_check_pressed(ord("G")))
    {
		global.dgodmode = !global.dgodmode;

        if (global.dgodmode)
			scr_debug_print(dstr("Godmode enabled", "Godmode activé"));
		else
			scr_debug_print(dstr("Godmode disabled", "Godmode désactivé"));
    }
    
    if (keyboard_check_pressed(ord("P")) && !keyboard_check(vk_alt))
    {
        if (!variable_global_exists("speed_fps"))
            global.speed_fps = 30;

        if (global.speed_fps == 30)
        {
            global.speed_fps = 1;
            game_set_speed(1, gamespeed_fps);
            scr_debug_print(dstr("FPS to 1", "FPS à 1"));
        }
        else
        {
            global.speed_fps = 30;
            game_set_speed(30, gamespeed_fps);
            scr_debug_print(dstr("FPS to 30", "FPS à 30"));
        }
    }

    if (keyboard_check_pressed(ord("O")))
    {
        if (!variable_global_exists("speed_fps"))
            global.speed_fps = 30;
        
        if (global.speed_fps == 30)
        {
            global.speed_fps = 60;
            game_set_speed(60, gamespeed_fps);
            scr_debug_print(dstr("FPS to 60", "FPS à 60"));
        }
        else if (global.speed_fps == 60)
        {
            global.speed_fps = 120;
            game_set_speed(120, gamespeed_fps);
            scr_debug_print(dstr("FPS to 120", "FPS à 120"));
        }
        else
        {
            global.speed_fps = 30;
            game_set_speed(30, gamespeed_fps);
            scr_debug_print(dstr("FPS to 30", "FPS à 30"));
        }
    }
}
global.dkeyboard_timing++
