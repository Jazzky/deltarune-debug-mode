function dcmd_lose(argc, argv)
{
	argv[argc++] = "--lose";
	return (dcmd_recruit(argc, argv));
}

function dcmd_lost_chapter(argc, argv)
{
	argv[argc++] = "--lose";
	return (dcmd_recruit_chapter(argc, argv));
}

function dcmd_lose_all(argc, argv)
{
	argv[argc++] = "--lose";
	return (dcmd_recruit_all(argc, argv));
}
