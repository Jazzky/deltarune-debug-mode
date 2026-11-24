function dmenu_state_update_fight_menu()
{
	dmenu_title = dstr("Fight maker", "Menu de Combat");
	dbuttons = [
		dmenu_makebt(dstr("Enemy list: ", "Liste des ennemis : "), "enemy_list"),
		dmenu_makebt(dstr("Add enemy", "Ajouter ennemi"), "add_enemy"),
		dmenu_makebt(dstr("Encounter ID: ", "ID de rencontre : ")),
		dmenu_makebt(dstr("Fight", "Combattre"), "fight")
	];

	if (dfight_menu.selected_enemy == -1)
		dfight_menu.selected_enemy = dfight_menu.nb_enemies - 1;

	var no_enemy_text = dstr("No enemy selected", "Aucun ennemi sélectionné");
	if (dfight_menu.nb_enemies == 0) {
		dbuttons[0].text += "|" + no_enemy_text + "|";
	}
	else {
		var lst_x = dfight_menu.selected_enemy;

		if (lst_x != 0)
			dbuttons[0].text += "</larrow/>";

		dbuttons[0].text += " |" + dfight_menu.enemies[lst_x].enemy_name + "|";

		if (lst_x != (dfight_menu.nb_enemies - 1))
			dbuttons[0].text += "</rarrow/>";

		dbuttons[0].xranges = [0, dfight_menu.nb_enemies - 1];
		if (dvertical_index == 0)
			dhorizontal_index = lst_x;
	}

	var encounter_text = string(dfight_menu.encounterno);
	var encounter_kb_text = dkeyboard_texts[0];
	if (dutils_reading_kb() || encounter_kb_text != "")
		encounter_text = encounter_kb_text;

	dbuttons[2].data = string_length(dbuttons[2].text);
	dbuttons[2].text += encounter_text;
	dmenu_set_bttype(dbuttons[2], "keyboard");

	if (!global.darkzone) {
		dbuttons[3].text = dstr("(Must be in a Darkworld)", "(Doit être dans un Monde d'Ombre)");
	}
	else if (dfight_menu.nb_enemies == 0) {
		dbuttons[3].text = "(" + no_enemy_text + ")";
	}
	
	dbutton_layout = 1;
	dmenu_box = 2;
}
