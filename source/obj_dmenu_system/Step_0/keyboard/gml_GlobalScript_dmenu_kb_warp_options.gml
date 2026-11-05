function dmenu_kb_warp_options()
{
	if (keyboard_check_pressed(vk_escape))
		return (1);

	var _exit = (up_held || down_held || keyboard_check_pressed(vk_enter));
	if (!_exit)
		return (-1);

	var plot_text = dkeyboard_texts[0];
	if (!dutils_isnum(plot_text, true)) {
		snd_play(299);
		return (1);
	}

	drooms_options.target_plot = real(plot_text);
	snd_play(420);
	return (0);
}
