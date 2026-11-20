function _dmenu_init_lw_item_data()
{
	var dnumber_litems = [0, 11, 14, 14, 18, 23];

	var all_litem = ds_map_find_value(global.item_id_map, "litem");

	dlight_objects = [];
	for (var i = 0; i < array_length(all_litem); i++) {
		if (i > dnumber_litems[global.chapter])
			break;

		var _cur_item = all_litem[i];
		if (_cur_item == undefined)
			continue;

		array_push(dlight_objects, _cur_item);
	}

	dlight_weapons = [];
	if (global.chapter >= 4)
	{
		var dtemp_lst = get_lw_dw_weapon_list();
		
		for (i = 0; i < array_length(dtemp_lst); i++)
			array_push(dlight_weapons, all_litem[dtemp_lst[i].lw_id - 1]);
	}
	else
	{
		dlight_weapons = [
			all_litem[2],
			all_litem[6],
			all_litem[7],
			all_litem[12],
			all_litem[13]
		];
	}

	dlight_armors = [
		all_litem[3],
		all_litem[14]
	];


	if (global.chapter == 1)
	{
		array_delete(dlight_weapons, 3, 2);
		array_delete(dlight_armors, 1, 1);
		array_delete(dlight_objects, 10, 1);
		array_delete(dlight_objects, 9, 1);
	}
}

function _dmenu_init_dw_item_data()
{
	global.ditem_data = [
		[],
		[ { start_id: 1,  count: 15 } ],
		[ { start_id: 16, count: 18 } ],
		[ { start_id: 34, count: 6  } ],
		[ { start_id: 60, count: 4  } ],
		[ { start_id: 40, count: 4  }, { start_id: 64, count: 7 } ]
	];

	global.darmor_data = [
		[],
		[ { start_id: 1,  count: 7 } ],
		[ { start_id: 8, count: 15 } ],
		[ { start_id: 23, count: 5  } ],
		[ { start_id: 50, count: 5  } ],
		[ { start_id: 30, count: 9  }]
	];

	global.dweapon_data = [
		[],
		[ { start_id: 1,  count: 10 } ],
		[ { start_id: 11, count: 12 } ],
		[ { start_id: 23, count: 4  } ],
		[ { start_id: 50, count: 5  } ],
		[ { start_id: 30, count: 8  }]
	];

	global.dkeyitem_data = [
		[],
		[ { start_id: 1,  count: 7 } ],
		[ { start_id: 8, count: 8 } ],
		[ { start_id: 16, count: 4  } ],
		[ { start_id: 30, count: 2  } ],
		[ { start_id: 20, count: 10  }, { start_id: 32, count: 2} ]
	];
}

function dmenu_init_items()
{
	_dmenu_init_dw_item_data();
	_dmenu_init_lw_item_data();
}

function dmenu_get_item_index_data(arg0, arg1)
{
	var _chap = arg0;
	var _type = arg1;

	var _lookup_lst = [];
	switch (_type) {
		case "items":
			_lookup_lst = global.ditem_data;
			break;

		case "armors":
			_lookup_lst = global.darmor_data;
			break;

		case "weapons":
			_lookup_lst = global.dweapon_data;
			break;

		case "keyitems":
			_lookup_lst = global.dkeyitem_data;
			break;
	}

	if (_chap < 0 || _chap >= array_length(_lookup_lst))
		return ([]);
	return (_lookup_lst[_chap]);
}
