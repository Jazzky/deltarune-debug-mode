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
	
	dmenu_set_bttype(cate_parent_btn, "category");
	for (var i = 0; i < array_length(category_options); i++)
	{
		var cate_bt = category_options[i];
		if (typeof(cate_bt) == "string")	
			cate_bt = dmenu_makebt(cate_bt);

		cate_bt.category = cate_id;
		array_insert(dbuttons, base_y + i + 1, cate_bt);
	}
}
