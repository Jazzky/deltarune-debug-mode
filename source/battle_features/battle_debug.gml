if (scr_debug() && !dutils_reading_kb())
{
    if (keyboard_check_pressed(ord("P")))
    {
        global.dpause_dialog = !global.dpause_dialog;

        if (global.dpause_dialog)
            scr_debug_print(dstr("Dialog autoskip disabled", "Autoskip des dialogues désactivé"));
        else
            scr_debug_print(dstr("Dialog autoskip enabled (default)", "Autoskip des dialogues activé (par défault)"));
    }
    
    if (keyboard_check_pressed(ord("T")))
    {
        if (global.tension < 250)
        {
            global.tension = 250;
            scr_debug_print(dstr("TP to 250%", "PT à 250 %"));
        }
        else
        {
            global.tension = 0;
            scr_debug_print(dstr("TP to 0%", "PT à 0 %"));
        }
    }
    
    if (keyboard_check_pressed(ord("V")))
        scr_turn_skip();
        
    if (keyboard_check_pressed(ord("W")))
    {
        scr_wincombat();
        scr_debug_print(dstr("Fight skipped", "Combat passé"));
    }
}
