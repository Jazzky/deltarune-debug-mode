function dcmd_give_item(argc, argv, flags)
{
	var item_id;
	var item_name;
	var item_type;
	var quantity;

	if (argc >= 4) {
		item_type = argv[1];
		item_name = argv[2];
		quantity = argv[3];
	}

	if (argc == 3) {
		var _valid_cate = _dcmd_fetch_item_category(argv[1]);
		if (_valid_cate) {
			item_type = argv[1];
			item_name = argv[2];
			quantity = 1;
		}
		else {
			item_type = undefined;
			item_name = argv[1];
			quantity = argv[2];
		}
	}

	if (argc == 2) {
		item_type = undefined;
		item_name = argv[1];
		quantity = 1;
	}


	item_name = string_replace(string_lower(item_name), " ", "");
	var item_infos = _dcmd_fetch_item_from_name(item_name, item_type);
	if (item_infos == undefined) {
		scr_derror_print("Error: couldn't find infos for item '" + item_name + "'");
		return (1);
	}

	item_type = item_infos[0];
	item_id = item_infos[1];

	if (!dutils_isint(string(quantity))) {
		scr_derror_print("Error: not enough information to give item '" + argv[1] + "'");
		return (1);
	}
	quantity = real(quantity);
	scr_debug_print("Preparing, item_id = " + string(item_id) + ", quantity = " + string(quantity) + ", type = " + item_type);
	return (_dcmd_give_item(item_id, item_type, quantity));
}

function _dcmd_give_item(arg0, arg1, arg2=1)
{
	var item_id = arg0;
	var item_type = arg1;
	var quantity = arg2;

	if (quantity == 0)
		return (0);

	var callfunc = (quantity >= 0) ? scr_itemget_anytype : scr_itemremove_anytype;

	for (var i = 0; i < abs(quantity); i++)
		callfunc(item_id, item_type);
}

function _dcmd_fetch_item_from_name(arg0, arg1=undefined)
{
	var itemname = arg0;
	var lookup_type = arg1;

	var lookup_order = [];
	if (lookup_type == undefined)
		lookup_order = ["item", "armor", "weapon", "key"];

	else {
		var itemtype = dutils_get_simplify_itemtype(lookup_type);
		if (itemtype == undefined)
			return (undefined);
		lookup_order = [itemtype];
	}

	var name_is_id = dutils_isuint(itemname);
	if (name_is_id) {
		if (lookup_type == undefined) {
			scr_derror_print("Error: cannot fetch item from id without type specification");
			return (undefined);
		}
		return ([lookup_order[0], real(itemname)]);
	}

	for (var i = 0; i < array_length(lookup_order); i++) {
		var cur_type = lookup_order[i];
		var itemtype_map = ds_map_find_value(global.item_id_map, cur_type);
		if (itemtype_map == undefined)
			continue;

		var attempt_id = ds_map_find_value(itemtype_map, itemname);
		if (attempt_id != undefined)
			return ([cur_type, attempt_id]);
	}
	scr_derror_print("Error: no item found with name '" + argv[1] + "'");
	return (undefined);
}
