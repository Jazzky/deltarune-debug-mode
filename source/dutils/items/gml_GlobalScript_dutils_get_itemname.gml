function _dutils_get_item_datavarname(arg0, arg1)
{
	var item_type = dutils_get_simplify_itemtype(arg0);
	var varname_type = arg1;

	switch (item_type) {
		case "item":
			switch (varname_type) {
				case "name":
					return ("itemnameb");

				case "desc":
					return ("itemdescb");
			}
			return (undefined);

		case "armor":
			switch (varname_type) {
				case "name":
					return ("armornametemp");

				case "desc":
					return ("armordesctemp");
			}
			return (undefined);

		case "weapon":
			switch (varname_type) {
				case "name":
					return ("weaponnametemp");

				case "desc":
					return ("weapondesctemp");
			}
			return (undefined);

		case "key":
			switch (varname_type) {
				case "name":
					return ("tempkeyitemname");

				case "desc":
					return ("tempkeyitemdesc");
			}
			return (undefined);
	}
	return (undefined);
}

function dutils_get_item_datavar(arg0, arg1, arg2)
{
	var item_id = arg0;
	var item_type = arg1;
	var varname = arg2;

	var item_type = dutils_get_simplify_itemtype(item_type);
	if (item_type == undefined)
		return ("[ERROR]");

	switch (item_type) {
		case "item":
			scr_iteminfo(item_id);
			break;

		case "armor":
			scr_armorinfo(item_id);
			break;

		case "weapon":
			scr_weaponinfo(item_id);
			break;

		case "key":
			scr_keyiteminfo(item_id);
			break;

		default:
			return ("[ERROR]");
	}

	var res = variable_instance_get(id, varname);
	return (res)
}

function dutils_get_itemname(arg0, arg1="items")
{
	var item_type = dutils_get_simplify_itemtype(arg1);

	var varname = _dutils_get_item_datavarname(item_type, "name");
	return (dutils_get_item_datavar(arg0, item_type, varname));
}

function dutils_get_itemdesc(arg0, arg1="items")
{
	var item_type = dutils_get_simplify_itemtype(arg1);

	var varname = _dutils_get_item_datavarname(item_type, "desc");
	return (dutils_get_item_datavar(arg0, item_type, varname));
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
