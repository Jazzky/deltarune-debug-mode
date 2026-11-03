function dmenu_update_main_menu()
{
	dmenu_title = dstr("Debug Menu", "Menu Debug");

	dmenu_state = "debug";
	dmenu_parent_state = "";

	dbutton_options = [];
	dbutton_options_2d = [
		[dstr("Warps", "Sauts"), dstr("Items"), dstr("Recruits", "Recrues"), dstr("Flags")],
		[dstr("Globals"), dstr("Debug save")]
	];

	if (global.chapter < 3)
		array_delete(dbutton_options_2d[0], 2, 1);

	dmenu_box = 0;
	dbutton_layout = 0;
}
