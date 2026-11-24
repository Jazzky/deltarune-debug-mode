{

string _encounter_gml = "gml_GlobalScript_scr_encountersetup";
string _encounter_code = DPatcherUtils.readCode(_encounter_gml);

string _findtype_regex = @"global.monsterinstancetype\[[0-9]] = ([a-zA-Z_][a-zA-Z0-9_]*);";

var _reg = Regex.Match(_encounter_code, _findtype_regex);

HashSet<string> falseEnemies = new();

while (_reg.Success) {
	string _enemy_obj = $"{_reg.Groups[1]}";
	
	if (!falseEnemies.Contains(_enemy_obj)) {
		if (Data.GameObjects.ByName(_enemy_obj) == null)
			falseEnemies.Add(_enemy_obj);
	}

	_reg = _reg.NextMatch();
}

if (falseEnemies.Count != 0)
{
	foreach (string falseEnemy in falseEnemies) {
		Console.WriteLine($"Removing {falseEnemy}...");
		_encounter_code = Regex.Replace(_encounter_code, falseEnemy, "-4");
	}

	importGroup.QueueReplace(_encounter_gml, _encounter_code);
}

falseEnemies.Clear();

}
