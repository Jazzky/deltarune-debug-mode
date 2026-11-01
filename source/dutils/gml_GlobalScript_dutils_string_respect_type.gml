function scr_string_respect_type(arg0, arg1, arg2, arg3)
{
    str = arg0;
    type = arg1;
    check_empty = arg2;
    print_error = arg3;
    
    if (string_length(str) == 0 && check_empty)
    {
        scr_debug_print(dstr("Empty flag", "Flag vide"));
        return 0;
    }
    
    if (type == "string")
        return 1;
    
    is_good = 1;
    saw_dot = 0;
    saw_neg = 0;
    var is_var_step = 0;
    
    for (c = 1; c <= string_length(str); c++)
    {
        cur_char = string_char_at(str, c);
        char_is_digit = scr_84_is_digit(cur_char);
        char_is_letter = (cur_char >= "a" && cur_char <= "z") || (cur_char >= "A" && cur_char <= "Z");
        
        if (type != "variable")
        {
            if (!saw_dot && type == "real" && cur_char == ".")
            {
                saw_dot = 1;
            }
            else if (!saw_neg && type != "uint" && cur_char == "-")
            {
                saw_neg = 1;
            }
            else if (!char_is_digit)
            {
                if (print_error)
                    scr_debug_print(dstr("Invalid flag ", "Flag invalide ") + "|" + string(str) + "|" + dstr(" because of ", " à cause de ") + "|" + cur_char + "|");
                
                is_good = 0;
                break;
            }
        }
        else if ((is_var_step == 0 || is_var_step == 1) && (char_is_letter || cur_char == "_"))
        {
            is_var_step = 1;
        }
        else if (is_var_step == 1 && cur_char == "[")
        {
            is_var_step = 2;
        }
        else if ((is_var_step == 2 || is_var_step == 3) && char_is_digit)
        {
            is_var_step = 3;
        }
        else if (is_var_step == 3 && cur_char == "]")
        {
            is_var_step = 4;
        }
        else
        {
            if (print_error)
                scr_debug_print(dstr("Error reading variable |", "Erreur de lecture de variable |") + string(str) + dstr("| at |", "| à |") + string(cur_char) + "|");
            
            is_good = 0;
            break;
        }
    }
    
    if (type == "variable" && is_good && (is_var_step != 4 && is_var_step != 1))
    {
        if (print_error)
            scr_debug_print(dstr("Error: Invalid variable name |", "Erreur : Nom de variable invalide |") + string(str) + "|");
        
        is_good = 0;
    }
    
    return is_good;
}