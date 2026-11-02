if (scr_debug())
{
    siner++;
    var _debug_xy = asset_get_index("obj_debug_xy");
    
    if (mouse_check_button(mb_right) && (_debug_xy == -1 || !instance_exists(_debug_xy)))
    {
        if (sprite_index != -1)
        {
            if (keyboard_check(vk_up))
                y -= 3;
            
            if (keyboard_check(vk_left))
                x -= 3;
            
            if (keyboard_check(vk_down))
                y += 3;
            
            if (keyboard_check(vk_right))
                x += 3;
        }
    }
}