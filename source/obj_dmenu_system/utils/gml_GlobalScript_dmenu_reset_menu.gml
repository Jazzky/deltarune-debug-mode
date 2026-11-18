function dmenu_reset_menu()
{
	dmenu_update_history("init");

	dbuttons = [];
	dmenu_active = false;
	dmenu_popup_launch = 0;

	global.interact = 0;
}
