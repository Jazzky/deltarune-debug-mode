#include <string.h>
#include <stdlib.h>
#include <stdio.h>

char *test(char *str, int _max)
{
	if (_max <= 0)
		_max = 999999;

	char *ret_str = malloc(1000);
	int ret_len = 0;
	int line_len = 0;

	char *cur_word = malloc(1000);
	int word_len = 0;

	int str_len = strlen(str);
	for (int i = 0; i < str_len; i++) {
		char mychar = str[i];

		int is_sep = (mychar == ' ' || mychar == '\n');
		if (!is_sep) {
			cur_word[word_len++] = mychar;
		}

		if (is_sep || i == (str_len - 1)) {
			if (line_len != 0 && (word_len + line_len) > _max) {
				ret_str[ret_len++] = '\n';
				line_len = 0;
			}

			for (int j = 0; j < word_len; j++) {
				char c = cur_word[j];

				if (line_len == _max) {
					ret_str[ret_len++] = '\n';
					line_len = 0;
				}
				ret_str[ret_len++] = c;
				line_len++;
			}
			memset(cur_word, 0, word_len);
			word_len = 0;

			if (is_sep)
				ret_str[ret_len++] = mychar;

			if (mychar == '\n')
				line_len = 0;
			else
				line_len++;
		}
	}
	free(cur_word);
	ret_str[ret_len] = 0;
	return (ret_str);
}

int main(int ac, char **av)
{
	if (ac == 1)
		return (1);

	int max_len = 10;
	for (int i = 0; i < max_len; i++)
		printf("-");
	printf("\n");

	char *cool = test(av[1], max_len);
	printf("%s\n", cool);
	free(cool);
	return (0);
}
