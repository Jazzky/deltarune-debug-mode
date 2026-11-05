function dmenu_reset_menu()
{
	dbuttons = [];
	dmenu_update_main_menu();

	dmenu_active = false;
	dmenu_popup_launch = 0;

	dvertical_index = 0;
	dvertical_index_history = [];

	dmenu_start_index = 0;
	dmenu_start_index_history = [];

	dhorizontal_index = 0;
	dhorizontal_index_history = [];

	dhorizontal_page = 0;
	dhorizontal_page_history = [];

	dmenu_state_history = [];
	global.interact = 0;
}
