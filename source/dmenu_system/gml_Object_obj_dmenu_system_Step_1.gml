function dmenu_state_update()
{
    switch (dmenu_state)
    {
        case "debug":
            dmenu_title = dstr("Debug Menu", "Menu Debug");
            dbutton_options_2d = dbutton_options_original;
            dmenu_box = 0;
            dbutton_layout = 0;
            break;
        case "obj_handler":
            dmenu_title = dstr("Game Object List", "Liste de Game Objects");
            dbutton_options = [dstr("Create object instance", "Créer instance d'objet"), dstr("Search", "Recherche")];
            dbutton_indices = [-1, -1];
            if (global.dreading_custom_flag || dkeyboard_input != "")
            {
                dbutton_options[1] = dstr("Contains: ", "Contient : ");
            }
            else
            {
                dbutton_options[1] = dstr("Search", "Recherche");
            }
            dbutton_options[1] += dkeyboard_input;
            for (var i = 0; i < array_length(obj_list); i++)
            {
                if (!string_pos(dkeyboard_input, obj_list[i]))
                {
                    continue;
                }
                var combined = obj_list[i];
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, combined);
            }
            dbutton_layout = 1;
            dmenu_box = 1;
            break;
        case "obj_create":
            dmenu_title = dstr("Create Game Object", "Créer un Game Object");
            dbutton_options = [dstr("Search", "Recherche")];
            dbutton_indices = [-1];
            if (global.dreading_custom_flag || dkeyboard_input != "")
            {
                dbutton_options[0] = dstr("Name: ", "Nom : ");
            }
            else
            {
                dbutton_options[0] = dstr("Search", "Recherche");
            }
            dbutton_options[0] += dkeyboard_input;
            for (var i = 0; i < array_length(all_obj_list); i++)
            {
                if (!string_pos(dkeyboard_input, all_obj_list[i]))
                {
                    continue;
                }
                var combined = all_obj_list[i];
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, combined);
            }
            dbutton_layout = 1;
            dmenu_box = 1;
            break;
        case "debug_save":
            dmenu_title = "Debug save";
            dbutton_options = [dstr("New save", "Nouvelle sauvegarde"), dstr("Search", "Recherche")];
            dbutton_indices = [-2, -2];
            var subs = [];
            if (global.dreading_custom_flag || dkeyboard_input != "")
            {
                dbutton_options[1] = dstr("Contains: ", "Contient : ") + dkeyboard_input;
            }
            else
            {
                dbutton_options[1] = dstr("Search", "Recherche") + dkeyboard_input;
            }
            for (var i = 0; i < array_length(debug_save_names); i++)
            {
                var s_chap = debug_save_chapters[i];
                if (s_chap != -1 && s_chap != global.chapter)
                {
                    continue;
                }
                var s_name = debug_save_names[i];
                var s_cat = debug_save_categories[i];
                if (s_cat != "")
                {
                    var cat_index = -1;
                    for (var j = 0; j < array_length(dbutton_options); j++)
                    {
                        if (dbutton_options[j] == s_cat)
                        {
                            cat_index = j;
                            break;
                        }
                    }
                    if (cat_index == -1)
                    {
                        cat_index = array_length(dbutton_options);
                        array_push(dbutton_options, s_cat);
                        array_push(dbutton_indices, -1);
                        subs[cat_index] = [];
                        subs[cat_index + 1000] = [];
                    }
                    array_push(subs[cat_index], s_name);
                    array_push(subs[cat_index + 1000], i);
                }
                else
                {
                    array_push(dbutton_options, s_name);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_process_submenus(subs, dkeyboard_input);
            dmenu_box = 1;
            dbutton_layout = 1;
            break;
        case "debug_save_options":
            dmenu_title = dstr("Options: ", "Options : ") + string(global.debug_selected_save_name);
            dbutton_options = [dstr("Load", "Charger"), dstr("Save", "Sauver"), dstr("Export", "Exporter"), dstr("Save management", "Gestion sauvegardes"), dstr("Delete", "Supprimer")];
            dbutton_indices = [-2, -2, -1, -1, -2];
            var subs = array_create(array_length(dbutton_options), 0);
            subs[2] = [dstr("Debug mode save", "Sauvegarde mode debug"), dstr("Default Deltarune save", "Sauvegarde Deltarune par défaut")];
            subs[3] = [dstr("Rename", "Renommer"), dstr("Edit description", "Modifier description"), dstr("Change category", "Changer catégorie")];
            dmenu_process_submenus(subs, "");
            if (!variable_global_exists("dload_cur_inv"))
            {
                global.dload_cur_inv = 0;
            }
            var load_options = [" (Normal)", dstr("  (Current inventory)", "  (Inventaire actuel)")];
            dbutton_options[0] += load_options[global.dload_cur_inv];
            dmenu_box = 1;
            dbutton_layout = 1;
            break;
        case "dsave_edit_name":
        case "dsave_edit_desc":
        case "dsave_edit_cat":
            if (dmenu_state == "dsave_edit_name")
            {
                dmenu_title = dstr("Rename save", "Renommer sauvegarde");
            }
            else if (dmenu_state == "dsave_edit_desc")
            {
                dmenu_title = dstr("Edit description", "Modifier description");
            }
            else if (dmenu_state == "dsave_edit_cat")
            {
                dmenu_title = dstr("Change category", "Changer catégorie");
            }
            dbutton_options_2d = [[""], [dstr("Save", "Sauver"), dstr("Cancel", "Annuler")]];
            dbutton_options = ["", ""];
            var target_path = global.debug_selected_save_section;
            var default_text = "";
            if (dmenu_state == "dsave_edit_name")
            {
                default_text = dstr("Enter save name", "Entrer nom de sauvegarde");
            }
            else if (dmenu_state == "dsave_edit_desc")
            {
                default_text = dstr("Enter description", "Entrer description");
            }
            else if (dmenu_state == "dsave_edit_cat")
            {
                default_text = dstr("Enter category", "Entrer catégorie");
            }
            for (var i = 0; i < array_length(debug_save_sections); i++)
            {
                if (debug_save_sections[i] == target_path)
                {
                    if (dmenu_state == "dsave_edit_name")
                    {
                        default_text = debug_save_names[i];
                    }
                    else if (dmenu_state == "dsave_edit_desc")
                    {
                        default_text = debug_save_descriptions[i];
                    }
                    else if (dmenu_state == "dsave_edit_cat")
                    {
                        default_text = debug_save_categories[i];
                    }
                    break;
                }
            }
            var cur_btn = default_text;
            if (global.dreading_custom_flag || dkeyboard_input != "")
            {
                cur_btn = dkeyboard_input;
            }
            dbutton_options_2d[0][0] = cur_btn;
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var text_x = x_start + x_padding + xx;
            var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
            var max_width = box_right_edge - text_x;
            var cursor_x = text_x;
            var is_multiline = false;
            var current_word = "";
            var str_len = string_length(cur_btn);
            for (var i = 1; i <= str_len; i++)
            {
                var _char = string_char_at(cur_btn, i);
                if (_char != " " && _char != "\n")
                {
                    current_word += _char;
                }
                if (_char == " " || _char == "\n" || i == str_len)
                {
                    var _word_width = string_length(current_word) * mono_spacing;
                    if (max_width > 0 && ((cursor_x + _word_width) - text_x) > max_width)
                    {
                        if (cursor_x != text_x)
                        {
                            is_multiline = true;
                        }
                    }
                    for (var w = 1; w <= string_length(current_word); w++)
                    {
                        if (max_width > 0 && ((cursor_x + mono_spacing) - text_x) > max_width)
                        {
                            is_multiline = true;
                        }
                        cursor_x += mono_spacing;
                    }
                    current_word = "";
                    if (_char == " ")
                    {
                        cursor_x += mono_spacing;
                    }
                    else if (_char == "\n")
                    {
                        is_multiline = true;
                    }
                }
            }
            dmenu_box = is_multiline ? 1 : 0;
            dbutton_layout = 3;
            break;
        case "new_debug_save":
            dmenu_title = "New debug save";
            dbutton_options_2d = [[dstr("Enter save name", "Entrer nom de sauvegarde")], [dstr("Save", "Sauver"), dstr("Cancel", "Annuler")]];
            var cur_btn = dstr("Enter save name", "Entrer nom de sauvegarde");
            if (global.dreading_custom_flag || dkeyboard_input != "")
            {
                cur_btn = dkeyboard_input;
                dbutton_options_2d[0][0] = cur_btn;
            }
            var mono_spacing = (global.darkzone == 1) ? 15 : 8;
            var text_x = x_start + x_padding + xx;
            var box_right_edge = (((xcenter + (menu_width / 2)) * d) - x_padding) + xx;
            var max_width = box_right_edge - text_x;
            var cursor_x = text_x;
            var is_multiline = false;
            var current_word = "";
            var str_len = string_length(cur_btn);
            for (var i = 1; i <= str_len; i++)
            {
                var _char = string_char_at(cur_btn, i);
                if (_char != " " && _char != "\n")
                {
                    current_word += _char;
                }
                if (_char == " " || _char == "\n" || i == str_len)
                {
                    var _word_width = string_length(current_word) * mono_spacing;
                    if (max_width > 0 && ((cursor_x + _word_width) - text_x) > max_width)
                    {
                        if (cursor_x != text_x)
                        {
                            is_multiline = true;
                        }
                    }
                    for (var w = 1; w <= string_length(current_word); w++)
                    {
                        if (max_width > 0 && ((cursor_x + mono_spacing) - text_x) > max_width)
                        {
                            is_multiline = true;
                        }
                        cursor_x += mono_spacing;
                    }
                    current_word = "";
                    if (_char == " ")
                    {
                        cursor_x += mono_spacing;
                    }
                    else if (_char == "\n")
                    {
                        is_multiline = true;
                    }
                }
            }
            dmenu_box = is_multiline ? 1 : 0;
            dbutton_layout = 3;
            break;
        case "warp":
            dmenu_title = dstr("Room List", "Liste des salles");
            dbutton_options = [dstr("Current Room", "Salle actuelle"), dstr("Search", "Recherche")];
            dbutton_indices = [-1, -1];
            if (global.dreading_custom_flag || dkeyboard_input != "")
            {
                dbutton_options[1] = dstr("Contains: ", "Contient : ");
            }
            else
            {
                dbutton_options[1] = dstr("Search", "Recherche");
            }
            dbutton_options[1] += dkeyboard_input;
            for (var i = 0; i < array_length(drooms); i++)
            {
                if (!string_pos(dkeyboard_input, drooms[i]))
                {
                    continue;
                }
                var combined = drooms[i];
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, drooms_id[i].room_index);
            }
            dbutton_layout = 1;
            dmenu_box = 1;
            break;
        case "warp_options":
            dmenu_title = dstr("Warp Options", "Options du saut");
            dbutton_options = [dstr("Cancel", "Annuler"), dstr("Is Darkworld: ", "Est un Darkworld : "), dstr("Plot Value: ", "Valeur de plot : "), dstr("Teammate 2:  ", "Équipier 2 :  "), dstr("Teammate 3:  ", "Équipier 3 :  "), dstr("Warp", "Sauter")];
            dbutton_indices = [0, 1, 2, 3, 4, 5];
            dbutton_options[1] += drooms_options.target_is_darkzone ? dstr("Yes", "Oui") : dstr("No", "Non");
            if (global.dreading_custom_flag)
            {
                dbutton_options[2] += dkeyboard_input;
            }
            else
            {
                dbutton_options[2] += string(drooms_options.target_plot);
            }
            teammates = [dstr("Nobody", "Personne"), "Kris", "Susie", "Ralsei", "Noëlle"];
            dbutton_options[3] += teammates[drooms_options.target_member_2];
            dbutton_options[4] += teammates[drooms_options.target_member_3];
            break;
        case "give":
            dmenu_title = dstr("Item Type", "Type d'items");
            dbutton_options_2d = [[dstr("Items", "Objets"), dstr("Armors", "Armures"), dstr("Weapons", "Armes"), dstr("Key Items", "Obj Clés")]];
            dmenu_box = 0;
            dbutton_layout = 0;
            break;
        case "objects":
            dmenu_title = dstr("Item List", "Liste d'objets");
            dbutton_options = [dstr("Chapter: ", "Chapitre : ")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = ditem_index_data(ditem_chap);
            if (dhorizontal_page == 0)
            {
                for (var r = 0; r < array_length(_ranges); r++)
                {
                    var my_start = _ranges[r].start_id;
                    var my_count = _ranges[r].count;
                    for (var i = my_start; i < (my_start + my_count); i++)
                    {
                        scr_iteminfo(i);
                        var cleaned_desc = string_replace_all(itemdescb, "#", " ");
                        var combined = itemnameb;
                        if (string_length(combined) > max_len)
                        {
                            combined = string_copy(combined, 1, max_len - 3) + "...";
                        }
                        array_push(dbutton_options, combined);
                        array_push(dbutton_indices, i);
                    }
                }
            }
            else
            {
                array_delete(dbutton_options, 0, 1);
                array_delete(dbutton_indices, 0, 1);
                for (var i = 0; i < array_length(dlight_objects); i++)
                {
                    scr_litemcheck(dlight_objects[i][0]);
                    var combined = dlight_objects[i][1] + " - " + string(itemcount) + " " + dstr("held", "possédé(s)");
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, dlight_objects[i][0]);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case "armors":
            dmenu_title = dstr("Armor List", "Liste d'armures");
            dbutton_options = [dstr("Chapter: ", "Chapitre : ")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = darmor_index_data(ditem_chap);
            if (dhorizontal_page == 0)
            {
                for (var r = 0; r < array_length(_ranges); r++)
                {
                    var my_start = _ranges[r].start_id;
                    var my_count = _ranges[r].count;
                    for (var i = my_start; i < (my_start + my_count); i++)
                    {
                        scr_armorinfo(i);
                        var cleaned_desc = string_replace_all(armordesctemp, "#", " ");
                        var combined = armornametemp;
                        if (string_length(combined) > max_len)
                        {
                            combined = string_copy(combined, 1, max_len - 3) + "...";
                        }
                        array_push(dbutton_options, combined);
                        array_push(dbutton_indices, i);
                    }
                }
            }
            else
            {
                array_delete(dbutton_options, 0, 1);
                array_delete(dbutton_indices, 0, 1);
                for (var i = 0; i < array_length(dlight_armors); i++)
                {
                    var combined = dlight_armors[i][1];
                    if (global.larmor == dlight_armors[i][0])
                    {
                        combined += (" (" + dstr("Equipped", "Équipé") + ")");
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case "weapons":
            dmenu_title = dstr("Weapon List", "Liste d'armes");
            dbutton_options = [dstr("Chapter: ", "Chapitre : ")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = dweapon_index_data(ditem_chap);
            if (dhorizontal_page == 0)
            {
                for (var r = 0; r < array_length(_ranges); r++)
                {
                    var my_start = _ranges[r].start_id;
                    var my_count = _ranges[r].count;
                    for (var i = my_start; i < (my_start + my_count); i++)
                    {
                        scr_weaponinfo(i);
                        var cleaned_desc = string_replace_all(weapondesctemp, "#", " ");
                        var combined = weaponnametemp;
                        if (string_length(combined) > max_len)
                        {
                            combined = string_copy(combined, 1, max_len - 3) + "...";
                        }
                        array_push(dbutton_options, combined);
                        array_push(dbutton_indices, i);
                    }
                }
            }
            else
            {
                array_delete(dbutton_options, 0, 1);
                array_delete(dbutton_indices, 0, 1);
                for (var i = 0; i < array_length(dlight_weapons); i++)
                {
                    var combined = dlight_weapons[i][1];
                    if (global.lweapon == dlight_weapons[i][0])
                    {
                        combined += (" (" + dstr("Equipped", "Équipé") + ")");
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case "keyitems":
            dmenu_title = dstr("Key Item List", "Liste d'objets clés");
            dbutton_options = [dstr("Chapter: ", "Chapitre : ")];
            dbutton_indices = [-1];
            dbutton_options[0] += string(ditem_chap);
            var max_len = 33;
            var _ranges = dkeyitem_index_data(ditem_chap);
            for (var r = 0; r < array_length(_ranges); r++)
            {
                var my_start = _ranges[r].start_id;
                var my_count = _ranges[r].count;
                for (var i = my_start; i < (my_start + my_count); i++)
                {
                    scr_keyiteminfo(i);
                    var cleaned_desc = string_replace_all(tempkeyitemdesc, "#", " ");
                    var combined = tempkeyitemname;
                    if (string_length(combined) > max_len)
                    {
                        combined = string_copy(combined, 1, max_len - 3) + "...";
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, i);
                }
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case "givertab":
            dmenu_title = dstr("Add how many to inventory?", "Ajouter combien à l'inventaire ?");
            dgiver_amount = 1;
            dmenu_box = 0;
            dbutton_layout = 2;
            break;
        case "recruits":
            dmenu_title = dstr("Recruit List", "Liste des recrues");
            dbutton_options = [dstr("Presets", "Préréglages")];
            dbutton_indices = [dstr("Presets", "Préréglages")];
            var max_len = 40;
            if (dhorizontal_page != 0)
            {
                dbutton_options[0] = " " + dbutton_options[0];
                dbutton_indices[0] = " " + dbutton_indices[0];
            }
            if (dhorizontal_page != 0)
            {
                var test_lst = scr_get_chapter_recruit_data(dhorizontal_page);
                for (var i = 0; i < array_length(test_lst); i++)
                {
                    var enemy_id = test_lst[i];
                    scr_recruit_info(enemy_id);
                    var combined = _name + " - [" + string(max(floor(global.flag[enemy_id + 600] * _recruitcount), -1)) + "/" + string(_recruitcount) + "]";
                    if (string_length(combined) > max_len)
                    {
                        combined = string_copy(combined, 1, max_len - 3) + "...";
                    }
                    array_push(dbutton_options, combined);
                    array_push(dbutton_indices, enemy_id);
                }
            }
            if (dhorizontal_page != 0)
            {
                dmenu_box = 1;
            }
            else
            {
                dmenu_box = 0;
            }
            dbutton_layout = 1;
            break;
        case "recruit_presets":
            dmenu_title = dstr("Recruit Presets", "Préréglages des recrues");
            dbutton_options = [dstr("Recruit All", "Recruter tous"), dstr("Lose All", "Perdre tous")];
            if (dhorizontal_page)
            {
                dmenu_title += (" (" + dstr("chap") + " " + string(dhorizontal_page) + ")");
                dbutton_options[0] += " " + dstr("of chapter", "du chapitre") + " " + string(dhorizontal_page);
                dbutton_options[1] += " " + dstr("of chapter", "du chapitre") + " " + string(dhorizontal_page);
            }
            dmenu_box = 0;
            dbutton_layout = 1;
            break;
        case "flag_categories":
            dmenu_title = dstr("Flags");
            dbutton_options = [];
            dbutton_indices = [-1];
            categories_len = array_length(dother_categories);
            var max_len = 40;
            if (!global.dreading_custom_flag)
            {
                array_push(dbutton_options, dstr("Custom"));
            }
            else
            {
                array_push(dbutton_options, "global.flag[" + dcustom_flag_text[0] + "] = |" + dcustom_flag_text[1] + "|");
            }
            for (var i = 0; i < categories_len; i++)
            {
                if (dflag_categories_len[i] == 0)
                {
                    continue;
                }
                array_push(dbutton_options, dother_categories[i]);
                array_push(dbutton_indices, i);
            }
            dmenu_box = 1;
            dbutton_layout = 1;
            break;
        case "flag_misc":
            dmenu_title = dstr("Flags");
            dbutton_options = [];
            dbutton_indices = [];
            other_len = array_length(dother_options);
            var max_len = 40;
            for (var i = 0; i < other_len; i++)
            {
                cur_option = dother_options[i];
                flag_number = global.flag[cur_option[2]];
                var combined = cur_option[1] + " - " + dstr("problem lol", "problème lol");
                if (i == dvertical_index)
                {
                    option_index = dhorizontal_index;
                }
                else
                {
                    option_index = find_subarray_index(cur_option[2], cur_option[3]);
                }
                combined = cur_option[1] + " -  " + cur_option[3][option_index][0];
                if (string_length(combined) > max_len)
                {
                    combined = string_copy(combined, 1, max_len - 3) + "...";
                }
                array_push(dbutton_options, combined);
                array_push(dbutton_indices, i);
            }
            dmenu_box = 2;
            dbutton_layout = 1;
            break;
        case "globals_changer":
            dmenu_title = dstr("Global changer", "Changeur de global");
            dbutton_options = [];
            dmenu_box = 1;
            dbutton_layout = 1;
            reading_double_flag = dvertical_index == 0 && global.dreading_custom_flag;
            for (var i = 0; i < array_length(dglobal_changer_options); i++)
            {
                array_push(dbutton_indices, i);
                name = dglobal_changer_options[i][0];
                limit = dglobal_changer_options[i][2];
                if (i == 0 && reading_double_flag)
                {
                    name = dcustom_flag_text[0];
                    is_good = parse_var_str(name, 0);
                    if (is_good)
                    {
                        name = dtemp_text;
                        limit = dtemp_num;
                    }
                }
                text = name;
                if (i == 0 && reading_double_flag)
                {
                    text = "global." + name;
                }
                cur_global_value = "";
                var_exist = variable_global_exists(name);
                if (var_exist)
                {
                    cur_global_value = variable_global_get(name);
                }
                if (limit != -1)
                {
                    lookup_index = 0;
                    if (i == dvertical_index && i == 0)
                    {
                        lookup_index = limit;
                    }
                    else if (i == dvertical_index)
                    {
                        lookup_index = dhorizontal_index;
                    }
                    text += ("[" + string(lookup_index) + "]");
                    if (typeof(cur_global_value) != "array")
                    {
                        cur_global_value = dstr("(Not an array)", "(Pas une array)");
                    }
                    else if (lookup_index >= array_length(cur_global_value))
                    {
                        cur_global_value = dstr("(Index too high)", "(Index trop élevé)");
                    }
                    else
                    {
                        cur_global_value = cur_global_value[lookup_index];
                    }
                }
                if (global.dreading_custom_flag && i == dvertical_index)
                {
                    if (i != 0 || dcustom_flag_text[1] != "" || !var_exist)
                    {
                        cur_global_value = dcustom_flag_text[reading_double_flag];
                    }
                }
                if (!(i == 0 && dvertical_index == 0 && !global.dreading_custom_flag))
                {
                    text += (" = |" + string(cur_global_value) + "|");
                }
                array_push(dbutton_options, text);
            }
            break;
        default:
            dmenu_box = 0;
            dbutton_layout = 0;
            dbutton_options = [];
    }
}

function dmenu_state_interact()
{
    selected_name = "";
    if (dbutton_layout == 0 || dbutton_layout == 3)
    {
        var safe_h_index = min(dhorizontal_index, array_length(dbutton_options_2d[dvertical_index]) - 1);
        selected_name = string(dbutton_options_2d[dvertical_index][safe_h_index]);
    }
    else
    {
        selected_name = string(dbutton_options[dvertical_index]);
    }
    switch (dmenu_state)
    {
        case "debug":
            dvertical_index = 0;
            if (selected_name == dstr("Warps", "Sauts"))
            {
                drooms_id = scr_get_room_list();
                drooms = [];
                for (var i = 0; i < array_length(drooms_id); i++)
                {
                    array_push(drooms, room_get_name(drooms_id[i].room_index));
                }
                dmenu_state = "warp";
                dhorizontal_index = 0;
                dkeyboard_input = "";
                drooms_options.target_plot = global.plot;
                drooms_options.target_is_darkzone = global.darkzone;
            }
            else if (selected_name == dstr("Items"))
            {
                dmenu_state = "give";
            }
            else if (selected_name == dstr("Recruits", "Recrues"))
            {
                dmenu_state = "recruits";
                dhorizontal_page = 0;
            }
            else if (selected_name == dstr("Flags"))
            {
                dmenu_state = "flag_categories";
            }
            else if (selected_name == "Globals")
            {
                dmenu_state = "globals_changer";
            }
            else if (selected_name == "Debug save")
            {
                scr_get_debug_save_list();
                dmenu_state = "debug_save";
            }
            else if (selected_name == "Game Obj")
            {
                var obj_list = [];
                with (all)
                {
                    var _name = object_get_name(object_index);
                    if (!scr_array_contains(other.obj_list, _name))
                    {
                        array_push(other.obj_list, _name);
                    }
                }
                dmenu_state = "obj_handler";
            }
            break;
        case "obj_handler":
            if (dvertical_index == 0)
            {
                dmenu_state = "obj_create";
                global.dreading_custom_flag = 1;
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state_update();
            }
            else if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state_update();
            }
            break;
        case "obj_create":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            if (dvertical_index == 0)
            {
                global.dreading_custom_flag = 1;
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state_update();
            }
            else
            {
                global.flag[7] = 1;
                instance_create(0, 0, obj_dmode_xy);
                var obj_id = asset_get_index(string(dbutton_indices[dvertical_index]));
                var obj_new = instance_create(obj_mainchara.x, obj_mainchara.y, obj_id);

                with (obj_dmode_xy)
                    sel_obj = obj_new;

                dpop_history();
                dmenu_active = false;
            }
            break;
        case "debug_save":
            if (dvertical_index == 0)
            {
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state = "new_debug_save";
                break;
            }
            if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state_update();
                break;
            }
            if (dmenu_interact_submenus(selected_name))
            {
                break;
            }
            var real_index = dbutton_indices[dvertical_index];
            if (real_index >= 0)
            {
                global.debug_selected_save_section = debug_save_sections[real_index];
                global.debug_selected_save_name = debug_save_names[real_index];
                dmenu_state = "debug_save_options";
                dmenu_state_update();
            }
            break;
        case "debug_save_options":
            var check_name = selected_name;
            if (string_ends_with(check_name, " v") || string_ends_with(check_name, " ^"))
            {
                check_name = string_copy(check_name, 1, string_length(check_name) - 2);
            }
            if (dmenu_interact_submenus(selected_name))
            {
                break;
            }
            var target_sec = global.debug_selected_save_section;
            var target_name = global.debug_selected_save_name;
            if (check_name == dstr("Save", "Sauver"))
            {
                var target_path = global.debug_selected_save_section;
                global.debug_save_category = "";
                global.debug_save_name = target_name;
                global.debug_save_description = dstr("No description available.", "Aucune description disponible.");
                if (file_exists(target_path))
                {
                    var file_id = file_text_open_read(target_path);
                    var file_content = "";
                    while (!file_text_eof(file_id))
                    {
                        file_content += file_text_read_string(file_id);
                        file_text_readln(file_id);
                    }
                    file_text_close(file_id);
                    try
                    {
                        var parsed_struct = json_parse(file_content);
                        if (is_struct(parsed_struct) && variable_struct_exists(parsed_struct, "metadata"))
                        {
                            var meta = parsed_struct.metadata;
                            if (variable_struct_exists(meta, "Category"))
                            {
                                global.debug_save_category = meta.Category;
                            }
                            if (variable_struct_exists(meta, "Description"))
                            {
                                global.debug_save_description = meta.Description;
                            }
                        }
                    }
                    catch (e)
                    {
                    }
                }
                global.debug_overwrite_section = target_path;
                global.debug_saving = 1;
                dmenu_popup_launch = 0;
                dmenu_state = "debug";
                dbutton_options = dbutton_options_original;
                dmenu_state_history = [];
                dmenu_vertical_index_history = [];
                dvertical_index = 0;
                dbutton_layout = 0;
                dmenu_active = false;
                dkeyboard_input = "";
                global.interact = 0;
                scr_debug_save();
                scr_debug_print(dstr("Overwrote save: ", "Sauvegarde écrasée : ") + target_name);
                snd_play(snd_save);
            }
            else if (string_copy(check_name, 1, (global.dlang == "en") ? 4 : 7) == dstr("Load", "Charger"))
            {
                var target_path = global.debug_selected_save_section;
                if (file_exists(target_path))
                {
                    dmenu_popup_launch = 0;
                    dmenu_state = "debug";
                    dbutton_options = dbutton_options_original;
                    dmenu_state_history = [];
                    dmenu_vertical_index_history = [];
                    dvertical_index = 0;
                    dbutton_layout = 0;
                    dmenu_active = false;
                    dkeyboard_input = "";
                    global.interact = 0;
                    scr_debug_load(target_path);
                }
                else
                {
                    snd_play(snd_error);
                    scr_debug_print(dstr("Error: Save file '", "Erreur : Le fichier de sauvegarde '") + target_name + dstr("' could not be found on disk", "' n'a pu être trouvé"));
                }
            }
            else if (check_name == dstr("Delete", "Supprimer"))
            {
                dremove_false_history();
                var target_path = global.debug_selected_save_section;
                if (file_exists(target_path))
                {
                    file_delete(target_path);
                    scr_debug_cleanup_folder(target_path);
                    scr_debug_print(dstr("Save file permanently deleted", "Fichier de sauvegarde supprimé"));
                    snd_play(snd_badexplosion);
                    scr_get_debug_save_list();
                }
                else
                {
                    scr_debug_print(dstr("Error: File already missing", "Erreur : Fichier déjà manquant"));
                }
                dpop_history();
                dvertical_index = 0;
                dbutton_layout = 0;
                dmenu_start_index = 0;
            }
            else if (check_name == ("- " + dstr("Debug mode save", "Sauvegarde mode debug")))
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                var source_file = global.debug_selected_save_section;
                target_name = global.debug_selected_save_name;
                var export_path = get_save_filename("Debug save (*.save)|*.save", string(target_name) + ".save");
                if (export_path != "")
                {
                    if (file_exists(source_file))
                    {
                        if (file_exists(export_path))
                        {
                            file_delete(export_path);
                        }
                        file_copy(source_file, export_path);
                        scr_debug_print(dstr("Exported custom .save successfully!", "Fichier .save exporté avec succès !"));
                        snd_play(snd_shineselect);
                    }
                    else
                    {
                        scr_debug_print(dstr("Error: Base save file not found", "Erreur : Fichier de sauvegarde de base introuvable"));
                        snd_play(snd_error);
                    }
                }
            }
            else if (check_name == ("- " + dstr("Default Deltarune save", "Sauvegarde Deltarune par défaut")))
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                var source_file = global.debug_selected_save_section;
                target_name = global.debug_selected_save_name;
                if (file_exists(source_file) || ossafe_file_exists(source_file))
                {
                    var _route_suffix = "";
                    if (variable_global_exists("filechoice_route"))
                    {
                        _route_suffix = string(global.filechoice_route);
                    }
                    var suggested_name = "filech" + string(global.chapter) + "_0" + _route_suffix;
                    var export_path = get_save_filename("Deltarune Save|*", suggested_name);
                    if (export_path != "")
                    {
                        if (file_exists(export_path))
                        {
                            file_delete(export_path);
                        }
                        if (string_copy(source_file, string_length(source_file) - 4, 5) == ".save")
                        {
                            var file_id = file_text_open_read(source_file);
                            var json_string = "";
                            while (!file_text_eof(file_id))
                            {
                                json_string += file_text_read_string(file_id);
                                file_text_readln(file_id);
                                if (!file_text_eof(file_id))
                                {
                                    json_string += "\n";
                                }
                            }
                            file_text_close(file_id);
                            var parsed_data = -1;
                            try
                            {
                                parsed_data = json_parse(json_string);
                            }
                            catch (e)
                            {
                            }
                            if (is_struct(parsed_data) && variable_struct_exists(parsed_data, "save_file"))
                            {
                                var raw_content = parsed_data.save_file;
                                var out_file = file_text_open_write(export_path);
                                file_text_write_string(out_file, raw_content);
                                file_text_close(out_file);
                            }
                            else
                            {
                                file_copy(source_file, export_path);
                            }
                        }
                        else
                        {
                            file_copy(source_file, export_path);
                        }
                        scr_debug_print("'" + string(target_name) + "' exporté avec succès !");
                        snd_play(snd_shineselect);
                    }
                    else
                    {
                        scr_debug_print(dstr("Export cancelled", "Exportation annulée"));
                    }
                }
                else
                {
                    scr_debug_print(dstr("Error: Could not find the source save file", "Erreur : Impossible de trouver le fichier de sauvegarde source"));
                    snd_play(snd_error);
                }
            }
            else if (check_name == ("- " + dstr("Rename", "Renommer")) || check_name == ("- " + dstr("Edit description", "Modifier description")) || check_name == ("- " + dstr("Change category", "Changer description")))
            {
                if (check_name == ("- " + dstr("Rename", "Renommer")))
                {
                    dmenu_state = "dsave_edit_name";
                    keyboard_string = "";
                    dkeyboard_input = "";
                }
                if (check_name == ("- " + dstr("Edit description", "Modifier description")))
                {
                    dmenu_state = "dsave_edit_desc";
                    keyboard_string = "";
                    dkeyboard_input = "";
                }
                if (check_name == ("- " + dstr("Change category", "Changer description")))
                {
                    dmenu_state = "dsave_edit_cat";
                    keyboard_string = "";
                    dkeyboard_input = "";
                }
            }
            break;
        case "dsave_edit_name":
        case "dsave_edit_desc":
        case "dsave_edit_cat":
            if (dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state_update();
            }
            else if (dvertical_index == 1 && dhorizontal_index == 0)
            {
                dremove_false_history();
                var target_sec = global.debug_selected_save_section;
                var final_text = dkeyboard_input;
                var ini_key = "";
                if (dmenu_state == "dsave_edit_name")
                {
                    ini_key = "SaveName";
                }
                else if (dmenu_state == "dsave_edit_desc")
                {
                    ini_key = "Description";
                }
                else if (dmenu_state == "dsave_edit_cat")
                {
                    ini_key = "Category";
                }
                var new_path = scr_debug_save_modify_info(target_sec, ini_key, final_text);
                if (ini_key == "SaveName" && final_text != "")
                {
                    global.debug_selected_save_name = final_text;
                }
                if (new_path != "")
                {
                    global.debug_selected_save_section = new_path;
                }
                global.dreading_custom_flag = 0;
                dkeyboard_input = "";
                scr_get_debug_save_list();
                dpop_history();
            }
            else
            {
                dremove_false_history();
                global.dreading_custom_flag = 0;
                dkeyboard_input = "";
                dpop_history();
            }
            break;
        case "new_debug_save":
            if (dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state_update();
            }
            else if (dvertical_index == 1 && dhorizontal_index == 0)
            {
                if (dkeyboard_input != "")
                {
                    global.debug_save_name = dkeyboard_input;
                }
                else
                {
                    global.debug_save_name = dstr("Untitled", "Sans titre");
                }
                dkeyboard_input = "";
                scr_debug_print(dstr("Save created: ", "Sauvegarde créée : ") + string(global.debug_save_name));
                global.debug_saving = 1;
                scr_debug_save();
                dmenu_popup_launch = 0;
                dmenu_state = "debug";
                dbutton_layout = 0;
                dbutton_options = dbutton_options_original;
                dmenu_state_history = [];
                dmenu_vertical_index_history = [];
                dvertical_index = 0;
                dmenu_active = false;
                global.interact = 0;
                snd_play(snd_save);
            }
            else
            {
                dkeyboard_input = "";
                dmenu_popup_launch = 0;
                dmenu_state = "debug";
                dbutton_layout = 0;
                dbutton_options = dbutton_options_original;
                dmenu_state_history = [];
                dmenu_vertical_index_history = [];
                dvertical_index = 0;
                dmenu_active = false;
                global.interact = 0;
            }
            break;
        case "warp":
            if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                keyboard_string = "";
                dkeyboard_input = "";
                dmenu_state_update();
            }
            else
            {
                drooms_options.target_room = -1;
                if (dvertical_index != 0)
                {
                    drooms_options.target_room = dbutton_indices[dvertical_index];
                }
                drooms_options.target_plot = global.plot;
                drooms_options.target_is_darkzone = global.darkzone;
                drooms_options.target_member_2 = global.char[1];
                drooms_options.target_member_3 = global.char[2];
                dmenu_state = "warp_options";
                dkeyboard_input = "";
            }
            break;
        case "warp_options":
            if (dvertical_index == 0)
            {
                dkeyboard_input = "";
                dmenu_state = "warp";
            }
            else if (dvertical_index == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                drooms_options.target_is_darkzone ^= 1;
            }
            else if (dvertical_index >= 2 && dvertical_index <= 4)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                if (dvertical_index == 2)
                {
                    global.dreading_custom_flag = 1;
                    keyboard_string = "";
                }
            }
            else if (dvertical_index == 5)
            {
                new_room = drooms_options.target_room;
                if (new_room == -1)
                {
                    new_room = room;
                }
                global.plot = drooms_options.target_plot;
                global.darkzone = drooms_options.target_is_darkzone;
                global.char[1] = drooms_options.target_member_2;
                global.char[2] = drooms_options.target_member_3;
                global.interact = 0;
                dmenu_active = false;
                room_goto(new_room);
            }
            break;
        case "give":
            if (dhorizontal_index == 0)
            {
                dmenu_state = "objects";
            }
            else if (dhorizontal_index == 1)
            {
                dmenu_state = "armors";
            }
            else if (dhorizontal_index == 2)
            {
                dmenu_state = "weapons";
            }
            else if (dhorizontal_index == 3)
            {
                dmenu_state = "keyitems";
            }
            dhorizontal_page = !global.darkzone;
            if (dhorizontal_index == 3)
            {
                dhorizontal_page = 0;
            }
            dvertical_index = 0;
            dhorizontal_index = 0;
            break;
        case "objects":
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dvertical_index = clamp(dvertical_index, 0, array_length(dbutton_options));
                dgiver_button_selected = dvertical_index;
                dmenu_state = "givertab";
                dvertical_index = 0;
            }
            break;
        case "armors":
            if (dhorizontal_page == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.larmor = dlight_armors[dvertical_index][0];
                break;
            }
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dgiver_button_selected = dvertical_index;
                dmenu_state = "givertab";
                dvertical_index = 0;
            }
            break;
        case "weapons":
            if (dhorizontal_page == 1)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.lweapon = dlight_weapons[dvertical_index][0];
                break;
            }
            if (dhorizontal_page == 0 && dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dgiver_button_selected = dvertical_index;
                dmenu_state = "givertab";
                dvertical_index = 0;
            }
            break;
        case "keyitems":
            if (dvertical_index == 0)
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                ditem_chap += 1;
                if (ditem_chap > global.chapter)
                {
                    ditem_chap = 1;
                }
            }
            else
            {
                dgiver_menu_state = dmenu_state;
                dgiver_button_selected = dvertical_index;
                dmenu_state = "givertab";
                dvertical_index = 0;
            }
            break;
        case "givertab":
            dremove_false_history();
            if (dgiver_amount == 0)
            {
                scr_debug_print(dstr("Cancelled", "Annulé"));
                break;
            }
            if (dgiver_menu_state == "objects")
            {
                var real_index = dbutton_indices[dgiver_button_selected];
                for (var i = 0; i < abs(dgiver_amount); i++)
                {
                    if (dgiver_amount < 0)
                    {
                        if (dhorizontal_page == 0)
                        {
                            scr_itemremove(real_index);
                        }
                        else
                        {
                            scr_litemremove(real_index);
                        }
                    }
                    else if (dhorizontal_page == 0)
                    {
                        scr_itemget(real_index);
                    }
                    else
                    {
                        scr_litemget(real_index);
                    }
                }
                if (dgiver_amount < 0)
                {
                    scr_debug_print(string(abs(dgiver_amount)) + " " + dgiver_bname + dstr(" removed from inventory", " retiré de l'inventaire"));
                }
                else
                {
                    scr_debug_print(string(dgiver_amount) + " " + dgiver_bname + dstr(" added to inventory", " ajouté à l'inventaire"));
                }
            }
            if (dgiver_menu_state == "armors")
            {
                if (dgiver_amount > 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < dgiver_amount; i++)
                    {
                        scr_armorget(real_index);
                    }
                    scr_debug_print(string(dgiver_amount) + " " + dgiver_bname + dstr(" added to inventory", " ajouté à l'inventaire"));
                }
                else if (dgiver_amount < 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < abs(dgiver_amount); i++)
                    {
                        scr_armorremove(real_index);
                    }
                    scr_debug_print(string(abs(dgiver_amount)) + " " + dgiver_bname + dstr(" removed from inventory", " retiré de l'inventaire"));
                }
            }
            if (dgiver_menu_state == "weapons")
            {
                if (dgiver_amount > 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < dgiver_amount; i++)
                    {
                        scr_weaponget(real_index);
                    }
                    scr_debug_print(string(dgiver_amount) + " " + dgiver_bname + dstr(" added to inventory", " ajouté à l'inventaire"));
                }
                else if (dgiver_amount < 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < abs(dgiver_amount); i++)
                    {
                        scr_weaponremove(real_index);
                    }
                    scr_debug_print(string(abs(dgiver_amount)) + " " + dgiver_bname + dstr(" removed from inventory", " retiré de l'inventaire"));
                }
            }
            if (dgiver_menu_state == "keyitems")
            {
                if (dgiver_amount > 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < dgiver_amount; i++)
                    {
                        scr_keyitemget(real_index);
                    }
                    scr_debug_print(string(dgiver_amount) + " " + dgiver_bname + dstr(" added to inventory", " ajouté à l'inventaire"));
                }
                else if (dgiver_amount < 0)
                {
                    var real_index = dbutton_indices[dgiver_button_selected];
                    for (var i = 0; i < abs(dgiver_amount); i++)
                    {
                        scr_keyitemremove(real_index);
                    }
                    scr_debug_print(string(abs(dgiver_amount)) + " " + dgiver_bname + dstr(" removed from inventory", " retiré de l'inventaire"));
                }
            }
            dpop_history();
            dmenu_active = false;
            global.interact = 0;
            break;
        case "flag_categories":
            if (dvertical_index > 0)
            {
                dother_options = [];
                var real_index = dbutton_indices[dvertical_index];
                for (var i = 0; i < array_length(dother_all_options); i++)
                {
                    options = dother_all_options[i];
                    if (options[0] == real_index)
                    {
                        array_push(dother_options, options);
                    }
                }
                dmenu_skip_reindexing = true;
                dmenu_state = "flag_misc";
                dmenu_start_index = 0;
                dvertical_index = 0;
                dhorizontal_index = find_subarray_index(dother_options[0][2], dother_options[0][3]);
            }
            else
            {
                dremove_false_history();
                dmenu_skip_reindexing = true;
                global.dreading_custom_flag = 1;
                dhorizontal_index = 0;
                keyboard_string = "";
            }
            break;
        case "flag_misc":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            break;
        case "recruits":
            dremove_false_history();
            if (dvertical_index != 0)
            {
                dmenu_skip_reindexing = true;
            }
            if (dvertical_index == 0)
            {
                dmenu_state = "recruit_presets";
            }
            break;
        case "recruit_presets":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            for (var c = 1; c <= global.chapter; c++)
            {
                if (dhorizontal_page != 0)
                {
                    c = dhorizontal_page;
                }
                var test_lst = scr_get_chapter_recruit_data(c);
                for (var i = 0; i < array_length(test_lst); i++)
                {
                    var enemy_id = test_lst[i];
                    scr_recruit_info(enemy_id);
                    if (dvertical_index == 0)
                    {
                        global.flag[enemy_id + 600] = 1;
                    }
                    else
                    {
                        global.flag[enemy_id + 600] = -1;
                    }
                }
                if (dhorizontal_page != 0)
                {
                    break;
                }
            }
            if (dvertical_index == 0)
            {
                snd_play(snd_pirouette);
            }
            else
            {
                snd_play(snd_weirdeffect);
            }
            dpop_history();
            break;
        case "globals_changer":
            dremove_false_history();
            dmenu_skip_reindexing = true;
            if (global.dreading_custom_flag)
            {
                var value = 0;
                cur_global_array = dglobal_changer_options[dvertical_index];
                reading_double_flag = dvertical_index == 0;
                glob_name = cur_global_array[0];
                glob_index = -1;
                if (reading_double_flag)
                {
                    parse_var_str(dcustom_flag_text[0], 1);
                    glob_name = dtemp_text;
                    glob_index = dtemp_num;
                }
                else if (cur_global_array[2] != -1)
                {
                    glob_index = dhorizontal_index;
                }
                scr_debug_print(string(cur_global_array));
                switch (cur_global_array[1])
                {
                    case "string":
                        value = string(dcustom_flag_text[reading_double_flag]);
                        break;
                    case "int":
                    case "uint":
                    case "real":
                        value = real(dcustom_flag_text[reading_double_flag]);
                        break;
                    default:
                        scr_debug_print("Unrecognized type |" + string(cur_global_array[1]) + "|");
                }
                if (glob_index != -1)
                {
                    base = variable_global_get(glob_name);
                    base[glob_index] = value;
                    value = base;
                }
                variable_global_set(glob_name, value);
                scr_debug_print("Changed global." + string(glob_name) + " to |" + string(value) + "|");
            }
            else if (dvertical_index == 0)
            {
                dhorizontal_index = 0;
            }
            set_keyboard_reader(global.dreading_custom_flag ^ 1);
            break;
        default:
            snd_play(snd_error);
            scr_debug_print(dstr("Invalid selection!", "Sélection invalide !"));
    }
}
