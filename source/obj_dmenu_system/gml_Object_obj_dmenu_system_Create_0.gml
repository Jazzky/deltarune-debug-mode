dmenu_reset_menu();

dmenu_start_index = 0;
dbutton_max_visible = 5;
dmenu_arrow_timer = 0;
dscroll_timer = 0;
dscroll_cur_key = 0;
dscroll_delay = 15;
dscroll_speed = 1;
dbackspace_timer = 0;

dhinter_active = false;
global.dload_cur_inv = 0;
dhinter_text = "";

dgiver_infos = {
	item_type : "",
	item_name : "",
	item_id : 0,
	owned_amt : 0,
	storage_space : 0
};

dbutton_indices = [];
ditem_types = ["items", "armors", "weapons", "keyitems"];
ditem_chap = global.chapter;

dmenu_init_warps();
dmenu_init_items();
dmenu_init_flags();
dmenu_init_global_changer();

dcustom_flag_text = ["", ""];
dkeyboard_input = "";
dkeys_helper = 0;
dkeys_data = [];

find_subarray_index = function(arg0, arg1)
{
    value = global.flag[arg0];
    lst = arg1;
    prev = 0;
    
    for (i = 0; i < array_length(lst); i++)
    {
        if (lst[i][1] > value)
            break;
        
        prev = i;
    }
    
    return prev;
};

set_keyboard_reader = function(arg0)
{
	dutils_toggle_kb(arg0);
    keyboard_string = "";
    dcustom_flag_text = ["", ""];
    global.dkeyboard_text = "";
};

dload_options = 
{
    target_save: -1,
    target_with_cur_inv: global.dload_cur_inv
};

dmenu_expanded = {};
dmenu_last_search = "";
dmenu_was_searching = false;
my_options = [];
