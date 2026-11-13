function dmenu_update_items_main_menu()
{
	dmenu_title = dstr("Item Type", "Type d'items");
	dbuttons_2d = [
		[
			dmenu_makebt(dstr("Items", "Objets"), "items"),
			dmenu_makebt(dstr("Armors", "Armures"), "armors"),
			dmenu_makebt(dstr("Weapons", "Armes"), "weapons"),
			dmenu_makebt(dstr("Key Items", "Obj Clés"), "keyitems")
		]
	];
	dmenu_box = 0;
	dbutton_layout = 0;
}

function dmenu_update_givertab()
{
	dmenu_title = dstr("Add how many to inventory?", "Ajouter combien à l'inventaire ?");
	dhorizontal_index = 1;
	if (dgiver_infos.storage_space == 0)
		dhorizontal_index = 0;

	scr_debug_print("[" + string(-dgiver_infos.owned_amt) + ", " + string(dgiver_infos.storage_space) + "]");
	dbuttons = [
		dmenu_makebt("", -1, [-dgiver_infos.owned_amt, dgiver_infos.storage_space])
	];
	
	dmenu_box = 0;
	dbutton_layout = 2;
}
