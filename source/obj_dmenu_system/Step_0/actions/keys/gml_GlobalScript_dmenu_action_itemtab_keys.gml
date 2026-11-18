function dmenu_action_itemtab_keys()
{
	if (dhorizontal_page == 0 && right_pressed) {
		dhorizontal_page = 1;
		dvertical_index = 0;
	}

	else if (dhorizontal_page == 1 && left_pressed) {
		dhorizontal_page = 0;
		dvertical_index = 0;
	}
}
