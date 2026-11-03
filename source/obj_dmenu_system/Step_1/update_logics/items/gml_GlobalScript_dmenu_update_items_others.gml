function dmenu_update_items_main_menu()
{
	dmenu_title = dstr("Item Type", "Type d'items");
	dbutton_options_2d = [[dstr("Items", "Objets"), dstr("Armors", "Armures"), dstr("Weapons", "Armes"), dstr("Key Items", "Obj Clés")]];
	dmenu_box = 0;
	dbutton_layout = 0;
}

function dmenu_update_givertab()
{
	dmenu_title = dstr("Add how many to inventory?", "Ajouter combien à l'inventaire ?");
	dhorizontal_index = 1;
	if (dgiver_infos.storage_space == 0)
		dhorizontal_index = 0;
	
	dmenu_box = 0;
	dbutton_layout = 2;
}
