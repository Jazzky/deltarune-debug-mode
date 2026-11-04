function dmenu_reset_kb()
{
	var _limit = 10; //TODO change for a variable

	for (var i = 0; i < _limit; i++)
		dkeyboard_texts[i] = "";

	dutils_toggle_kb(false);
}
