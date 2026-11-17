function dmenu_state_update(arg0 = dmenu_state)
{
	var state = arg0;
	dmenu_state = state;

	dhinter_text = "";
	dmenu_parent_state = "";
	dcategories_holder = [];
    switch (state)
    {
		// Main menu
        case "debug":
			dmenu_state_update_main_menu();
            break;



		// Debug Saves
        case "debug_save":
			dmenu_state_update_dsave_main_menu();
            break;
        
        case "debug_save_options":
			dmenu_state_update_dsave_load();
            break;
        
        case "dsave_edit_name":
        case "dsave_edit_desc":
        case "dsave_edit_cat":
			dmenu_state_update_dsave_metadata();
            break;
        
        case "new_debug_save":
			dmenu_state_update_dsave_new_save();
            break;
        


		// Warp
        case "warp":
			dmenu_state_update_warp();
            break;
        
        case "warp_options":
			dmenu_state_update_warp_options();
            break;
        


		// Items
        case "give":
			dmenu_state_update_items_main_menu();
            break;
        
        case "items":
        case "armors":
        case "weapons":
        case "keyitems":
			dmenu_state_update_items();
			break;
        
        case "givertab":
			dmenu_state_update_givertab();
            break;
        


		// Recruits
        case "recruits":
			dmenu_state_update_recruits();
            break;
        
        case "recruit_presets":
			dmenu_state_update_recruits_presets();
            break;
        


		// Flags
        case "flag_categories":
			dmenu_state_update_flag_categories();
            break;
        
        case "flag_misc":
			dmenu_state_update_flag();
            break;



		// Fight menu
		case "fight_menu":
			dmenu_state_update_fight_menu();
            break;
        
		case "add_enemy":
			dmenu_state_update_add_enemy();
            break;
        
		case "modify_enemy":
			dmenu_state_update_modify_enemy();
			break;



		// Misc
        case "globals_changer":
			dmenu_state_update_globals();
            break;
        
        default:
            dbuttons = [];
            dmenu_box = 0;
            dbutton_layout = 0;
    }
	dmenu_add_categories();
}

function dmenu_state_interact(arg0 = dmenu_state)
{
	var state = arg0;
	dmenu_state = state;

    selected_name = "";
    if (dbutton_layout == 0 || dbutton_layout == 3)
    {
        var safe_h_index = min(dhorizontal_index, array_length(dbuttons_2d[dvertical_index]) - 1);
        selected_name = string(dbuttons_2d[dvertical_index][safe_h_index]);
    }
    else
    {
        selected_name = string(dbuttons[dvertical_index].text);
    }
    
    switch (state)
    {
		// Main menu
        case "debug":
			dmenu_state_interact_main_menu();
            break;
        


		// Debug Saves
        case "debug_save":
			dmenu_state_interact_dsave_main_menu();
            break;
        
        case "debug_save_options":
			dmenu_state_interact_dsave_load_menu();
            break;
        
        case "dsave_edit_name":
        case "dsave_edit_desc":
        case "dsave_edit_cat":
			dmenu_state_interact_dsave_update_metadata_confirm();
			break;
        
        case "new_debug_save":
			dmenu_state_interact_new_dsave();
            break;
        


		// Warp
        case "warp":
			dmenu_state_interact_warp_setup();
            break;
        
        case "warp_options":
			dmenu_state_interact_warp();
            break;
        


		// Items
        case "give":
			dmenu_state_interact_set_itemgiver_type();
            break;
        
        case "items":
        case "armors":
        case "weapons":
        case "keyitems":
			dmenu_state_interact_setup_givertab();
            break;
        
        case "givertab":
			dmenu_state_interact_givertab();
            break;
        


		// Flags
        case "flag_categories":
			dmenu_state_interact_flag_categories();
            break;
        
        case "flag_misc":
			dmenu_state_interact_flags();
            break;
        


		// Recruits
        case "recruits":
			dmenu_state_interact_recruits();
            break;
        
        case "recruit_presets":
			dmenu_state_interact_recruits_presets();
            break;



		// Fight menu
		case "fight_menu":
			dmenu_state_interact_fight_menu();
            break;

		case "add_enemy":
			dmenu_state_interact_add_enemy();
            break;

		case "modify_enemy":
			dmenu_state_interact_modify_enemy();
			break;



		// Other
        case "globals_changer":
			dmenu_state_interact_globals();
            break;
        
        default:
            snd_play(snd_error);
            scr_debug_print(dstr("Invalid selection!", "Sélection invalide !"));
    }
}
