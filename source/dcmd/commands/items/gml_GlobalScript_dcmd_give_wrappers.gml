function dcmd_give_armor(argc, argv, flags)
{
	array_insert(argv, 1, "armor");
	return (dcmd_give_item(argc + 1, argv, flags));
}

function dcmd_give_weapon(argc, argv, flags)
{
	array_insert(argv, 1, "weapon");
	return (dcmd_give_item(argc + 1, argv, flags));
}

function dcmd_give_key_item(argc, argv, flags)
{
	array_insert(argv, 1, "key");
	return (dcmd_give_item(argc + 1, argv, flags));
}
