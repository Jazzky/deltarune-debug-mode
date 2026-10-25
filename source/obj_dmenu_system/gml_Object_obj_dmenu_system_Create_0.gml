dmenu_active = false;
dmenu_popup_launch = 0;
dmenu_box = 0;
dbutton_layout = 0;
dmenu_start_index = 0;
dbutton_max_visible = 5;
dmenu_arrow_timer = 0;
dscroll_timer = 0;
dscroll_cur_key = 0;
dscroll_delay = 15;
dscroll_speed = 1;
dbackspace_timer = 0;
dmenu_title = dstr("Debug Menu", "Menu Debug");
dbutton_options_original = [[dstr("Warps", "Sauts"), dstr("Items"), dstr("Recruits", "Recrues"), dstr("Flags")], [dstr("Globals"), dstr("Debug save"), dstr("Game Obj")]];
dnumber_litems = [0, 11, 14, 14, 18, 23];
dlight_weapons = [];
dlight_armors = [[3, dstr("Bandage", "Pansement")], [14, dstr("Wristwatch", "Montre")]];
dlight_objects = [[1, dstr("Hot Chocolate", "Chocolat Chaud")], [2, dstr("Pencil", "Crayon")], [3, dstr("Bandage", "Pansement")], [4, dstr("Bouquet")], [5, dstr("Ball of Junk", "Boule de Trucs")], [6, dstr("Halloween Pencil", "Crayon Halloween")], [7, dstr("Lucky Pencil", "Crayon Fétiche")], [8, dstr("Egg", "Œuf")], [9, dstr("Cards", "Cartes")], [10, dstr("Box of Heart Candy", "Boîte de ChocoCœurs")], [11, dstr("Glass", "Verre")], [12, dstr("Eraser", "Gomme")], [13, dstr("Mech. Pencil", "Critérium")], [14, dstr("Wristwatch", "Montre")], [15, dstr("Holiday Pencil", "Crayon de Noël")], [16, dstr("CactusNeedle", "Épine de Cactus")], [17, dstr("BlackShard", "ÉclatNoir")], [18, dstr("QuillPen", "Stylo-Plume")], [19, dstr("Honey Toast", "Tartine de Miel")], [20, dstr("Bread", "Pain")], [21, dstr("Seeds", "Graines")], [22, dstr("Pencil2", "Crayon2")], [23, dstr("Petal", "Pétale")]];
dhinter_active = false;
itemdescb = "";
armordesctemp = "";
weapondesctemp = "";
tempkeyitemdesc = "";
dhinter_text = "";
global.dload_cur_inv = 0;
dtemp_text = "";
dtemp_num = 0;

if (global.chapter >= 4)
{
    dtemp_lst = get_lw_dw_weapon_list();
    
    for (i = 0; i < array_length(dtemp_lst); i++)
        array_push(dlight_weapons, dlight_objects[dtemp_lst[i].lw_id - 1]);
}
else
{
    dlight_weapons = [[2, dstr("Pencil", "Crayon")], [6, dstr("Halloween Pencil", "Crayon Halloween")], [7, dstr("Lucky Pencil", "Crayon Fétiche")], [12, dstr("Eraser", "Gomme")], [13, dstr("Mech. Pencil", "Critérium")]];
}

for (i = 0; i < array_length(dlight_objects); i++)
{
    if (dlight_objects[i][0] > dnumber_litems[global.chapter])
        array_delete(dlight_objects, i--, 1);
}

if (global.chapter == 1)
{
    array_delete(dlight_weapons, 3, 2);
    array_delete(dlight_armors, 1, 1);
    array_delete(dlight_objects, 8, 1);
    array_delete(dlight_objects, 8, 1);
}

if (global.chapter < 3)
    array_delete(dbutton_options_original[0], 2, 1);

