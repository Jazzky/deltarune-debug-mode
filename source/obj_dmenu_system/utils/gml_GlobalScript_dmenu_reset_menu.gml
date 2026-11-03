function dmenu_reset_menu()
{
	dmenu_update_main_menu();

	dmenu_active = false;
	dmenu_popup_launch = 0;

	dmenu_state = "debug";
	dmenu_state_history = [];

	dvertical_index = 0;
	dmenu_vertical_index_history = [];

	dhorizontal_index = 0;
	dmenu_horizontal_index_history = [];

	dhorizontal_page = 0;
	dmenu_page_index_history = [];

	global.interact = 0;
}
