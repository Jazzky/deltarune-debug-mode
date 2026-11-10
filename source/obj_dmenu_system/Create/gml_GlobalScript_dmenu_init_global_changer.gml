function dmenu_init_global_changer()
{
	dglobal_changer_options = [["", -1, "Custom"]];

	array_push(dglobal_changer_options, ["truename", -1, "truename"]);
	array_push(dglobal_changer_options, ["othername", 6, "othername"]);
	array_push(dglobal_changer_options, ["gold", -1, dstr("gold", "or")]);

	if (global.chapter == 3) {
		array_push(dglobal_changer_options, ["flag[1044]", -1, dstr("PTs", "PNTs")]);
	}

	if (global.chapter == 5) {
		array_push(dglobal_changer_options, ["flag[1411]", -1, dstr("F$", "$F")]);
	}

	array_push(dglobal_changer_options, ["maxhp", 5, "maxhp"]);
	array_push(dglobal_changer_options, ["hp", 5, "hp"]);
	array_push(dglobal_changer_options, ["at", 5, "at"]);
	array_push(dglobal_changer_options, ["df", 5, "df"]);
	array_push(dglobal_changer_options, ["mag", 5, "mag"]);
}
