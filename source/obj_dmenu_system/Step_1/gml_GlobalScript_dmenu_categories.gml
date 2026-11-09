function dmenu_create_category(arg0, arg1=[])
{
	var base_y = arg0
	var category_options = arg1;	

	for (var i = base_y; i < array_length(dbuttons); i++) {
		if (dbuttons[i].category != undefined)
			continue;

		base_y = i;
		break;
	}

	var cate_parent_btn = dbuttons[base_y];
	var cate_id = string(cate_parent_btn.data);

	cate_parent_btn.category = cate_id;
	dmenu_set_bttype(cate_parent_btn, "category");

	var collapsed = dmenu_category_collapsed(cate_id);
	cate_parent_btn.text += (!collapsed) ? " v" : " ^";

	if (!collapsed)
		array_push(dcategories_holder, [base_y, category_options]);
}

function dmenu_add_categories()
{
	var offset = 0;
	var nb_cat = array_length(dcategories_holder);

	for (var _cat = 0; _cat < nb_cat; _cat++)
	{
		var category_infos = dcategories_holder[_cat];

		var cate_y = category_infos[0] + offset;
		var category_options = category_infos[1];
		var cate_id = dbuttons[cate_y].category;
		var nb_subcat = array_length(category_options);

		for (var i = 0; i < nb_subcat; i++)
		{
			var cate_bt = category_options[i];
			if (typeof(cate_bt) == "string")	
				cate_bt = dmenu_makebt(cate_bt);

			cate_bt.category = cate_id;
			array_insert(dbuttons, cate_y + i + 1, cate_bt);
		}
		offset += nb_subcat;
	}
}

function dmenu_category_collapsed(arg0=undefined)
{
	if (arg0 == undefined)
		return (false);

	var nb_collapsed = array_length(dcollapsed_categories);
	for (var i = 0; i < nb_collapsed; i++) {
		if (dcollapsed_categories[i] == arg0)
			return (true);
	}
	return (false);
}
