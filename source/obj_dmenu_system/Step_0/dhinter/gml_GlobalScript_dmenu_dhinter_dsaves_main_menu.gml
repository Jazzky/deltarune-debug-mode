function dmenu_dhinter_dsaves_main_menu()
{
	dhinter_text = dstr(
		"[I] - Import individual\n[Alt+I] - Batch import",
		"[I] - Importation unique\n[Alt+I] - Importation par lot"
	);

	if (dvertical_index > 0)
	{
		dhinter_text = "";
		var real_index = cur_btn.indice;
		dhinter_text = debug_save_descriptions[real_index];
	}
}
