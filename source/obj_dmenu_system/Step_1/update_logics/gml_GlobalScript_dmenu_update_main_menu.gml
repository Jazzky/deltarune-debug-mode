function dmenu_update_main_menu()
{
	dmenu_title = dstr("Debug Menu", "Menu Debug");

	dmenu_state = "debug";
	dmenu_parent_state = "";

	dbuttons = [];
	dbuttons_2d = [
		[
			dmenu_makebt(dstr("Warps", "Sauts"), "warp"),
			dmenu_makebt(dstr("Items"), "give"),
			dmenu_makebt(dstr("Recruits", "Recrues"), "recruits"),
			dmenu_makebt(dstr("Flags"), "flag_categories")
		],
		[
			dmenu_makebt(dstr("Globals"), "globals_changer"),
			dmenu_makebt(dstr("Debug save"), "debug_save")
		]
	];

	if (global.chapter < 3)
		array_delete(dbuttons_2d[0], 2, 1);

	dmenu_box = 0;
	dbutton_layout = 0;
}
