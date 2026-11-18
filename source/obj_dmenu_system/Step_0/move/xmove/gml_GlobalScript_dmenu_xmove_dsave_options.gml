function dmenu_xmove_dsave_options()
{
	var keep_inv;
	
	if (left_pressed)
		keep_inv = false;
	else
		keep_inv = true;
	
	dload_options.target_keep_inv = keep_inv;
}
