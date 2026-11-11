function dutils_get_simplify_itemtype(arg0)
{
	var lookup_type = arg0;
	var res = undefined;

	switch (lookup_type) {
		case "item":
		case "items":
			res = "item";
			break;

		case "armor":
		case "armors":
			res = "armor";
			break;

		case "weapon":
		case "weapons":
			res = "weapon";
			break;

		case "key":
		case "keys":
		case "keyitem":
		case "keyitems":
		case "key item":
		case "key items":
			res = "key";
			break;

		default:
			scr_debug_print("Unknown item type '" + string(lookup_type) + "'");
			break;
	}
	return (res);
}

function dutils_get_storage_space(arg0)
{
	var item_type = dutils_get_simplify_itemtype(arg0);
	var armor_limit = (global.chapter == 1) ? 12 : 48;
	var res = 0;

	switch (item_type) {
		case "item":
			res = 12;
			break;

		case "armor":
		case "weapon":
			res = armor_limit;
			break;

		case "key":
			res = 12;
			break;
	}
	return (res);
}

function dutils_get_itemcount(arg0, arg1)
{
	var item_id = arg0;
	var item_type = dutils_get_simplify_itemtype(arg1);

	var storage_size = dutils_get_storage_space(item_type);
	var item_list = [];

	switch (item_type) {
		case "item":
			item_list = global.item;
			break;

		case "armor":
			item_list = global.armor;
			break;

		case "weapon":
			item_list = global.weapon;
			break;

		case "key":
			item_list = global.keyitem;
			break;
	}

	var res = 0;
	for (var i = 0; i < storage_size; i++) {
		if (item_list[i] == item_id)
			res++;
	}
	return (res);
}

function dutils_get_storage_left(arg0="item")
{
	return (dutils_get_itemcount(0, arg0));
}
