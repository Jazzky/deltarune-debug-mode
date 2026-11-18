function dpop_history()
{
	dmenu_reset_kb();
    
	dmenu_popped_index = true;
    if (array_length(dmenu_state_history) == 0)
    {
		dmenu_reset_menu();
        dmenu_state_update();
		exit;
    }
    
	dmenu_update_history("pop");
};

function dmenu_update_history(arg0="add")
{
	var method = arg0;

	var historics = [
		["dmenu_state", "dmenu_state_history", ""],
		["dvertical_index", "dvertical_index_history", 0],
		["dmenu_start_index", "dmenu_start_index_history", 0],
		["dhorizontal_index", "dhorizontal_index_history", 0],
		["dhorizontal_page", "dhorizontal_page_history", 0],
		["dcollapsed_categories", "dcollapsed_categories_history", []]
	];

	var _len = array_length(historics);
	for (var i = 0; i < _len; i++) {
		var state_varname = historics[i][0];
		var historic_varname = historics[i][1];
		var default_val = historics[i][2];

		var historic = variable_instance_get(id, historic_varname);

		if (method == "add") {
			array_push(historic, variable_instance_get(id, state_varname));
			variable_instance_set(id, state_varname, default_val);
		}
		else if (method == "pop") {
			variable_instance_set(id, state_varname, array_pop(historic));
		}
		else if (method == "init") {
			variable_instance_set(id, historic_varname, []);
			variable_instance_set(id, state_varname, default_val);
		}
	}
}
