if (scr_debug())
{
    if (keyboard_check_pressed(ord("S")))
        instance_create(0, 0, obj_savemenu);
    if (keyboard_check_pressed(ord("L")) && keyboard_check(vk_alt))
    {
        with (obj_dmenu_system)
            script_execute(scr_get_debug_save_list);

		dmenu_launch_state("debug_save");
    }
    if (keyboard_check_pressed(ord("L")) && !keyboard_check(vk_alt))
        scr_load();
    if (keyboard_check_pressed(ord("R")) && keyboard_check(vk_backspace))
        game_restart_true();

    if (keyboard_check_pressed(ord("R")) && !keyboard_check(vk_backspace))
    {
        snd_free_all();
        room_restart();
        global.interact = 0;
    }
}
