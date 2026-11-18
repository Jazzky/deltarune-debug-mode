function dmenu_action_dsaves_keys()
{
    if (!keyboard_check_pressed(ord("I")))
		exit;

	scr_debug_save_scan_imports();
	scr_get_debug_save_list();
	dmenu_set_reindex(true);
}
