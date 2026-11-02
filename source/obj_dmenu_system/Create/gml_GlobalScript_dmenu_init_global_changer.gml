function dmenu_init_global_changer()
{
	dglobal_changer_options = [["Custom", "string", -1]];
	array_push(dglobal_changer_options, ["truename", "string", -1]);
	array_push(dglobal_changer_options, ["othername", "string", 6]);
	array_push(dglobal_changer_options, ["gold", "int", -1]);
	array_push(dglobal_changer_options, ["maxhp", "uint", 5]);
	array_push(dglobal_changer_options, ["hp", "int", 5]);
	array_push(dglobal_changer_options, ["at", "int", 5]);
	array_push(dglobal_changer_options, ["df", "int", 5]);
	array_push(dglobal_changer_options, ["mag", "int", 5]);
}
