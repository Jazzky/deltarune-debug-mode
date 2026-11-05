function dmenu_makebt(arg0="", arg1=-1, arg2=undefined)
{
	var res = {
		text: arg0,
		data: arg1,
		xranges: arg2
	};

	if (arg2 == undefined)
		res.xranges = [0, 0];
	else if (typeof(arg2) == "number")
		res.xranges = [0, arg2 - 1];

	dmenu_set_bttype(res)
	res.category = undefined;
	return (res);
}

function dmenu_set_bttype(arg0, arg1=undefined)
{
	var bt = arg0;
	var bt_type = arg1

	bt.type = bt_type;
}