dbutton_options = [];
dbutton_options_2d = dbutton_options_original;
dmenu_state = "debug";
dvertical_index = 0;
dhorizontal_page = 0;
dhorizontal_index = 0;
dmenu_state_history = [];
dmenu_vertical_index_history = [];
dmenu_horizontal_index_history = [];
dmenu_page_index_history = [];
dgiver_menu_state = 0;
dgiver_button_selected = 0;
dgiver_amount = 1;
dgiver_bname = 0;
dbutton_indices = [];
ditem_types = ["objects", "armors", "weapons", "keyitems"];
ditem_chap = global.chapter;

global.ditem_data = [
    [],
    [ { start_id: 1,  count: 15 } ],
    [ { start_id: 16, count: 18 } ],
    [ { start_id: 34, count: 6  } ],
    [ { start_id: 60, count: 4  } ],
    [ { start_id: 40, count: 4  }, { start_id: 64, count: 7 } ]
];

global.darmor_data = [
    [],
    [ { start_id: 1,  count: 7 } ],
    [ { start_id: 8, count: 15 } ],
    [ { start_id: 23, count: 5  } ],
    [ { start_id: 50, count: 5  } ],
    [ { start_id: 30, count: 9  }]
];

global.dweapon_data = [
    [],
    [ { start_id: 1,  count: 10 } ],
    [ { start_id: 11, count: 12 } ],
    [ { start_id: 23, count: 4  } ],
    [ { start_id: 50, count: 5  } ],
    [ { start_id: 30, count: 8  }]
];

global.dkeyitem_data = [
    [],
    [ { start_id: 1,  count: 7 } ],
    [ { start_id: 8, count: 8 } ],
    [ { start_id: 16, count: 4  } ],
    [ { start_id: 30, count: 2  } ],
    [ { start_id: 20, count: 10  }, { start_id: 32, count: 2} ]
];

dpop_history = function()
{
    dmenu_skip_reindexing = true;
    dkeyboard_input = "";
    
    if (array_length(dmenu_state_history) > 0)
    {
        dmenu_state = array_pop(dmenu_state_history);
    }
    else
    {
        if (!(dmenu_popup_launch == 1 && dmenu_state == "debug_save"))
            global.interact = 0;
        
        dmenu_popup_launch = 0;
        dmenu_active = !dmenu_active;
        dmenu_state = "debug";
        dbutton_options = dbutton_options_original;
        dmenu_state_history = [];
        dmenu_vertical_index_history = [];
        dmenu_horizontal_index_history = [];
        dmenu_page_index_history = [];
        dvertical_index = 0;
        dmenu_state_update();
    }
    
    if (array_length(dmenu_vertical_index_history) > 0)
        dvertical_index = array_pop(dmenu_vertical_index_history);
    
    if (array_length(dmenu_horizontal_index_history) > 0)
        dhorizontal_index = array_pop(dmenu_horizontal_index_history);
    
    if (array_length(dmenu_page_index_history) > 0)
        dhorizontal_page = array_pop(dmenu_page_index_history);
    
    dmenu_state_update();
    dmenu_start_index = clamp(dvertical_index, 0, max(0, array_length(dbutton_options) - dbutton_max_visible));
};

dremove_false_history = function()
{
    if (array_length(dmenu_state_history) > 0)
        array_pop(dmenu_state_history);
    
    if (array_length(dmenu_vertical_index_history) > 0)
        array_pop(dmenu_vertical_index_history);
    
    if (array_length(dmenu_horizontal_index_history) > 0)
        array_pop(dmenu_horizontal_index_history);
    
    if (array_length(dmenu_page_index_history) > 0)
        array_pop(dmenu_page_index_history);
};

ditem_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.ditem_data)) {
        return []; 
    }
    
    return global.ditem_data[_chap];
};

darmor_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.darmor_data)) {
        return []; 
    }
    
    return global.darmor_data[_chap];
};

dweapon_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.dweapon_data)) {
        return []; 
    }
    
    return global.dweapon_data[_chap];
};

dkeyitem_index_data = function(arg0)
{
    var _chap = arg0;
    
    if (_chap < 0 || _chap >= array_length(global.dkeyitem_data)) {
        return []; 
    }
    
    return global.dkeyitem_data[_chap];
};

extract_global_infos = function(arg0)
{
};

