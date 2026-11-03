function dutils_get_itemname(arg0, arg1="items")
{
	var item_id = arg0;
	var item_type = dutils_get_simplify_itemtype(arg1);
	if (item_type == undefined)
		return ("[ERROR]");

	var res = "";
	switch (item_type) {
		case "item":
			scr_iteminfo(item_id);
			res = itemnameb;
			break;

		case "armor":
			scr_armorinfo(item_id);
			res = armornametemp;
			break;

		case "weapon":
			scr_weaponinfo(item_id);
			res = weaponnametemp;
			break;

		case "key":
			scr_keyiteminfo(item_id);
			res = tempkeyitemname;
			break;
	}
	return (res);
}

function dutils_get_armorname(arg0)
{
	return (dutils_get_itemname(arg0, "armor"));
}

function dutils_get_weaponname(arg0)
{
	return (dutils_get_itemname(arg0, "weapon"));
}

function dutils_get_keyitemname(arg0)
{
	return (dutils_get_itemname(arg0, "keyitem"));
}
