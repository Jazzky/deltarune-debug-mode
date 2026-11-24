function dinit_debug_mode()
{
	global.debug = 0;
	global.dlang = "en";

	global.dgodmode = 0;
	global.dpause_dialog = 0;
	global.dprint_errors = true;

	if (global.chapter == 3)
	{
		global.chemg_show_room = 1;
		global.chemg_show_val = 1;
	}

	global.dfight_opt_target_all = false;

	dinit_commands();
	instance_create(0, 0, obj_dkeyboard_system);

    instance_create_depth(0, 0, -99999, obj_dconsole_system);
    instance_create(0, 0, obj_dmenu_system);
}
