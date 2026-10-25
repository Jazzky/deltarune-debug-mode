EnsureDataLoaded();

if (!Data.IsVersionAtLeast(2023, 6))
{
    ScriptError("Erreur 0 : Ce script fonctionne uniquement pour la version payante de Deltarune.");
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

GlobalDecompileContext globalDecompileContext = new(Data);
Underanalyzer.Decompiler.IDecompileSettings decompilerSettings = new Underanalyzer.Decompiler.DecompileSettings();
UndertaleModLib.Compiler.CodeImportGroup importGroup = new(Data, globalDecompileContext, decompilerSettings)
{
    ThrowOnNoOpFindReplace = true
};

// SEPARATION
importGroup.Import();

ScriptMessage("Mode Debug du Chapitre CHAPTER_NUMBER ajouté.\r\n" + "Pour activer le Mode Debug en jeu, appuyer sur F10.");
