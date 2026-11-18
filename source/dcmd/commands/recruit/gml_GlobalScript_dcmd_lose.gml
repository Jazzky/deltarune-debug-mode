function dcmd_lose(argc, argv, flags)
{
	array_push(flags, "lose");
	return (dcmd_recruit(argc, argv, flags));
}

function dcmd_lose_chapter(argc, argv, flags)
{
	array_push(flags, "lose");
	return (dcmd_recruit_chapter(argc, argv, flags));
}

function dcmd_lose_all(argc, argv, flags)
{
	array_push(flags, "lose");
	return (dcmd_recruit_all(argc, argv, flags));
}
