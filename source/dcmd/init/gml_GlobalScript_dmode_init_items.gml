function dmode_init_item_id_map()
{
	var res_map = ds_map_create();

	ds_map_add(res_map, "item",		_dmode_init_item_id_map("item"));
	ds_map_add(res_map, "armor",	_dmode_init_item_id_map("armor"));
	ds_map_add(res_map, "weapon",	_dmode_init_item_id_map("weapon"));
	ds_map_add(res_map, "key",		_dmode_init_item_id_map("key"));

	return (res_map);
}

function _dmode_init_item_id_map(arg0)
{
	var item_type = arg0;

	var res_map = ds_map_create();
	var _max_id = 150;

	var callfunc = undefined;
	var namevar = "";

	switch (item_type) {
		case "item":
			callfunc = scr_iteminfo;
			namevar = "itemnameb";
			break;

		case "armor":
			callfunc = scr_armorinfo;
			namevar = "armornametemp";
			break;

		case "weapon":
			callfunc = scr_weaponinfo;
			namevar = "weaponnametemp";
			break;

		case "key":
			callfunc = scr_keyiteminfo;
			namevar = "tempkeyitemname";
			_max_id = 70;
			break;
	}

	for (var _id = 1; _id < _max_id; _id++) {
		callfunc(_id);
		
		var itemname = variable_instance_get(id, namevar);
		if (itemname == undefined)
			continue;

		if (itemname == "" || itemname == " ")
			continue;
		
		var simple_itemname = string_replace(string_lower(itemname), " ", "");
		ds_map_add(res_map, itemname, _id);
		ds_map_add(res_map, simple_itemname, _id);
	}
	return (res_map);
}
