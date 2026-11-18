function darray_copy_all(arg0)
{
	var src = arg0;
	var dest = [];

	array_copy(dest, 0, src, 0, array_length(src));
	return (dest);
}
