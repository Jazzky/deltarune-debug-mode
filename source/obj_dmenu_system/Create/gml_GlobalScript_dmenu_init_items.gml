function _dmenu_init_lw_item_data()
{
	var dnumber_litems = [0, 11, 14, 14, 18, 23];

	dlight_weapons = [];
	dlight_armors = [
		[3, dstr("Bandage", "Pansement")],
		[14, dstr("Wristwatch", "Montre")]
	];

	dlight_objects = [
		[1, dstr("Hot Chocolate", "Chocolat Chaud")],
		[2, dstr("Pencil", "Crayon")],
		[3, dstr("Bandage", "Pansement")],
		[4, dstr("Bouquet")],
		[5, dstr("Ball of Junk", "Boule de Trucs")],
		[6, dstr("Halloween Pencil", "Crayon Halloween")],
		[7, dstr("Lucky Pencil", "Crayon Fétiche")],
		[8, dstr("Egg", "Œuf")],
		[9, dstr("Cards", "Cartes")],
		[10, dstr("Box of Heart Candy", "Boîte de ChocoCœurs")],
		[11, dstr("Glass", "Verre")],
		[12, dstr("Eraser", "Gomme")],
		[13, dstr("Mech. Pencil", "Critérium")],
		[14, dstr("Wristwatch", "Montre")],
		[15, dstr("Holiday Pencil", "Crayon de Noël")],
		[16, dstr("CactusNeedle", "Épine de Cactus")],
		[17, dstr("BlackShard", "ÉclatNoir")],
		[18, dstr("QuillPen", "Stylo-Plume")],
		[19, dstr("Honey Toast", "Tartine de Miel")],
		[20, dstr("Bread", "Pain")],
		[21, dstr("Seeds", "Graines")],
		[22, dstr("Pencil2", "Crayon2")],
		[23, dstr("Petal", "Pétale")]
	];

	if (global.chapter >= 4)
	{
		var dtemp_lst = get_lw_dw_weapon_list();
		
		for (i = 0; i < array_length(dtemp_lst); i++)
			array_push(dlight_weapons, dlight_objects[dtemp_lst[i].lw_id]);
	}
	else
	{
		dlight_weapons = [
			[2, dstr("Pencil", "Crayon")],
			[6, dstr("Halloween Pencil", "Crayon Halloween")],
			[7, dstr("Lucky Pencil", "Crayon Fétiche")],
			[12, dstr("Eraser", "Gomme")],
			[13, dstr("Mech. Pencil", "Critérium")]
		];
	}

	for (i = 0; i < array_length(dlight_objects); i++)
	{
		if (dlight_objects[i][0] > dnumber_litems[global.chapter])
			array_delete(dlight_objects, i--, 1);
	}

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
