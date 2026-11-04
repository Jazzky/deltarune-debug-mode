function dmenuback_kb_warp_options()
{
	if (keyboard_check_pressed(vk_escape))
		return (-1);

	var _exit = (up_held || down_held || enter_held);
	if (!_exit)
		return (0);

	var plot_text = dkeyboard_texts[0];
	if (!dutils_isnum(plot_text, true)) {
		snd_play(299);
		return (-1);
	}

	drooms_options.target_plot = real(plot_text);
	snd_play(420);
	return (-1);
}
