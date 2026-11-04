function dmenu_makebt(arg0="", arg1=-1, arg2=undefined)
{
	var res = {
		text: arg0,
		indice: arg1,
		xranges: arg2
	};

	if (arg2 == undefined)
		res.xranges = [0, 0];
	else if (typeof(arg2) == "number")
		res.xranges = [0, arg2 - 1];

	return (res);
}
