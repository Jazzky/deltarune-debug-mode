if (scr_debug())
{
    var _debug_xy = asset_get_index("obj_debug_xy");
    
    if (mouse_check_button(mb_right) && (_debug_xy == -1 || !instance_exists(_debug_xy)))
    {
        if (sprite_index != -1)
            draw_sprite_ext_flash(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, (sin(siner / 8) * 0.5) + 0.5);
    }
}