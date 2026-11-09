function dmenu_draw_key_helper()
{
    dkeys_data = [
		dstr("F10 - Toggle debug mode", "F10 - Activer/désactiver le debug mode"),
		dstr("S - Save game", "S - Sauvegarder la partie"),
		dstr("L - Load last save", "L - Charger la dernière sauvegarde"),
		dstr("R - Reload room | Backspace+R - Restart game", "R - Charger la salle | Retour arrière+R - Redémarrer le jeu"),
		dstr("M+1 | M+2 - Add/remove 100 D$", "M+1 | M+2 - Ajouter/retirer 100 D$"),
		dstr("Delete - Go to previous room", "Suppr - Se rendre à la salle précédente"),
		dstr("Insert - Go to next room", "Insert - Se rendre à la salle suivante"),
		dstr("G - Toggle godmode", "G - Activer/désactiver le godmode"),
		dstr("W - Skip battle | Shift+W - Skip battle with recruit", "W - Passer un combat | Shift+W - Passer un combat avec recrue"),
		dstr("V - Skip enemy turn", "V - Passer le tour de l'ennemi"),
		dstr("H - Restore party HP", "H - Restaurer les HP du party"),
		dstr("T - Fill/empty TP bar", "T - Remplir/vider la barre de TP"),
		dstr("P -Set game to 1 FPS | Alt+P - Disable/restore bubble dialog autoskip", "P - Mettre le jeu à 1 FPS | Alt+P - Désactiver l'autoskip des bulles de combat"),
		dstr("O - Toggle 30, 60, 120 FPS", "O - Basculer entre 30, 60 et 120 FPS"),
		dstr("Backspace - Skip intro sequence (Ch1)", "Retour arrière - Passer le segment d'intro (Ch1)"),
		dstr("Middle Click - Room Editor", "Clic milieu - Éditeur de salle")
	];
    
    menu_width = 264;
    menu_length = 204;
    xcenter = 160;
    ycenter = 120;
    x_padding = 14 * d;
    y_start = 50 * d;
    x_spacing = 10 * d;
    y_spacing = 10.5 * d;
    x_start = (((xcenter - (menu_width / 2))) * d) + x_padding;
    
    draw_set_color(c_white);
    draw_rectangle(((xcenter - (menu_width / 2) - 3) * d) + xx, ((ycenter - (menu_length / 2) - 3) * d) + yy, ((xcenter + (menu_width / 2) + 3) * d) + xx, ((ycenter + (menu_length / 2) + 3) * d) + yy, false);
    draw_set_color(c_black);
    draw_rectangle(((xcenter - (menu_width / 2)) * d) + xx, ((ycenter - (menu_length / 2)) * d) + yy, ((xcenter + (menu_width / 2)) * d) + xx, ((ycenter + (menu_length / 2)) * d) + yy, false);
    
    var text_scale = (global.darkzone == 1) ? 1 : 0.5;
    
    draw_set_font(fnt_mainbig);
    draw_set_halign(fa_right);
    draw_set_color(c_gray);
    var right_border = (xcenter + (menu_width / 2)) * d;
    var padding = 8 * d;
    var draw_x = (right_border + xx) - padding;
    var draw_y = (((ycenter - (menu_length / 2)) + 8) * d) + yy;
    
    draw_text_transformed(draw_x, draw_y, string(dstr("M - Close", "M - Fermer")), text_scale, text_scale, 0);
    
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    
    draw_text_transformed(x_start + xx, (((ycenter - (menu_length / 2)) + 8) * d) + yy, string(dstr("Debug Mode Keys", "Touches du debug mode")), text_scale, text_scale, 0);
    
    for (var i = 0; i < array_length(dkeys_data); i++)
    {
        draw_set_font(fnt_main);
        draw_set_color(c_white);
        
        draw_text_transformed(x_start + xx, y_start + yy + (i * y_spacing), string(dkeys_data[i]), text_scale, text_scale, 0);
    }
}
