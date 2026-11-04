function dmenu_xmove_recruits()
{
	var to_add = (left_held) ? -1 : 1;
	if (dvertical_index == 0)
	{
		dhorizontal_page = clamp(dhorizontal_page + to_add, 0, global.chapter);
		exit;
	}

	var real_index = cur_btn.data;
	var new_recruit_nb = -1;
	if (dhorizontal_index != -1)
		new_recruit_nb = dhorizontal_index / cur_btn.xranges[1];

	global.flag[600 + real_index] = new_recruit_nb;
	move_snd = snd_sparkle_gem;
}
