function dmenu_xmove_warp_options()
{
	var cur_party = drooms_options.target_member_2;
	if (dvertical_index == 4)
		cur_party = drooms_options.target_member_3;

	if (!left_held && !right_held)
		exit;

	var to_add = (left_held) ? -1 : 1;
	var new_party = cur_party + to_add;
	
	if (new_party == 1)
		new_party += to_add
	
	if (dvertical_index == 4)
		drooms_options.target_member_3 = new_party;
	else
		drooms_options.target_member_2 = new_party;
}
