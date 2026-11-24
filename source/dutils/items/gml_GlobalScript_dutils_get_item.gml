function dutils_give_item(arg0, arg1, arg2=1)
{
	var item_id = arg0;
	var item_type = arg1;
	var quantity = arg2;

	if (quantity == 0)
		return (0);

	var _remove = (quantity < 0);

	var callfunc = undefined;
	switch (item_type) {
		case "item":
			callfunc = (!_remove) ? scr_itemget : scr_itemremove;
			break;

		case "litem":
			callfunc = (!_remove) ? scr_litemget : scr_litemremove;
			break;

		case "weapon":
			callfunc = (!_remove) ? scr_weaponget : scr_weaponremove;
			break;

		case "armor":
			callfunc = (!_remove) ? scr_armorget : scr_armorremove;
			break;

		case "key":
			callfunc = (!_remove) ? scr_keyitemget : scr_keyitemremove;
			break;
	}

	for (var i = 0; i < abs(quantity); i++)
		callfunc(item_id);
}
