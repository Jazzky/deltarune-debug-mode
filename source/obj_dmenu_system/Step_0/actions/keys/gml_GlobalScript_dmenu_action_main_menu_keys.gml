function dmenu_action_main_menu_keys()
{
	if (keyboard_check_pressed(ord("M")))
    {
        if (dkeys_helper == 0)
            snd_play(snd_select);
        else
            snd_play(snd_smallswing);
        
        dkeys_helper = !dkeys_helper;
    }

    if (keyboard_check_pressed(ord("F")))
    {
        global.dlang = (global.dlang == "en") ? "fr" : "en";
        scr_debug_print(dstr("Debug menu now in English!", "Menu debug désormais en français !"));

		dmenu_reset_menu();
    }
}
