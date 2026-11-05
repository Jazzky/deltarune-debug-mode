function dmenu_default_kb()
{
	if (keyboard_check_pressed(vk_escape))
		return (1);

	var _exit = (up_pressed || down_pressed || enter_pressed);
	if (!_exit)
		return (-1);

	return (2);
}
