#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct flag_struct {
  int e, i, v, c, l, n;
  int h, s, f, o;
} FLAGS;

int flag_parce(int argc, char **argv, FLAGS *flags, char *token);
void print_flags(FLAGS flags);
void get_token_from_file(FILE *filename, char *token);
void print_fun(char *filename, FLAGS *flags, char *token, int num_of_files);
void find_pattern_without_ef(int argc, char **argv, char *token);
void pattern_former(FLAGS *flags, char *token, regex_t *pattern);
const struct option long_options[] = {{0, 0, 0, 0}};
int option_index = 0;