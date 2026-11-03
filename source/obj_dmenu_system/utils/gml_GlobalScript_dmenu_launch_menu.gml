function dmenu_launch_state(arg0="debug")
{
	dmenu_reset_menu();
	dmenu_state_update(arg0);

	dmenu_active = 1;
	global.interact = 1;
	snd_play(snd_egg);
}
