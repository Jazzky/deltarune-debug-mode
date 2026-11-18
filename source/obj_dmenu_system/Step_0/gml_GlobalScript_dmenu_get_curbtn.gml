function dmenu_get_curbtn()
{
	if (dbutton_layout == 0 || dbutton_layout == 3) {
		cur_btn = dbuttons_2d[dvertical_index][dhorizontal_index];
	}
	else {
		cur_btn = dbuttons[dvertical_index];
		nb_button = array_length(dbuttons);
	}

	btn_data = cur_btn.data;
}
