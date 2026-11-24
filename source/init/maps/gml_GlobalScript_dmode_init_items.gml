function dmode_init_item_id_map()
{
	var res_map = ds_map_create();

	ds_map_add(res_map, "item",		_dmode_init_item_id_map("item"));
	ds_map_add(res_map, "armor",	_dmode_init_item_id_map("armor"));
	ds_map_add(res_map, "weapon",	_dmode_init_item_id_map("weapon"));
	ds_map_add(res_map, "key",		_dmode_init_item_id_map("key"));
	ds_map_add(res_map, "litem",	_dmode_init_litem_id_map());

	return (res_map);
}

function _dmode_init_item_id_map(arg0)
{
	var item_type = arg0;

	var lst = [];
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
		
		lst[_id] = {
			item_id: _id,
			item_name: itemname,
			item_id_name: dutils_normalize_id(itemname)
		};
	}
	lst[0] = undefined;
	return (lst);
}

function _dmode_init_litem_id_map()
{
	var lst = [];
	var _old = global.litem[0];
	var _limit = 50;

	for (var _id = 0; _id < _limit; _id++) {
		global.litem[0] = _id;
		scr_litemname();
		
		var _name = global.litemname[0];
		if (_name == "" || _name == " ")
			continue;

		lst[_id] = {
			item_id: _id,
			item_name: _name,
			item_id_name: dutils_normalize_id(_name)
		};
	}

	global.litem[0] = _old;
	scr_litemname();
	return (lst);
}
