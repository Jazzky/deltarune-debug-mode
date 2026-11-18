function scr_dconsole_command(arg0)
{
	dconsole_exec(arg0);
	exit;
    static _commands = 
    {
        help: function(arg0, arg1, arg2)
        {
            var _names = variable_struct_get_names(arg2);
            array_sort(_names, true);
            var _list_string = "";
            
            for (var _i = 0; _i < array_length(_names); _i++)
            {
                _list_string += ("/" + _names[_i]);
                
                if (_i < (array_length(_names) - 1))
                    _list_string += ", ";
            }
            
            arg1(dstr("Available commands: ", "Commandes disponibles : ") + _list_string);
        },
        
        clear: function(arg0, arg1, arg2)
        {
            obj_dconsole_system.dconsole_log = [];
        },
        
        debug: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _val = string_lower(string(arg0[1]));
                
                if (_val == "on" || _val == "true" || _val == "1" || _val == "enable")
                {
                    global.debug = 1;
                    scr_debug_print(dstr("Debug Mode activated!", "Mode Debug activé !"));
                    arg1(dstr("Debug Mode activated!", "Mode Debug activé !"));
                }
                else if (_val == "off" || _val == "false" || _val == "0" || _val == "disable")
                {
                    global.debug = 0;
                    scr_debug_print(dstr("Debug Mode deactivated!", "Mode Debug désactivé !"));
                    arg1(dstr("Debug Mode deactivated!", "Mode Debug désactivé !"));
                }
                else
                {
                    arg1(dstr("Error: Invalid input. ", "Erreur : Saisie invalide. ") + "Usage -> /debug opt:[on/off]");
                }
            }
            else
            {
                global.debug = !global.debug;
                
                if (global.debug)
                {
                    scr_debug_print(dstr("Debug Mode activated!", "Mode Debug activé !"));
                    arg1(dstr("Debug Mode activated!", "Mode Debug activé !"));
                }
                else
                {
                    scr_debug_print(dstr("Debug Mode deactivated!", "Mode Debug désactivé !"));
                    arg1(dstr("Debug Mode deactivated!", "Mode Debug désactivé !"));
                }
            }
        },
        
        godmode: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _val = string_lower(string(arg0[1]));
                
                if (_val == "on" || _val == "true" || _val == "1" || _val == "enable")
                {
                    global.dgodmode = 1;
                    scr_debug_print(dstr("Godmode enabled", "Godmode activé"));
                    arg1(dstr("Godmode enabled", "Godmode activé"));
                }
                else if (_val == "off" || _val == "false" || _val == "0" || _val == "disable")
                {
                    global.dgodmode = 0;
                    scr_debug_print(dstr("Godmode disabled", "Godmode désactivé"));
                    arg1(dstr("Godmode disabled", "Godmode désactivé"));
                }
                else
                {
                    arg1(dstr("Error: Invalid input. ", "Erreur : Saisie invalide. ") + "Usage -> /godmode opt:[on/off]");
                }
            }
            else
            {
                global.dgodmode = !global.dgodmode;
                
                if (global.dgodmode)
                {
                    scr_debug_print(dstr("Godmode enabled", "Godmode activé"));
                    arg1(dstr("Godmode enabled", "Godmode activé"));
                }
                else
                {
                    scr_debug_print(dstr("Godmode disabled", "Godmode désactivé"));
                    arg1(dstr("Godmode disabled", "Godmode désactivé"));
                }
            }
        },
        
        setfps: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _fps_val = real(arg0[1]);
                global.speed_fps = _fps_val;
                game_set_speed(_fps_val, gamespeed_fps);
                scr_debug_print(dstr("FPS to ", "FPS à ") + string(_fps_val));
                arg1(dstr("FPS was set to ", "Le nombre de FPS a été fixé à ") + string(_fps_val));
            }
            else
            {
                arg1(dstr("Error: Missing argument. Usage -> /fps [value]", "Erreur : Argument manquant. Usage -> /fps [valeur]"));
            }
        },
        
        money: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _money_val = real(arg0[1]);
                var gold_bk = global.gold;
                global.gold = _money_val;
                var _diff_val = _money_val - gold_bk;
                
                if (_diff_val >= 0)
                    scr_debug_print(dstr("+ D$ ", "+ ") + string(_diff_val) + dstr("", " $"));
                else
                    scr_debug_print(dstr("- D$ ", "- ") + string(abs(_diff_val)) + dstr("", " $"));
                
                arg1(dstr("Money set to D$ ", "La somme d'argent a été fixée à ") + string(_money_val) + dstr("", " $"));
            }
            else
            {
                arg1(dstr("Error: Missing argument. Usage -> /money [value]", "Erreur : Argument manquant. Usage -> /money [valeur]"));
            }
        },
        
        vol: function(arg0, arg1, arg2)
        {
            if (array_length(arg0) > 1)
            {
                var _volume_val = real(arg0[1]);
                global.flag[17] = _volume_val / 100;
                audio_set_master_gain(0, global.flag[17]);
                scr_debug_print(dstr("Master volume set to ", "Volume principal réglé à ") + string(_volume_val) + dstr("%", " %"));
                arg1(dstr("Master volume set to ", "Volume principal réglé à ") + string(_volume_val) + dstr("%", " %"));
            }
            else
            {
                arg1(dstr("Error: Missing argument. Usage -> /vol [value]", "Erreur : Argument manquant. Usage -> /vol [valeur]"));
            }
        }
    };
    
    var _clean_string = string_delete(arg0, 1, 1);
    var _args = string_split(_clean_string, " ");
    
    if (array_length(_args) == 0)
        exit;
    
    var _cmd = string_lower(_args[0]);
    
    var _log = function(arg0)
    {
        if (dconsole_active)
            array_push(obj_dconsole_system.dconsole_log, "  -> " + arg0);
    };
    
    if (variable_struct_exists(_commands, _cmd))
    {
        var _func = variable_struct_get(_commands, _cmd);
        _func(_args, _log, _commands);
    }
    else
    {
        _log(dstr("Unknown command: /", "Commande inconnue : /") + _cmd + dstr(". Type /help to get a list of available commands", ". Tapez /help pour voir la liste des commandes disponibles"));
    }
}
