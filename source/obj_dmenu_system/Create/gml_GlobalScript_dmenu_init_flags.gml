function dmenu_init_flags()
{
	var cate_enum = 0;

	var GONER = cate_enum++;
	var SUPERBOSS = cate_enum++;
	var WEIRD2 = cate_enum++;
	var SEAM = cate_enum++;
	var ZOEUFS = cate_enum++;
	var ONION_SAN = cate_enum++;
	var MISC1 = cate_enum++;
	var MISC2 = cate_enum++;
	var LOT = cate_enum++;
	var SWORD3 = cate_enum++;
	var MISC3 = cate_enum++;
	var MISC4 = cate_enum++;
	var MOUSSE = cate_enum++;
	var ROBOTEUR = cate_enum++;

	dother_categories = [
		dstr("Vessel Sequence", "Séquence Vaisseau"),
		dstr("Superbosses"),
		dstr("Weird Route"),
		dstr("Seam"),
		dstr("Eggs", "Œufs"),
		dstr("Onion San"),
		dstr("Misc Chap 1", "Divers chap 1"),
		dstr("Misc Chap 2", "Divers chap 2"),
		dstr("Legend of Tenna"),
		dstr("Sword Route"),
		dstr("Misc Chap 3", "Divers chap 3"),
		dstr("Misc Chap 4", "Divers chap 4"),
		dstr("Moss", "Mousse"),
		dstr("Thrash Machine", "Roboteur")
	];

	dother_all_options = [];
	dother_options = [];

	if (global.chapter >= 0)
	{
		array_push(dother_all_options, [
			GONER, dstr("FAVORITE FOOD", "NOURRITURE"), 903,
			[
				[dstr("SWEET", "SUCRÉE"), 0],
				[dstr("SOFT", "TENDRE"), 1],
				[dstr("BITTER", "AMÈRE"), 2],
				[dstr("SALTY", "SALÉE"), 3],
				[dstr("PAIN", "DOULEUR"), 4],
				[dstr("COLD", "FROIDE"), 5]
			]
		]);

		array_push(dother_all_options, [
			GONER, dstr("BLOOD TYPE", "GROUPE SANGUIN"), 904,
			[
				["A", 0],
				["AB", 1],
				["B", 2],
				["C", 3],
				["D", 4]
			]
		]);

		array_push(dother_all_options, [
			GONER, dstr("FAVORITE COLOR", "COULEUR"), 905,
			[
				[dstr("RED", "ROUGE"), 0],
				[dstr("BLUE", "BLEU"), 1],
				[dstr("GREEN", "VERT"), 2],
				[dstr("CYAN"), 3]
			]
		]);

		array_push(dother_all_options, [
			GONER, dstr("GIFT", "PRÉSENT"), 909,
			[
				[dstr("KINDNESS", "GENTILLESSE"), -1],
				[dstr("MIND", "ESPRIT"), 0],
				[dstr("AMBITION"), 1], 
				[dstr("BRAVERY", "BRAVOURE"), 2],
				[dstr("VOICE", "VOIX"), 3]
			]
		]);

		array_push(dother_all_options, [
			GONER, dstr("OPINION", "SENTIMENT ÉPROUVÉ"), 906,
			[
				[dstr("LOVE", "AMOUR"), 0],
				[dstr("HOPE", "ESPOIR"), 1],
				[dstr("DISGUST", "DÉGOÛT"), 2],
				[dstr("FEAR", "PEUR"), 3]
			]
		]);

		array_push(dother_all_options, [
			GONER, dstr("ANSWERED HONESTLY", "RÉPONDU HONNÊTEMENT"), 907,
			[
				[dstr("Yes", "Oui"), 0],
				[dstr("No", "Non"), 1]
			]
		]);

		array_push(dother_all_options, [
			GONER, dstr("CONSENT TO CRISES", "CONSENTIR AUX CRISES"), 908,
			[
				[dstr("Yes", "Oui"), 0],
				[dstr("No", "Non"), 1]
			]
		]);
	}

	if (global.chapter >= 1)
	{
		array_push(dother_all_options, [
			ROBOTEUR, dstr("Thrash Head", "Tête Roboteur"), 220,
			[
				[dstr("Laser"), 0],
				[dstr("Sword", "Épée"), 1],
				[dstr("Flame", "Flamme"), 2],
				[dstr("Duck", "Canard"), 3]
			]
		]);

		array_push(dother_all_options, [
			ROBOTEUR, dstr("Thrash Body", "Corps Roboteur"), 221,
			[
				[dstr("Simple", "Sobre"), 0],
				[dstr("Wheel", "Roue"), 1],
				[dstr("Tank"), 2], 
				[dstr("Duck", "Canard"), 3]
			]
		]);

		array_push(dother_all_options, [
			ROBOTEUR, dstr("Thrash Legs", "Jambes Roboteur"), 222,
			[
				[dstr("Sneakers", "Baskets"), 0],
				[dstr("Tires", "Pneus"), 1],
				[dstr("Tracks", "Chaînes"), 2],
				[dstr("Duck", "Canard"), 3]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Gang Name", "Nom du gang"), 214,
			[
				[dstr("The Guys (unused)", "Les Types (unused)"), 0],
				[dstr("The $!$! Squad", "L'Escouade $?$!$"), 1],
				[dstr("Lancer Fan Club", "Le Fan Club Lancer"), 2],
				[dstr("The Fun Gang", "Le Fun Gang"), 3]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Prophecy heard", "Prophétie entendu"), 203,
			[
				[dstr("No", "Non"), 1],
				[dstr("Yes", "Oui"), 0]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Manual thrown", "Manuel jeté"), 207,
			[
				[dstr("No", "Non"), 0],
				[dstr("Tried", "A tenté"), 1],
				[dstr("Thrown", "L'a jeté"), 2]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Cake returned", "Gâteau rendu"), 253,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Starwalker"), 254,
			[
				["Pissing me off", 0],
				["I will join", 1]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Donation Goal", "Objectif de Donation"), 216,
			[
				[dstr("No", "Non"), 0],
				[dstr("Reached", "Atteint"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Asgore's Flowers", "Fleurs d'Asgore"), 262,
			[
				[dstr("Not seen", "Pas vu"), 0],
				[dstr("No", "Non"), 2],
				[dstr("Given", "Données"), 4]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Noelle outside", "Noelle dehors"), 276,
			[
				[dstr("No", "Non"), 0],
				[dstr("No", "Non"), 1],
				[dstr("Talked to Susie", "A parlé à Susie"), 2]
			]
		]);

		array_push(dother_all_options, [
			MISC1, dstr("Sink inspected (ch 1)", "Évier inspecté (chap 1)"), 278,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			ZOEUFS, dstr("Egg obtained (ch 1)", "Œuf obtenu (chap 1)"), 911,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SUPERBOSS, dstr("Jevil defeated", "Jevil vaincu"), 241,
			[
				[dstr("No", "Non"), 0],
				[dstr("Via violence"), 6],
				[dstr("Via mercy", "Via clémence"), 7]
			]
		]);

		array_push(dother_all_options, [
			ONION_SAN, dstr("Relation (ch 1)", "Relation (chap 1)"), 258,
			[
				[dstr("Not seen", "Pas vu"), 0],
				[dstr("Friends", "Amis"), 2],
				[dstr("Not friends", "Pas amis"), 3]
			]
		]);

		array_push(dother_all_options, [
			ONION_SAN, dstr("Kris's Name", "Nom de Kris"), 259,
			[
				[dstr("No", "Non"), 0],
				["Kris", 1],
				[dstr("Hippo", "Hippopotame"), 2]
			]
		]);

		array_push(dother_all_options, [
			ONION_SAN, dstr("Onion's Name", "Nom d'Onion"), 260,
			[
				[dstr("No", "Non"), 0],
				[dstr("Onyx", "Oignon"), 1],
				[dstr("Beauty", "Beauté"), 2],
				[dstr("Asriel II"), 3],
				[dstr("Stinky", "Dégoûtant"), 4]
			]
		]);

		array_push(dother_all_options, [
			MOUSSE, dstr("Moss eaten (ch 1)", "Mousse mangée (chap 1)"), 106,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);
	}
	
	if (global.chapter >= 2)
	{
		array_push(dother_all_options, [
			MISC2, dstr("Plushie", "Peluche"), 307,
			[
				[dstr("Not given", "Pas donnée"), 0],
				["Ralsei", 1],
				["Susie", 2],
				[dstr("Noelle", "Noëlle"), 3],
				["Berdly", 4]
			]
		]);

		array_push(dother_all_options, [
			MISC2, dstr("Hacker recruited", "Hacker recruté"), 659,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC2, dstr("Berdly's Arm", "Bras de Berdly"), 457,
			[
				[dstr("Burnt", "Brûlé"), 0],
				[dstr("Ok"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC2, dstr("Mettaton 'Fan'", "\"Fan\" de Mettaton"), 422,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC2, dstr("Susie Statue collected", "Statue de Susie récupérée"), 393,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC2, dstr("ICE-E collected", "ICE-E récupéré"), 394,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC2, dstr("Sink inspected (ch 2)", "Évier inspecté (chap 2)"), 461,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC2, dstr("Shelter scene seen", "Scène de l'abri vue"), 315,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			WEIRD2, dstr("Progress", "Avancée"), 915,
			[
				[dstr("No", "Non"), 0],
				[dstr("Addison killed", "Nikomercant tué"), 3],
				[dstr("Berdly frozen", "Berdly gelé"), 6],
				[dstr("Talked to Susie", "A parlé à Susie"), 9],
				[dstr("Noelle at hospital", "Noëlle à l'hôpital"), 20]
			]
		]);

		array_push(dother_all_options, [
			WEIRD2, dstr("Canceled Weird Route", "A annulé la weird route"), 916,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			ZOEUFS, dstr("Egg obtained (ch 2)", "Œuf obtenu (chap 2)"), 918,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SUPERBOSS, dstr("Spamton defeated", "Spamton vaincu"), 309,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 9]
			]
		]);

		array_push(dother_all_options, [
			ONION_SAN, dstr("Relation (ch 2)", "Relation (chap 2)"), 425,
			[
				[dstr("Not seen", "Pas vu"), 0],
				[dstr("Friends", "Amis"), 1],
				[dstr("Not friends anymore", "Plus amis"), 2]
			]
		]);

		array_push(dother_all_options, [
			MOUSSE, dstr("Moss eaten (ch 2)", "Mousse mangée (chap 2)"), 920,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MOUSSE, dstr("... with Noelle", "... avec Noëlle"), 921,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MOUSSE, dstr("... with Susie", "... avec Susie"), 922,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SEAM, dstr("Seam gave up quest", "Seam a abandonné la quête"), 961,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SEAM, dstr("Jevil's Crystal given", "Cristal de Jevil donné"), 954,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SEAM, dstr("Spamton's Crystal given", "Cristal de Spamton donné"), 353,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SEAM, dstr("Talked to Seam", "A parlé à Seam tout court"), 312,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);
	}

	if (global.chapter >= 3)
	{
		array_push(dother_all_options, [
			LOT, dstr("LOT Board 1 Rank", "LOT Rang Board 1"), 1173,
			[
				["Z", 0],
				["C", 1],
				["B", 2],
				["A", 3],
				["S", 4],
				["T", 5]
			]
		]);

		array_push(dother_all_options, [
			LOT, dstr("LOT Board 2 Rank", "LOT Rang Board 2"), 1174,
			[
				["Z", 0],
				["C", 1],
				["B", 2],
				["A", 3],
				["S", 4],
				["T", 5]
			]
		]);

		array_push(dother_all_options, [
			SWORD3, dstr("Sword Route Progress", "Avancée Sword Route"), 1055,
			[
				[dstr("Not seen", "Pas vu"), 0],
				[dstr("Ice Key obtained", "Clé de glace obtenue"), 1],
				[dstr("Dungeon (Floor 2)", "Donjon (plateau 2)"), 1.5],
				[dstr("Key used", "Clé utilisée"), 2],
				[dstr("Shelter Key obtained", "Clé de l'abri obtenue"), 3],
				[dstr("Dungeon (Floor 3)", "Donjon (plateau 3)"), 4],
				[dstr("Shelter Key used", "Clé de l'abri utilisée"), 5],
				[dstr("ERAM defeated", "ERAM vaincu"), 6]
			]
		]);

		array_push(dother_all_options, [
			SWORD3, dstr("Susie attacked", "Susie attaquée"), 1268,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			ZOEUFS, dstr("Egg obtained (ch 3)", "Œuf obtenu (chap 3)"), 930,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SUPERBOSS, dstr("Knight defeated", "Chevalier vaincu"), 1047,
			[
				[dstr("No", "Non"), 2],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC3, dstr("Fountain", "Fontaine"), 1144,
			[
				[dstr("Not seen", "Pas vu"), 0],
				[dstr("Flirted (no curtain)", "A flirté (pas au rideau)"), 1],
				[dstr("No flirt", "Pas flirté"), 2],
				[dstr("Flirted (talked to curtain)", "A flirté (au rideau)"), 3]
			]
		]);

		array_push(dother_all_options, [
			MISC3, dstr("Tenna Statue collected", "Statue de Tenna récupérée"), 1222,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MOUSSE, dstr("Moss eaten (ch 3)", "Mousse mangée (chap 3)"), 1078,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SEAM, dstr("Knight's Crystal given", "Cristal du Chevalier donné"), 856,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);
	}

	if (global.chapter >= 4)
	{
		array_push(dother_all_options, [
			ZOEUFS, dstr("Egg obtained (ch 4)", "Œuf obtenu (chap 4)"), 931,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			SUPERBOSS, dstr("Gerson defeated", "Gerson vaincu"), 1629,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MOUSSE, dstr("Moss eaten (ch 4)", "Mousse mangée (chap 4)"), 1592,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1],
				[dstr("Refused", "Refusée"), 2]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Ralsei's Room", "Chambre de Ralsei"), 710,
			[
				[dstr("Not seen", "Pas vu"), 0],
				[dstr("Seen", "Vu"), 2]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("QC's with Susie", "QC avec Susie"), 701,
			[
				[dstr("No", "Non"), 0],
				[dstr("Visited", "Y est allé"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Tea with Ralsei", "Thé avec Ralsei"), 1514,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Prayer", "Prière"), 1507,
			[
				[dstr("No", "Non"), 0],
				[dstr("For Susie", "Pour Susie"), 1],
				[dstr("For Noelle", "Pour Noëlle"), 2],
				[dstr("For Asriel", "Pour Asriel"), 3]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Tenna given", "Tenna donné"), 779,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 2]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Noelle's Phone", "Tel. de Noëlle"), 714,
			[
				[dstr("Not inspected", "Pas inspecté"), 0],
				[dstr("Didn't answer", "Pas répondu"), 1],
				[dstr("Go to festival", "Allez au festival"), 2],
				[dstr("Wrong number song"), 3]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Susie's Prize collected", "Prix Susie récupéré"), 747,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Stain removed", "Tache retirée"), 748,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Ladder collected", "Échelle récupérée"), 864,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);

		array_push(dother_all_options, [
			MISC4, dstr("Pillow collected", "Oreiller récupéré"), 865,
			[
				[dstr("No", "Non"), 0],
				[dstr("Yes", "Oui"), 1]
			]
		]);
	}

	dflag_categories_len = [];

	for (i = 0; i < array_length(dother_categories); i++)
		array_push(dflag_categories_len, 0);

	for (i = 0; i < array_length(dother_all_options); i++)
		dflag_categories_len[dother_all_options[i][0]] += 1;
}
