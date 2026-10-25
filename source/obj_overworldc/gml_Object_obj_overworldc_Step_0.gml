if (scr_debug())
{
    if (keyboard_check_pressed(ord("S")))
        instance_create(0, 0, obj_savemenu);
    if (keyboard_check_pressed(ord("L")) && keyboard_check(vk_alt))
    {
        with (obj_dmenu_system)
            script_execute(scr_get_debug_save_list);

        obj_dmenu_system.dmenu_popup_launch = 1;
        obj_dmenu_system.dmenu_state = "debug_save";
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
    if (keyboard_check_pressed(ord("L")) && !keyboard_check(vk_alt))
        scr_load();

    if (keyboard_check_pressed(ord("R")) && keyboard_check(vk_backspace) && keyboard_check(vk_alt))
        scr_chapterswitch(0);

    if (keyboard_check_pressed(ord("R")) && keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
        game_restart_true();

    if (keyboard_check_pressed(ord("R")) && !keyboard_check(vk_backspace) && !keyboard_check(vk_alt))
    {
        snd_free_all();
        room_restart();
        global.interact = 0;
    }
}