cate_enum = 0;
GONER = cate_enum++;
SUPERBOSS = cate_enum++;
WEIRD2 = cate_enum++;
SEAM = cate_enum++;
ZOEUFS = cate_enum++;
ONION_SAN = cate_enum++;
MISC1 = cate_enum++;
MISC2 = cate_enum++;
LOT = cate_enum++;
SWORD3 = cate_enum++;
MISC3 = cate_enum++;
MISC4 = cate_enum++;
MOUSSE = cate_enum++;
ROBOTEUR = cate_enum++;
dother_categories = [dstr("Vessel Sequence", "Séquence Vaisseau"), dstr("Superbosses"), dstr("Weird Route"), dstr("Seam"), dstr("Eggs", "Œufs"), dstr("Onion San"), dstr("Misc Chap 1", "Divers chap 1"), dstr("Misc Chap 2", "Divers chap 2"), dstr("Legend of Tenna"), dstr("Sword Route"), dstr("Misc Chap 3", "Divers chap 3"), dstr("Misc Chap 4", "Divers chap 4"), dstr("Moss", "Mousse"), dstr("Thrash Machine", "Roboteur")];
dother_all_options = [];
dother_options = [];

if (global.chapter >= 0)
{
    array_push(dother_all_options, [GONER, dstr("FAVORITE FOOD", "NOURRITURE"), 903, [[dstr("SWEET", "SUCRÉE"), 0], [dstr("SOFT", "TENDRE"), 1], [dstr("BITTER", "AMÈRE"), 2], [dstr("SALTY", "SALÉE"), 3], [dstr("PAIN", "DOULEUR"), 4], [dstr("COLD", "FROIDE"), 5]]]);
    array_push(dother_all_options, [GONER, dstr("BLOOD TYPE", "GROUPE SANGUIN"), 904, [["A", 0], ["AB", 1], ["B", 2], ["C", 3], ["D", 4]]]);
    array_push(dother_all_options, [GONER, dstr("FAVORITE COLOR", "COULEUR"), 905, [[dstr("RED", "ROUGE"), 0], [dstr("BLUE", "BLEU"), 1], [dstr("GREEN", "VERT"), 2], [dstr("CYAN"), 3]]]);
    array_push(dother_all_options, [GONER, dstr("GIFT", "PRÉSENT"), 909, [[dstr("KINDNESS", "GENTILLESSE"), -1], [dstr("MIND", "ESPRIT"), 0], [dstr("AMBITION"), 1], [dstr("BRAVERY", "BRAVOURE"), 2], [dstr("VOICE", "VOIX"), 3]]]);
    array_push(dother_all_options, [GONER, dstr("OPINION", "SENTIMENT ÉPROUVÉ"), 906, [[dstr("LOVE", "AMOUR"), 0], [dstr("HOPE", "ESPOIR"), 1], [dstr("DISGUST", "DÉGOÛT"), 2], [dstr("FEAR", "PEUR"), 3]]]);
    array_push(dother_all_options, [GONER, dstr("ANSWERED HONESTLY", "RÉPONDU HONNÊTEMENT"), 907, [[dstr("Yes", "Oui"), 0], [dstr("No", "Non"), 1]]]);
    array_push(dother_all_options, [GONER, dstr("CONSENT TO CRISES", "CONSENTIR AUX CRISES"), 908, [[dstr("Yes", "Oui"), 0], [dstr("No", "Non"), 1]]]);
}

