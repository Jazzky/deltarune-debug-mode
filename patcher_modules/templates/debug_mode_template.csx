using System;
using System.IO;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

using Underanalyzer;
using Underanalyzer.Decompiler;

using UndertaleModLib;
using UndertaleModLib.Compiler;
using UndertaleModLib.Decompiler;
using UndertaleModLib.Models;

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

static public class DPatcherUtils
{
	public static UndertaleData Data { get; set; }
	public static CodeImportGroup importGroup { get; set; }
	public static GlobalDecompileContext GlobalContext;
	public static DecompileSettings decompilerSettings;

	public static void init(UndertaleData baseData)
	{
		Data = baseData;
		decompilerSettings = new();
		importGroup = null;

		updateImportGroup();
	}

	public static CodeImportGroup updateImportGroup()
	{
		if (importGroup != null)
			importGroup.Import();

		GlobalContext = new(Data);
		importGroup = new(Data, GlobalContext, decompilerSettings)
		{
			ThrowOnNoOpFindReplace = true,
		};

		return (importGroup);
	}

	public static string readCode(string gmlName)
	{
		UndertaleCode codeEntry = Data.Code.ByName(gmlName);
		return new DecompileContext(GlobalContext, codeEntry, decompilerSettings).DecompileToString();
	}

	public static UndertaleGameObject registerObject(string objName, bool Visible = true,
			bool Persistent = false, bool Awake = true)
	{
		if (Data.GameObjects.ByName(objName) != null)
			throw new Exception($"Error, object `{objName}' already exist.");

		UndertaleGameObject new_obj = new UndertaleGameObject()
		{
			Name = Data.Strings.MakeString(objName),
			Visible = Visible,
			Persistent = Persistent,
			Awake = Awake
		};
		Data.GameObjects.Add(new_obj);
		return (new_obj);
	}
}

DPatcherUtils.init(Data);

var importGroup = DPatcherUtils.importGroup;

int chapter = CHAPTER_NUMBER;

// SEPARATION
importGroup.Import();

ScriptMessage("Mode Debug du Chapitre CHAPTER_NUMBER ajouté.\r\n" + "Pour activer le Mode Debug en jeu, appuyer sur F10.");
