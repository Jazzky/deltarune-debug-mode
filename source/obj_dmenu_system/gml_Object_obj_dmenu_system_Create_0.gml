dmenu_active = false;

dmenu_update_history("init");

dbutton_max_visible = 5;
dhinter_text = "";

dgiver_infos = {
	item_type : "",
	item_name : "",
	item_id : 0,
	owned_amt : 0,
	storage_space : 0
};

ditem_chap = global.chapter;

dmenu_init_warps();
dmenu_init_items();
dmenu_init_flags();
dmenu_init_global_changer();
dmenu_init_dsaves();

dkeyboard_texts = ["", "", "", "", ""];

dcategories_holder = [];
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
