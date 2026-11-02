ADD_SCRIPT=""

ADD_OBJECT="""UndertaleGameObject FILE_NAME = new UndertaleGameObject();
FILE_NAME.Name = Data.Strings.MakeString("FILE_NAME");
FILE_NAME.Visible = {};
FILE_NAME.Persistent = {};
FILE_NAME.Awake = {};
Data.GameObjects.Add(FILE_NAME);
"""
