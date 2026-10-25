EnsureDataLoaded();

if (!Data.IsVersionAtLeast(2023, 6))
{
    ScriptError("Erreur 0 : Ce script fonctionne uniquement pour la version LTS de la démo et la version payante de Deltarune.");
    return;
}

bool isFrenchPatch = false;
foreach (var str in Data.Strings)
{
    if (str.Content == "Français")
    {
        isFrenchPatch = true;
        break;
    }
}
string defaultLang = isFrenchPatch ? "fr" : "en";

bool isDemo = false;
foreach (var str in Data.Strings)
{
    if (str.Content == "1.19")
    {
        isDemo = true;
        break;
    }
}

string versionInfo = isDemo ? "\r\n[Version détectée : Démo Itch]" : "\r\n[Version détectée : Payante]";

GlobalDecompileContext globalDecompileContext = new(Data);
Underanalyzer.Decompiler.IDecompileSettings decompilerSettings = new Underanalyzer.Decompiler.DecompileSettings();
UndertaleModLib.Compiler.CodeImportGroup importGroup = new(Data, globalDecompileContext, decompilerSettings)
{
    ThrowOnNoOpFindReplace = false
};

if (isDemo)
{
    // Set obj_debug_gui
    UndertaleGameObject CREATE_obj_debug_gui = new UndertaleGameObject(); 
    CREATE_obj_debug_gui.Name = Data.Strings.MakeString("obj_debug_gui");
    CREATE_obj_debug_gui.Visible = true;
    CREATE_obj_debug_gui.CollisionShape = (CollisionShapeFlags)1;
    CREATE_obj_debug_gui.Awake = true;
    Data.GameObjects.Add(CREATE_obj_debug_gui);
}

// SEPARATION
importGroup.Import();

ScriptMessage("Mode Debug du Chapitre 1 ajouté.\r\n" + "Pour activer le Mode Debug en jeu, appuyer sur F10.");
