function darray_length(arg0)
{
	var lst = arg0;
	var len = 0;

	while (lst[len] != undefined)
		len++;
	return (len);
}
