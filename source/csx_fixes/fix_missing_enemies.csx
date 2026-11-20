{

List<string> missing_enemies = new();

if (chapter == 3) {
	missing_enemies.Add("obj_berdlyplug_enemy");
}
else if (chapter == 4) {
	missing_enemies.Add("obj_berdlyplug_enemy");
}

for (int i = 0; i < missing_enemies.Count; i++) {
	string obj_name = missing_enemies[i];

	if (Data.GameObjects.ByName(obj_name) != null)
		continue;

	UndertaleGameObject new_obj = new UndertaleGameObject()
	{
		Name = Data.Strings.MakeString(obj_name),
		Visible = true,
		Persistent = false,
		Awake = true
	};
	Data.GameObjects.Add(new_obj);
}

importGroup = PatcherUtils.updateImportGroup();

importGroup.QueueAppend("gml_GlobalScript_scr_monstersetup", "");
missing_enemies.Clear();


}
