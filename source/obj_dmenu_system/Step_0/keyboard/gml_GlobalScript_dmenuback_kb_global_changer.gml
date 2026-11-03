function dmenuback_kb_global_changer()
{
	if (keyboard_check_pressed(vk_escape) || up_pressed || down_pressed)
		return (-1);

	var _exit = enter_pressed;
	if (!_exit)
		return (0);

	dmenu_state_interact();
	return (-1);
}
