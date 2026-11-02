function dutils_set_kb_text(arg0)
{
	global.kb_text = arg0;
}

function dutils_get_kb_text()
{
	return (global.kb_text);
}

function dutils_toggle_kb(arg0=undefined)
{
	if (arg0 == undefined)
		global.dreading_kb = !global.dreading_kb;
	else
		global.dreading_kb = arg0;
}

function dutils_reading_kb()
{
	return (global.dreading_kb);
}