if (global.chapter >= 1)
{
    array_push(dother_all_options, [ROBOTEUR, dstr("Thrash Head", "Tête Roboteur"), 220, [[dstr("Laser"), 0], [dstr("Sword", "Épée"), 1], [dstr("Flame", "Flamme"), 2], [dstr("Duck", "Canard"), 3]]]);
    array_push(dother_all_options, [ROBOTEUR, dstr("Thrash Body", "Corps Roboteur"), 221, [[dstr("Simple", "Sobre"), 0], [dstr("Wheel", "Roue"), 1], [dstr("Tank"), 2], [dstr("Duck", "Canard"), 3]]]);
    array_push(dother_all_options, [ROBOTEUR, dstr("Thrash Legs", "Jambes Roboteur"), 222, [[dstr("Sneakers", "Baskets"), 0], [dstr("Tires", "Pneus"), 1], [dstr("Tracks", "Chaînes"), 2], [dstr("Duck", "Canard"), 3]]]);
    array_push(dother_all_options, [MISC1, dstr("Gang Name", "Nom du gang"), 214, [[dstr("The Guys (unused)", "Les Types (unused)"), 0], [dstr("The $!$! Squad", "L'Escouade $?$!$"), 1], [dstr("Lancer Fan Club", "Le Fan Club Lancer"), 2], [dstr("The Fun Gang", "Le Fun Gang"), 3]]]);
    array_push(dother_all_options, [MISC1, dstr("Prophecy heard", "Prophétie entendu"), 203, [[dstr("No", "Non"), 1], [dstr("Yes", "Oui"), 0]]]);
    array_push(dother_all_options, [MISC1, dstr("Manual thrown", "Manuel jeté"), 207, [[dstr("No", "Non"), 0], [dstr("Tried", "A tenté"), 1], [dstr("Thrown", "L'a jeté"), 2]]]);
    array_push(dother_all_options, [MISC1, dstr("Cake returned", "Gâteau rendu"), 253, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC1, dstr("Starwalker"), 254, [["Pissing me off", 0], ["I will join", 1]]]);
    array_push(dother_all_options, [MISC1, dstr("Donation Goal", "Objectif de Donation"), 216, [[dstr("No", "Non"), 0], [dstr("Reached", "Atteint"), 1]]]);
    array_push(dother_all_options, [MISC1, dstr("Asgore's Flowers", "Fleurs d'Asgore"), 262, [[dstr("Not seen", "Pas vu"), 0], [dstr("No", "Non"), 2], [dstr("Given", "Données"), 4]]]);
    array_push(dother_all_options, [MISC1, dstr("Noelle outside", "Noelle dehors"), 276, [[dstr("No", "Non"), 0], [dstr("No", "Non"), 1], [dstr("Talked to Susie", "A parlé à Susie"), 2]]]);
    array_push(dother_all_options, [MISC1, dstr("Sink inspected (ch 1)", "Évier inspecté (chap 1)"), 278, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [ZOEUFS, dstr("Egg obtained (ch 1)", "Œuf obtenu (chap 1)"), 911, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr("Jevil defeated", "Jevil vaincu"), 241, [[dstr("No", "Non"), 0], [dstr("Via violence"), 6], [dstr("Via mercy", "Via clémence"), 7]]]);
    array_push(dother_all_options, [ONION_SAN, dstr("Relation (ch 1)", "Relation (chap 1)"), 258, [[dstr("Not seen", "Pas vu"), 0], [dstr("Friends", "Amis"), 2], [dstr("Not friends", "Pas amis"), 3]]]);
    array_push(dother_all_options, [ONION_SAN, dstr("Kris's Name", "Nom de Kris"), 259, [[dstr("No", "Non"), 0], ["Kris", 1], [dstr("Hippo", "Hippopotame"), 2]]]);
    array_push(dother_all_options, [ONION_SAN, dstr("Onion's Name", "Nom d'Onion"), 260, [[dstr("No", "Non"), 0], [dstr("Onyx", "Oignon"), 1], [dstr("Beauty", "Beauté"), 2], [dstr("Asriel II"), 3], [dstr("Stinky", "Dégoûtant"), 4]]]);
    array_push(dother_all_options, [MOUSSE, dstr("Moss eaten (ch 1)", "Mousse mangée (chap 1)"), 106, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
}

if (global.chapter >= 2)
{
    array_push(dother_all_options, [MISC2, dstr("Plushie", "Peluche"), 307, [[dstr("Not given", "Pas donnée"), 0], ["Ralsei", 1], ["Susie", 2], ["Noëlle", 3], ["Berdly", 4]]]);
    array_push(dother_all_options, [MISC2, dstr("Hacker recruited", "Hacker recruté"), 659, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC2, dstr("Berdly's Arm", "Bras de Berdly"), 457, [[dstr("Burnt", "Brûlé"), 0], [dstr("Ok"), 1]]]);
    array_push(dother_all_options, [MISC2, dstr("Mettaton 'Fan'", "\"Fan\" de Mettaton"), 422, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC2, dstr("Susie Statue collected", "Statue de Susie récupérée"), 393, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC2, dstr("ICE-E collected", "ICE-E récupéré"), 394, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC2, dstr("Sink inspected (ch 2)", "Évier inspecté (chap 2)"), 461, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC2, dstr("Shelter scene seen", "Scène de l'abri vue"), 315, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [WEIRD2, dstr("Progress", "Avancée"), 915, [[dstr("No", "Non"), 0], [dstr("Addison killed", "Nikomercant tué"), 3], [dstr("Berdly frozen", "Berdly gelé"), 6], [dstr("Talked to Susie", "A parlé à Susie"), 9], [dstr("Noelle at hospital", "Noëlle à l'hôpital"), 20]]]);
    array_push(dother_all_options, [WEIRD2, dstr("Canceled Weird Route", "A annulé la weird route"), 916, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [ZOEUFS, dstr("Egg obtained (ch 2)", "Œuf obtenu (chap 2)"), 918, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr("Spamton defeated", "Spamton vaincu"), 309, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 9]]]);
    array_push(dother_all_options, [ONION_SAN, dstr("Relation (ch 2)", "Relation (chap 2)"), 425, [[dstr("Not seen", "Pas vu"), 0], [dstr("Friends", "Amis"), 1], [dstr("Not friends anymore", "Plus amis"), 2]]]);
    array_push(dother_all_options, [MOUSSE, dstr("Moss eaten (ch 2)", "Mousse mangée (chap 2)"), 920, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr("... with Noelle", "... avec Noëlle"), 921, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr("... with Susie", "... avec Susie"), 922, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SEAM, dstr("Seam gave up quest", "Seam a abandonné la quête"), 961, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SEAM, dstr("Jevil's Crystal given", "Cristal de Jevil donné"), 954, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SEAM, dstr("Spamton's Crystal given", "Cristal de Spamton donné"), 353, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SEAM, dstr("Talked to Seam", "A parlé à Seam tout court"), 312, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
}

if (global.chapter >= 3)
{
    array_push(dother_all_options, [LOT, dstr("LOT Board 1 Rank", "LOT Rang Board 1"), 1173, [["Z", 0], ["C", 1], ["B", 2], ["A", 3], ["S", 4], ["T", 5]]]);
    array_push(dother_all_options, [LOT, dstr("LOT Board 2 Rank", "LOT Rang Board 2"), 1174, [["Z", 0], ["C", 1], ["B", 2], ["A", 3], ["S", 4], ["T", 5]]]);
    array_push(dother_all_options, [SWORD3, dstr("Sword Route Progress", "Avancée Sword Route"), 1055, [[dstr("Not seen", "Pas vu"), 0], [dstr("Ice Key obtained", "Clé de glace obtenue"), 1], [dstr("Dungeon (Floor 2)", "Donjon (plateau 2)"), 1.5], [dstr("Key used", "Clé utilisée"), 2], [dstr("Shelter Key obtained", "Clé de l'abri obtenue"), 3], [dstr("Dungeon (Floor 3)", "Donjon (plateau 3)"), 4], [dstr("Shelter Key used", "Clé de l'abri utilisée"), 5], [dstr("ERAM defeated", "ERAM vaincu"), 6]]]);
    array_push(dother_all_options, [SWORD3, dstr("Susie attacked", "Susie attaquée"), 1268, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [ZOEUFS, dstr("Egg obtained (ch 3)", "Œuf obtenu (chap 3)"), 930, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr("Knight defeated", "Chevalier vaincu"), 1047, [[dstr("No", "Non"), 2], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC3, dstr("Fountain", "Fontaine"), 1144, [[dstr("Not seen", "Pas vu"), 0], [dstr("Flirted (no curtain)", "A flirté (pas au rideau)"), 1], [dstr("No flirt", "Pas flirté"), 2], [dstr("Flirted (talked to curtain)", "A flirté (au rideau)"), 3]]]);
    array_push(dother_all_options, [MISC3, dstr("Tenna Statue collected", "Statue de Tenna récupérée"), 1222, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr("Moss eaten (ch 3)", "Mousse mangée (chap 3)"), 1078, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SEAM, dstr("Knight's Crystal given", "Cristal du Chevalier donné"), 856, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
}

if (global.chapter >= 4)
{
    array_push(dother_all_options, [ZOEUFS, dstr("Egg obtained (ch 4)", "Œuf obtenu (chap 4)"), 931, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [SUPERBOSS, dstr("Gerson defeated", "Gerson vaincu"), 1629, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MOUSSE, dstr("Moss eaten (ch 4)", "Mousse mangée (chap 4)"), 1592, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1], [dstr("Refused", "Refusée"), 2]]]);
    array_push(dother_all_options, [MISC4, dstr("Ralsei's Room", "Chambre de Ralsei"), 710, [[dstr("Not seen", "Pas vu"), 0], [dstr("Seen", "Vu"), 2]]]);
    array_push(dother_all_options, [MISC4, dstr("QC's with Susie", "QC avec Susie"), 701, [[dstr("No", "Non"), 0], [dstr("Visited", "Y est allé"), 1]]]);
    array_push(dother_all_options, [MISC4, dstr("Tea with Ralsei", "Thé avec Ralsei"), 1514, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC4, dstr("Prayer", "Prière"), 1507, [[dstr("No", "Non"), 0], [dstr("For Susie", "Pour Susie"), 1], [dstr("For Noelle", "Pour Noëlle"), 2], [dstr("For Asriel", "Pour Asriel"), 3]]]);
    array_push(dother_all_options, [MISC4, dstr("Tenna given", "Tenna donné"), 779, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 2]]]);
    array_push(dother_all_options, [MISC4, dstr("Noelle's Phone", "Tel. de Noëlle"), 714, [[dstr("Not inspected", "Pas inspecté"), 0], [dstr("Didn't answer", "Pas répondu"), 1], [dstr("Go to festival", "Allez au festival"), 2], [dstr("Wrong number song"), 3]]]);
    array_push(dother_all_options, [MISC4, dstr("Susie's Prize collected", "Prix Susie récupéré"), 747, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC4, dstr("Stain removed", "Tache retirée"), 748, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC4, dstr("Ladder collected", "Échelle récupérée"), 864, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
    array_push(dother_all_options, [MISC4, dstr("Pillow collected", "Oreiller récupéré"), 865, [[dstr("No", "Non"), 0], [dstr("Yes", "Oui"), 1]]]);
}

dflag_categories_len = [];

for (i = 0; i < array_length(dother_categories); i++)
    array_push(dflag_categories_len, 0);

for (i = 0; i < array_length(dother_all_options); i++)
    dflag_categories_len[dother_all_options[i][0]] += 1;

dglobal_changer_options = [["Custom", "string", -1]];
array_push(dglobal_changer_options, ["truename", "string", -1]);
array_push(dglobal_changer_options, ["othername", "string", 6]);
array_push(dglobal_changer_options, ["gold", "int", -1]);
array_push(dglobal_changer_options, ["maxhp", "uint", 5]);
array_push(dglobal_changer_options, ["hp", "int", 5]);
array_push(dglobal_changer_options, ["at", "int", 5]);
array_push(dglobal_changer_options, ["df", "int", 5]);
array_push(dglobal_changer_options, ["mag", "int", 5]);
global.dreading_custom_flag = 0;
dcustom_flag_text = ["", ""];
dkeys_helper = 0;
dkeys_data = [];
drooms_id = scr_get_room_list();
drooms = [];
drooms_options = 
{
    target_room: ROOM_INITIALIZE,
    target_plot: global.plot,
    target_is_darkzone: global.darkzone,
    target_member_2: global.char[1],
    target_member_3: global.char[2]
};
dkeyboard_input = "";

for (i = 0; i < array_length(drooms_id); i++)
    array_push(drooms, room_get_name(drooms_id[i].room_index));

obj_list = [];
all_obj_list = [];
var index = 0;

while (true)
{
    var obj_name = object_get_name(index);

    if (obj_name == "<undefined>" || obj_name == "")
    {
        break;
    }

    array_push(all_obj_list, obj_name);
    index++;
}

find_subarray_index = function(arg0, arg1)
{
    value = global.flag[arg0];
    lst = arg1;
    prev = 0;
    
    for (i = 0; i < array_length(lst); i++)
    {
        if (lst[i][1] > value)
            break;
        
        prev = i;
    }
    
    return prev;
};

draw_monospace = function(arg0, arg1, arg2)
{
    draw_x = arg0;
    sep = (global.darkzone == 1) ? 15 : 8;
    
    for (i = 0; i < string_length(arg2); i++)
    {
        draw_text(draw_x, arg1, string_char_at(arg2, i + 1));
        draw_x += sep;
    }
};

draw_monospace_ext = function(arg0, arg1, arg2, arg3, arg4)
{
    var _start_x = arg0;
    var _start_y = arg1;
    var _text = string(arg2);
    var _line_sep = arg3;
    var _max_width = arg4;
    var _char_sep = (global.darkzone == 1) ? 15 : 8;
    var _draw_x = _start_x;
    var _draw_y = _start_y;
    var _current_word = "";
    var _text_len = string_length(_text);
    
    for (var i = 1; i <= _text_len; i++)
    {
        var _char = string_char_at(_text, i);
        
        if (_char != " " && _char != "\n")
            _current_word += _char;
        
        if (_char == " " || _char == "\n" || i == _text_len)
        {
            var _word_width = string_length(_current_word) * _char_sep;
            
            if (_max_width > 0 && ((_draw_x + _word_width) - _start_x) > _max_width)
            {
                if (_draw_x != _start_x)
                {
                    _draw_x = _start_x;
                    _draw_y += _line_sep;
                }
            }
            
            for (var w = 1; w <= string_length(_current_word); w++)
            {
                if (_max_width > 0 && ((_draw_x + _char_sep) - _start_x) > _max_width)
                {
                    _draw_x = _start_x;
                    _draw_y += _line_sep;
                }
                
                draw_text(_draw_x, _draw_y, string_char_at(_current_word, w));
                _draw_x += _char_sep;
            }
            
            _current_word = "";
            
            if (_char == " ")
            {
                _draw_x += _char_sep;
            }
            else if (_char == "\n")
            {
                _draw_x = _start_x;
                _draw_y += _line_sep;
            }
        }
    }
};

set_keyboard_reader = function(arg0)
{
    global.dreading_custom_flag = arg0;
    keyboard_string = "";
    dcustom_flag_text = ["", ""];
    global.dkeyboard_text = "";
};

dload_options = 
{
    target_save: -1,
    target_with_cur_inv: global.dload_cur_inv
};

function parse_var_str(arg0, arg1)
{
    str = arg0;
    check_error = arg1;
    is_good = scr_string_respect_type(str, "variable", 1, check_error);
    dtemp_text = "";
    dtemp_num = 0;
    
    if (!is_good)
        return 0;
    
    brack_start = string_pos("[", str);
    
    if (brack_start == 0)
    {
        dtemp_text = str;
        dtemp_num = -1;
    }
    else
    {
        dtemp_text = string_copy(str, 1, brack_start - 1);
        dtemp_num = real(string_copy(str, brack_start + 1, string_length(str) - brack_start - 1));
    }
    
    return 1;
}

dmenu_expanded = {};
dmenu_last_search = "";
dmenu_was_searching = false;
my_options = [];

function dmenu_process_submenus(arg0, arg1 = "")
{
    my_options = array_create(array_length(dbutton_options));
    array_copy(my_options, 0, dbutton_options, 0, array_length(dbutton_options));
    var _state_tracker = variable_struct_exists(dmenu_expanded, dmenu_state) ? variable_struct_get(dmenu_expanded, dmenu_state) : array_create(array_length(dbutton_options), false);
    
    while (array_length(_state_tracker) < array_length(my_options))
        array_push(_state_tracker, false);
    
    var _search = string_lower(arg1);
    var _search_changed = dmenu_last_search != _search;
    dmenu_last_search = _search;
    
    if (_search == "" && dmenu_was_searching)
    {
        for (var k = 0; k < array_length(_state_tracker); k++)
            _state_tracker[k] = false;
        
        dmenu_was_searching = false;
    }
    else if (_search != "")
    {
        dmenu_was_searching = true;
    }
    
    var _temp_options = [];
    var _temp_indices = [];
    var _temp_base_indices = [];
    var _needs_struct_save = false;
    
    for (var i = 0; i < array_length(my_options); i++)
    {
        var _base_name = my_options[i];
        var _is_dropdown = i < array_length(arg0) && is_array(arg0[i]);
        var _original_index = (i < array_length(dbutton_indices)) ? dbutton_indices[i] : -1;
        var _is_persistent = _original_index == -2;
        var _cat_match = true;
        var _sub_match = false;
        
        if (_search != "" && !_is_persistent)
        {
            _cat_match = string_pos(_search, string_lower(_base_name)) > 0;
            
            if (_is_dropdown)
            {
                var _submenu = arg0[i];
                
                for (var j = 0; j < array_length(_submenu); j++)
                {
                    if (string_pos(_search, string_lower(_submenu[j])) > 0)
                        _sub_match = true;
                }
                
                if (_search_changed && _state_tracker[i] != _sub_match)
                {
                    _state_tracker[i] = _sub_match;
                    _needs_struct_save = true;
                }
            }
            
            if (!_cat_match && !_sub_match)
                continue;
        }
        
        var _is_open = _is_dropdown && _state_tracker[i] == true;
        var _display_name = _base_name;
        
        if (_is_dropdown)
            _display_name += (_is_open ? " ^" : " v");
        
        array_push(_temp_options, _display_name);
        array_push(_temp_indices, _original_index);
        array_push(_temp_base_indices, i);
        
        if (_is_open)
        {
            var _submenu = arg0[i];
            var _subindices = (array_length(arg0) > (i + 1000) && is_array(arg0[i + 1000])) ? arg0[i + 1000] : [];
            
            for (var j = 0; j < array_length(_submenu); j++)
            {
                if (_search == "" || _cat_match || string_pos(_search, string_lower(_submenu[j])) > 0)
                {
                    array_push(_temp_options, "- " + _submenu[j]);
                    var exact_index = (array_length(_subindices) > j) ? _subindices[j] : -1;
                    array_push(_temp_indices, exact_index);
                    array_push(_temp_base_indices, i);
                }
            }
        }
    }
    
    if (_needs_struct_save || !variable_struct_exists(dmenu_expanded, dmenu_state))
        variable_struct_set(dmenu_expanded, dmenu_state, _state_tracker);
    
    dbutton_options = _temp_options;
    dbutton_indices = _temp_indices;
    dbutton_base_indices = _temp_base_indices;
}

function dmenu_interact_submenus(arg0)
{
    var _clicked_index = -1;
    
    for (var i = 0; i < array_length(my_options); i++)
    {
        var _base_name = my_options[i];
        
        if (arg0 == (_base_name + " v") || arg0 == (_base_name + " ^"))
        {
            _clicked_index = i;
            break;
        }
    }
    
    if (_clicked_index != -1 && variable_struct_exists(dmenu_expanded, dmenu_state))
    {
        var _state_tracker = variable_struct_get(dmenu_expanded, dmenu_state);
        
        if (_clicked_index < array_length(_state_tracker))
        {
            _state_tracker[_clicked_index] = !_state_tracker[_clicked_index];
            variable_struct_set(dmenu_expanded, dmenu_state, _state_tracker);
            dmenu_skip_reindexing = true;
            dremove_false_history();
            return true;
        }
    }
    
    return false;
}
