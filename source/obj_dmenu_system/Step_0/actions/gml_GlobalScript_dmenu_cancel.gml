function dmenu_cancel()
{
	snd_play(snd_smallswing);
	if (dmenu_state == "debug_save" && dmenu_popup_launch == 1)
	{
		if (!instance_exists(obj_savemenu))
		{
			instance_create(0, 0, obj_savemenu);
			obj_savemenu.menuno = 1;
			obj_savemenu.mpos = 3;
			global.interact = 1;
		}
	}
	dpop_history();
	dmenu_set_reindex(true);
}
