if (!global.dreading_kb && keyboard_check_pressed(ord("D")))
{
	dmenu_active = !dmenu_active;
	if (dmenu_state == "")
		dmenu_update_main_menu();
	
	if (dmenu_active)
		snd_play(snd_egg);
	else
		snd_play(snd_smallswing);

	global.interact = dmenu_active;
}

if (!dmenu_active)
	exit;

left_held = dutils_key_pressed(vk_left);
right_held = dutils_key_pressed(vk_right);
up_held = dutils_key_pressed(vk_up);
down_held = dutils_key_pressed(vk_down);

enter_pressed = keyboard_check_pressed(vk_enter);
left_pressed = keyboard_check_pressed(vk_left);
right_pressed = keyboard_check_pressed(vk_right);
up_pressed = keyboard_check_pressed(vk_up);
down_pressed = keyboard_check_pressed(vk_down);

if (dbutton_layout != 0) {
	cur_btn = dbuttons[dvertical_index];
	nb_button = array_length(dbuttons);
}
else if (dbutton_layout == 0) {
	cur_btn = dbuttons_2d[dvertical_index][dhorizontal_index];
}

btn_data = cur_btn.data;

dmenu_set_reindex(false);
if (dutils_reading_kb())
{
	dmenu_update_keyboard();
}

if (!dutils_reading_kb())
{
	var original_page = dhorizontal_page;
	var original_x = dhorizontal_index;
	var original_y = dvertical_index;

	dmenu_check_misc_keys();
	dmenu_xmove();
	dmenu_ymove();
	dmenu_fix_start_index();

	var changed_x = original_x != dhorizontal_index;
	var changed_y = original_y != dvertical_index;
	var changed_page = original_page != dhorizontal_page;

	if (changed_x || changed_y || changed_page)
		snd_play(snd_menumove);

	if (changed_x || changed_page)
		dmenu_set_reindex(true);

	//dmenuback_update_dhinter();

    if (button1_p())
		dmenu_confirm();
    
    if (button2_p())
		dmenu_cancel();

	if (dhorizontal_page != original_page)
		dmenu_set_reindex(true);
}

if (dmenu_set_reindex() == true)
{
	dmenu_state_update();
}
